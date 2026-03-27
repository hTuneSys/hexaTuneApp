// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

package com.hexatune.hexatuneapp

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat
import kotlin.math.abs
import kotlin.math.max

class DspAudioService : Service() {
    private var audioTrack: AudioTrack? = null
    private var renderThread: Thread? = null
    @Volatile private var isRendering = false
    private var enginePtr: Long = 0
    @Volatile var totalFramesRendered: Long = 0
        private set

    private var audioFocusRequest: AudioFocusRequest? = null
    private var wakeLock: PowerManager.WakeLock? = null

    private val audioAttributes: AudioAttributes = AudioAttributes.Builder()
        .setUsage(AudioAttributes.USAGE_MEDIA)
        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
        .build()

    companion object {
        private const val TAG = "HTD"
        private const val FRAMES_PER_BUFFER = 1024
        private const val LOG_INTERVAL_FRAMES = 48000L
        private const val NOTIFICATION_ID = 1125
        private const val CHANNEL_ID = "hexatune_dsp_render"

        const val ACTION_START = "com.hexatune.dsp.ACTION_START"
        const val ACTION_STOP = "com.hexatune.dsp.ACTION_STOP"
        const val EXTRA_SAMPLE_RATE = "sampleRate"
        const val EXTRA_ENGINE_PTR = "enginePtr"
    }

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "DspAudioService created")
        ensureNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                val sampleRate = intent.getIntExtra(EXTRA_SAMPLE_RATE, 48000)
                val ptr = intent.getLongExtra(EXTRA_ENGINE_PTR, 0L)
                Log.i(TAG, "Service START: rate=$sampleRate ptr=0x${ptr.toULong().toString(16)}")
                startForeground(NOTIFICATION_ID, buildNotification())
                startRendering(sampleRate, ptr)
            }
            ACTION_STOP -> {
                Log.i(TAG, "Service STOP requested")
                stopRendering()
                stopSelf()
            }
            else -> {
                Log.w(TAG, "Service started without action, stopping")
                startForeground(NOTIFICATION_ID, buildNotification())
                stopSelf()
            }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        Log.i(TAG, "DspAudioService destroying, frames=$totalFramesRendered")
        stopRendering()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // -------------------------------------------------------------------------
    // Rendering
    // -------------------------------------------------------------------------

    private fun startRendering(sampleRate: Int, enginePointer: Long) {
        if (isRendering) {
            Log.w(TAG, "startRendering ignored: already rendering")
            return
        }
        enginePtr = enginePointer
        totalFramesRendered = 0

        requestAudioFocus()
        acquireWakeLock()

        val minBufSize = AudioTrack.getMinBufferSize(
            sampleRate,
            AudioFormat.CHANNEL_OUT_STEREO,
            AudioFormat.ENCODING_PCM_FLOAT
        )

        Log.i(TAG, "AudioTrack: rate=$sampleRate minBuf=$minBufSize ptr=0x${enginePointer.toULong().toString(16)}")

        audioTrack = AudioTrack.Builder()
            .setAudioAttributes(audioAttributes)
            .setAudioFormat(
                AudioFormat.Builder()
                    .setSampleRate(sampleRate)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_STEREO)
                    .setEncoding(AudioFormat.ENCODING_PCM_FLOAT)
                    .build()
            )
            .setBufferSizeInBytes(maxOf(minBufSize * 2, FRAMES_PER_BUFFER * 2 * 4 * 2))
            .setTransferMode(AudioTrack.MODE_STREAM)
            .build()

        isRendering = true
        audioTrack?.play()

        renderThread = Thread({
            android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO)
            val buffer = FloatArray(FRAMES_PER_BUFFER * 2)
            var framesSinceLog = 0L
            var renderCallCount = 0L
            val startTimeNs = System.nanoTime()

            Log.i(TAG, "Render thread started (Service-owned)")

            while (isRendering) {
                val result = DspNativeAudioBridge.nativeRender(enginePtr, buffer, FRAMES_PER_BUFFER)
                if (result != 0) {
                    Log.e(TAG, "Render error code=$result at frame=$totalFramesRendered")
                    break
                }

                renderCallCount++
                totalFramesRendered += FRAMES_PER_BUFFER
                framesSinceLog += FRAMES_PER_BUFFER

                if (framesSinceLog >= LOG_INTERVAL_FRAMES) {
                    val elapsedMs = (System.nanoTime() - startTimeNs) / 1_000_000
                    val elapsedSec = elapsedMs / 1000.0

                    var peakL = 0f
                    var peakR = 0f
                    for (i in buffer.indices step 2) {
                        peakL = max(peakL, abs(buffer[i]))
                        if (i + 1 < buffer.size) peakR = max(peakR, abs(buffer[i + 1]))
                    }

                    Log.d(TAG, "Render stats [${String.format("%.1f", elapsedSec)}s]: frames=$totalFramesRendered peakL=%.4f peakR=%.4f silent=${peakL == 0f && peakR == 0f}".format(peakL, peakR))
                    framesSinceLog = 0
                }

                val written = audioTrack?.write(buffer, 0, buffer.size, AudioTrack.WRITE_BLOCKING) ?: -1
                if (written < 0) {
                    Log.e(TAG, "AudioTrack write error=$written")
                    break
                }
            }

            val totalSec = totalFramesRendered / 48000.0
            Log.i(TAG, "Render thread stopped: $totalFramesRendered frames (${String.format("%.1f", totalSec)}s)")
        }, "DSP-Render")
        renderThread?.start()
    }

    private fun stopRendering() {
        if (!isRendering && renderThread == null) return
        Log.i(TAG, "Stop rendering: rendered $totalFramesRendered frames")
        isRendering = false
        renderThread?.join(1000)
        renderThread = null
        try {
            audioTrack?.stop()
        } catch (_: Exception) {}
        audioTrack?.release()
        audioTrack = null
        enginePtr = 0
        releaseWakeLock()
        abandonAudioFocus()
    }

    // -------------------------------------------------------------------------
    // Audio focus
    // -------------------------------------------------------------------------

    private fun requestAudioFocus() {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                .setAudioAttributes(audioAttributes)
                .setOnAudioFocusChangeListener { focusChange ->
                    Log.d(TAG, "Audio focus changed: $focusChange")
                }
                .build()
            val result = audioManager.requestAudioFocus(audioFocusRequest!!)
            Log.i(TAG, "Audio focus request result: $result")
        } else {
            @Suppress("DEPRECATION")
            audioManager.requestAudioFocus(
                { focusChange -> Log.d(TAG, "Audio focus changed: $focusChange") },
                AudioManager.STREAM_MUSIC,
                AudioManager.AUDIOFOCUS_GAIN
            )
        }
    }

    private fun abandonAudioFocus() {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocusRequest?.let { audioManager.abandonAudioFocusRequest(it) }
            audioFocusRequest = null
        }
        Log.i(TAG, "Audio focus abandoned")
    }

    // -------------------------------------------------------------------------
    // Wake lock
    // -------------------------------------------------------------------------

    @SuppressLint("WakelockTimeout")
    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "hexatune:dsp_render"
        ).apply { acquire() }
        Log.i(TAG, "Wake lock acquired")
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) it.release()
            wakeLock = null
        }
        Log.i(TAG, "Wake lock released")
    }

    // -------------------------------------------------------------------------
    // Notification
    // -------------------------------------------------------------------------

    private fun ensureNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "HexaTune Audio Engine",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Audio rendering engine"
                setShowBadge(false)
            }
            val nm = getSystemService(NotificationManager::class.java)
            nm?.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = if (launchIntent != null) {
            PendingIntent.getActivity(
                this, 0, launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        } else null

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("HexaTune")
            .setContentText("Audio engine running")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setOngoing(true)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(pendingIntent)
            .build()
    }
}
