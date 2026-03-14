// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

package com.hexatune.hexatuneapp

import android.content.Context
import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Detects wired and wireless (including BLE) audio device connections
 * using [AudioManager.registerAudioDeviceCallback].
 *
 * Communicates with the Dart side via a [MethodChannel] for queries
 * and an [EventChannel] for real-time connection/disconnection events.
 */
class AudioDeviceDetector(
    private val context: Context,
    private val methodChannel: MethodChannel,
    private val eventChannel: EventChannel,
) {
    private var eventSink: EventChannel.EventSink? = null
    private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    private val mainHandler = Handler(Looper.getMainLooper())

    private val audioDeviceCallback = object : AudioDeviceCallback() {
        override fun onAudioDevicesAdded(addedDevices: Array<out AudioDeviceInfo>) {
            for (device in addedDevices) {
                if (!device.isSink) continue
                when {
                    device.isWiredHeadset() -> sendEvent("wired_connected")
                    device.isWirelessHeadset() -> sendEvent("wireless_connected")
                }
            }
        }

        override fun onAudioDevicesRemoved(removedDevices: Array<out AudioDeviceInfo>) {
            for (device in removedDevices) {
                if (!device.isSink) continue
                when {
                    device.isWiredHeadset() -> sendEvent("wired_disconnected")
                    device.isWirelessHeadset() -> sendEvent("wireless_disconnected")
                }
            }
        }
    }

    fun start() {
        methodChannel.setMethodCallHandler(::onMethodCall)

        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                audioManager.registerAudioDeviceCallback(audioDeviceCallback, mainHandler)
            }

            override fun onCancel(arguments: Any?) {
                audioManager.unregisterAudioDeviceCallback(audioDeviceCallback)
                eventSink = null
            }
        })
    }

    fun stop() {
        audioManager.unregisterAudioDeviceCallback(audioDeviceCallback)
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCurrentState" -> {
                val devices = audioManager.getDevices(AudioManager.GET_DEVICES_OUTPUTS)
                val wired = devices.any { it.isSink && it.isWiredHeadset() }
                val wireless = devices.any { it.isSink && it.isWirelessHeadset() }
                result.success(mapOf("wired" to wired, "wireless" to wireless))
            }
            else -> result.notImplemented()
        }
    }

    private fun sendEvent(event: String) {
        mainHandler.post { eventSink?.success(event) }
    }

    private fun AudioDeviceInfo.isWiredHeadset(): Boolean {
        return type == AudioDeviceInfo.TYPE_WIRED_HEADPHONES ||
                type == AudioDeviceInfo.TYPE_WIRED_HEADSET ||
                type == AudioDeviceInfo.TYPE_USB_HEADSET ||
                type == AudioDeviceInfo.TYPE_USB_DEVICE
    }

    private fun AudioDeviceInfo.isWirelessHeadset(): Boolean {
        val isBle = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            type == AudioDeviceInfo.TYPE_BLE_HEADSET ||
                    type == AudioDeviceInfo.TYPE_BLE_SPEAKER
        } else {
            false
        }
        return type == AudioDeviceInfo.TYPE_BLUETOOTH_A2DP ||
                type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO ||
                isBle
    }
}
