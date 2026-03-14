// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

package com.hexatune.hexatuneapp

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.util.Log
import kotlin.math.abs
import kotlin.math.max

class DspAudioService {
    private var audioTrack: AudioTrack? = null
    private var renderThread: Thread? = null
    @Volatile private var isPlaying = false
    private var enginePtr: Long = 0
    @Volatile var totalFramesRendered: Long = 0
        private set

    companion object {
        private const val TAG = "HTD"
        private const val FRAMES_PER_BUFFER = 1024
        private const val LOG_INTERVAL_FRAMES = 48000L
    }

    fun start(sampleRate: Int, enginePointer: Long) {
        if (isPlaying) return
        enginePtr = enginePointer
        totalFramesRendered = 0

        val minBufSize = AudioTrack.getMinBufferSize(
            sampleRate,
            AudioFormat.CHANNEL_OUT_STEREO,
            AudioFormat.ENCODING_PCM_FLOAT
        )

        Log.i(TAG, "AudioTrack setup: sampleRate=$sampleRate, minBufSize=$minBufSize, enginePtr=0x${enginePointer.toULong().toString(16)}")

        audioTrack = AudioTrack.Builder()
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            )
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

        isPlaying = true
        audioTrack?.play()

        renderThread = Thread({
            android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO)
            val buffer = FloatArray(FRAMES_PER_BUFFER * 2)
            var framesSinceLog = 0L
            var renderCallCount = 0L
            val startTimeNs = System.nanoTime()

            Log.i(TAG, "Render thread started")

            while (isPlaying) {
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

    fun stop() {
        Log.i(TAG, "Stop requested: rendered $totalFramesRendered frames")
        isPlaying = false
        renderThread?.join(1000)
        renderThread = null
        try {
            audioTrack?.stop()
        } catch (_: Exception) {}
        audioTrack?.release()
        audioTrack = null
        enginePtr = 0
    }
}
