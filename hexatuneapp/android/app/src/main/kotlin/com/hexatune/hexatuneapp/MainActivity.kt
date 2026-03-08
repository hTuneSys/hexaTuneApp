package com.hexatune.hexatuneapp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var audioDeviceDetector: AudioDeviceDetector? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel()
        setupAudioDeviceDetector()
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
