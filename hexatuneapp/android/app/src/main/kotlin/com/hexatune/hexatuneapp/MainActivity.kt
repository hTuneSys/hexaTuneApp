package com.hexatune.hexatuneapp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var audioDeviceDetector: AudioDeviceDetector? = null
    private val dspDecoder = DspAudioDecoder()
    private val dspDecodeCache = HashMap<String, DspAudioDecoder.DecodedAudio>()

    companion object {
        private const val TAG = "HTD"

        fun encodeAssetPath(path: String): String =
            path.replace("#", "%23")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
        setupAudioDeviceDetector()
        setupDspAudioChannel()
    }

    override fun onDestroy() {
        audioDeviceDetector?.stop()
        audioDeviceDetector = null
        super.onDestroy()
    }

    private fun setupAudioDeviceDetector() {
        val messenger = flutterEngine?.dartExecutor?.binaryMessenger ?: return
        val methodChannel = MethodChannel(messenger, "com.hexatune/audio_device_detector")
        val eventChannel = EventChannel(messenger, "com.hexatune/audio_device_events")
        audioDeviceDetector = AudioDeviceDetector(this, methodChannel, eventChannel).also {
            it.start()
        }
    }

    private fun getOrDecode(assetPath: String): DspAudioDecoder.DecodedAudio {
        return dspDecodeCache[assetPath] ?: run {
            val afd = assets.openFd("flutter_assets/${encodeAssetPath(assetPath)}")
            val decoded = dspDecoder.decodeAsset(afd, assetPath)
            dspDecodeCache[assetPath] = decoded
            decoded
        }
    }

    private fun setupDspAudioChannel() {
        val messenger = flutterEngine?.dartExecutor?.binaryMessenger ?: return
        MethodChannel(messenger, "com.hexatune/dsp_audio").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "startAudio" -> {
                        val sampleRate = call.argument<Int>("sampleRate") ?: 48000
                        val enginePtr = call.argument<Number>("enginePtr")?.toLong() ?: 0L
                        val intent = Intent(this@MainActivity, DspAudioService::class.java).apply {
                            action = DspAudioService.ACTION_START
                            putExtra(DspAudioService.EXTRA_SAMPLE_RATE, sampleRate)
                            putExtra(DspAudioService.EXTRA_ENGINE_PTR, enginePtr)
                        }
                        ContextCompat.startForegroundService(this@MainActivity, intent)
                        result.success(null)
                    }
                    "stopAudio" -> {
                        stopService(Intent(this@MainActivity, DspAudioService::class.java))
                        result.success(null)
                    }

                    "loadBase" -> {
                        val assetPath = call.argument<String>("assetPath")!!
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        Thread {
                            try {
                                val decoded = getOrDecode(assetPath)
                                val rc = DspNativeAudioBridge.nativeSetBase(
                                    enginePtr, decoded.samples, decoded.numFrames, decoded.channels
                                )
                                Log.i(TAG, "loadBase: $assetPath -> rc=$rc (frames=${decoded.numFrames})")
                                runOnUiThread { result.success(rc) }
                            } catch (e: Exception) {
                                Log.e(TAG, "loadBase failed: ${e.message}")
                                runOnUiThread { result.error("DECODE", e.message, null) }
                            }
                        }.start()
                    }

                    "loadTexture" -> {
                        val assetPath = call.argument<String>("assetPath")!!
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        val index = call.argument<Int>("index")!!
                        Thread {
                            try {
                                val decoded = getOrDecode(assetPath)
                                val rc = DspNativeAudioBridge.nativeSetTexture(
                                    enginePtr, index, decoded.samples, decoded.numFrames, decoded.channels
                                )
                                Log.i(TAG, "loadTexture[$index]: $assetPath -> rc=$rc")
                                runOnUiThread { result.success(rc) }
                            } catch (e: Exception) {
                                Log.e(TAG, "loadTexture failed: ${e.message}")
                                runOnUiThread { result.error("DECODE", e.message, null) }
                            }
                        }.start()
                    }

                    "loadEvent" -> {
                        val assetPath = call.argument<String>("assetPath")!!
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        val index = call.argument<Int>("index")!!
                        val minMs = call.argument<Int>("minIntervalMs") ?: 3000
                        val maxMs = call.argument<Int>("maxIntervalMs") ?: 8000
                        val volMin = call.argument<Double>("volumeMin")?.toFloat() ?: 0.3f
                        val volMax = call.argument<Double>("volumeMax")?.toFloat() ?: 0.8f
                        val panMin = call.argument<Double>("panMin")?.toFloat() ?: -0.5f
                        val panMax = call.argument<Double>("panMax")?.toFloat() ?: 0.5f
                        Thread {
                            try {
                                val decoded = getOrDecode(assetPath)
                                val rc = DspNativeAudioBridge.nativeSetEvent(
                                    enginePtr, index,
                                    decoded.samples, decoded.numFrames, decoded.channels,
                                    minMs, maxMs, volMin, volMax, panMin, panMax
                                )
                                Log.i(TAG, "loadEvent[$index]: $assetPath -> rc=$rc")
                                runOnUiThread { result.success(rc) }
                            } catch (e: Exception) {
                                Log.e(TAG, "loadEvent failed: ${e.message}")
                                runOnUiThread { result.error("DECODE", e.message, null) }
                            }
                        }.start()
                    }

                    "clearBase" -> {
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        result.success(DspNativeAudioBridge.nativeClearBase(enginePtr))
                    }
                    "clearTexture" -> {
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        val index = call.argument<Int>("index")!!
                        result.success(DspNativeAudioBridge.nativeClearTexture(enginePtr, index))
                    }
                    "clearEvent" -> {
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        val index = call.argument<Int>("index")!!
                        result.success(DspNativeAudioBridge.nativeClearEvent(enginePtr, index))
                    }
                    "clearAllLayers" -> {
                        val enginePtr = call.argument<Number>("enginePtr")!!.toLong()
                        result.success(DspNativeAudioBridge.nativeClearAllLayers(enginePtr))
                    }
                    "clearDecodeCache" -> {
                        val count = dspDecodeCache.size
                        dspDecodeCache.clear()
                        Log.i(TAG, "Decode cache cleared ($count entries)")
                        result.success(count)
                    }

                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "hexaTune_channel"
            val channelName = "hexaTune Background Service"
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = "Notification channel for hexaTune"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager?.createNotificationChannel(channel)
        }
    }
}
