// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

package com.hexatune.hexatuneapp

import android.content.res.AssetFileDescriptor
import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import android.util.Log
import java.nio.ByteBuffer
import java.nio.ByteOrder

class DspAudioDecoder {

    data class DecodedAudio(
        val samples: FloatArray,
        val numFrames: Int,
        val channels: Int,
        val sampleRate: Int
    )

    companion object {
        private const val TAG = "HTD"
    }

    fun decodeAsset(afd: AssetFileDescriptor, debugName: String): DecodedAudio {
        val lowerName = debugName.lowercase()
        return if (lowerName.endsWith(".wav")) {
            decodeWav(afd, debugName)
        } else {
            decodeWithMediaCodec(afd, debugName)
        }
    }

    private fun decodeWav(afd: AssetFileDescriptor, debugName: String): DecodedAudio {
        val stream = afd.createInputStream()
        val bytes = stream.readBytes()
        stream.close()
        afd.close()

        val buf = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)

        // RIFF header
        val riff = ByteArray(4); buf.get(riff)
        require(String(riff) == "RIFF") { "Not a RIFF file: $debugName" }
        buf.getInt() // chunk size
        val wave = ByteArray(4); buf.get(wave)
        require(String(wave) == "WAVE") { "Not a WAVE file: $debugName" }

        var audioFormat = 0
        var channels = 0
        var sampleRate = 0
        var bitsPerSample = 0
        var dataBytes: ByteArray? = null

        while (buf.remaining() >= 8) {
            val chunkId = ByteArray(4); buf.get(chunkId)
            val chunkSize = buf.getInt()
            val chunkName = String(chunkId)

            when (chunkName) {
                "fmt " -> {
                    val fmtStart = buf.position()
                    audioFormat = buf.getShort().toInt() and 0xFFFF
                    channels = buf.getShort().toInt() and 0xFFFF
                    sampleRate = buf.getInt()
                    buf.getInt() // byte rate
                    buf.getShort() // block align
                    bitsPerSample = buf.getShort().toInt() and 0xFFFF
                    buf.position(fmtStart + chunkSize)
                }
                "data" -> {
                    dataBytes = ByteArray(chunkSize)
                    buf.get(dataBytes)
                }
                else -> {
                    if (buf.remaining() >= chunkSize) {
                        buf.position(buf.position() + chunkSize)
                    } else {
                        break
                    }
                }
            }
        }

        require(audioFormat == 1) { "Non-PCM WAV (format=$audioFormat): $debugName" }
        require(dataBytes != null) { "No data chunk: $debugName" }
        require(bitsPerSample in listOf(16, 24, 32)) { "Unsupported bits=$bitsPerSample: $debugName" }

        val bytesPerSample = bitsPerSample / 8
        val totalSamples = dataBytes!!.size / bytesPerSample
        val numFrames = totalSamples / channels
        val dataBuf = ByteBuffer.wrap(dataBytes).order(ByteOrder.LITTLE_ENDIAN)
        val floats = FloatArray(totalSamples)

        when (bitsPerSample) {
            16 -> {
                for (i in 0 until totalSamples) {
                    floats[i] = dataBuf.getShort().toFloat() / 32768f
                }
            }
            24 -> {
                for (i in 0 until totalSamples) {
                    val b0 = dataBuf.get().toInt() and 0xFF
                    val b1 = dataBuf.get().toInt() and 0xFF
                    val b2 = dataBuf.get().toInt()
                    val sample = (b2 shl 16) or (b1 shl 8) or b0
                    floats[i] = sample.toFloat() / 8388608f
                }
            }
            32 -> {
                for (i in 0 until totalSamples) {
                    floats[i] = dataBuf.getInt().toFloat() / 2147483648f
                }
            }
        }

        Log.i(TAG, "WAV decoded: $debugName (${numFrames} frames, ${channels}ch, ${sampleRate}Hz, ${bitsPerSample}bit)")
        return DecodedAudio(floats, numFrames, channels, sampleRate)
    }

    private fun decodeWithMediaCodec(afd: AssetFileDescriptor, debugName: String): DecodedAudio {
        val extractor = MediaExtractor()
        extractor.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
        afd.close()

        require(extractor.trackCount > 0) { "No tracks: $debugName" }
        extractor.selectTrack(0)
        val format = extractor.getTrackFormat(0)
        val mime = format.getString(MediaFormat.KEY_MIME) ?: "unknown"
        val sampleRate = format.getInteger(MediaFormat.KEY_SAMPLE_RATE)
        val channels = format.getInteger(MediaFormat.KEY_CHANNEL_COUNT)

        Log.i(TAG, "MediaCodec decoding: $debugName ($mime, ${sampleRate}Hz, ${channels}ch)")

        val codec = MediaCodec.createDecoderByType(mime)
        codec.configure(format, null, null, 0)
        codec.start()

        val pcmChunks = mutableListOf<ByteArray>()
        var totalPcmBytes = 0
        var inputDone = false
        val bufferInfo = MediaCodec.BufferInfo()
        val timeoutUs = 10_000L

        while (true) {
            if (!inputDone) {
                val inIdx = codec.dequeueInputBuffer(timeoutUs)
                if (inIdx >= 0) {
                    val inputBuffer = codec.getInputBuffer(inIdx)!!
                    val read = extractor.readSampleData(inputBuffer, 0)
                    if (read < 0) {
                        codec.queueInputBuffer(inIdx, 0, 0, 0, MediaCodec.BUFFER_FLAG_END_OF_STREAM)
                        inputDone = true
                    } else {
                        codec.queueInputBuffer(inIdx, 0, read, extractor.sampleTime, 0)
                        extractor.advance()
                    }
                }
            }

            val outIdx = codec.dequeueOutputBuffer(bufferInfo, timeoutUs)
            if (outIdx >= 0) {
                val outBuf = codec.getOutputBuffer(outIdx)!!
                val chunk = ByteArray(bufferInfo.size)
                outBuf.position(bufferInfo.offset)
                outBuf.get(chunk)
                pcmChunks.add(chunk)
                totalPcmBytes += chunk.size
                codec.releaseOutputBuffer(outIdx, false)

                if (bufferInfo.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0) break
            } else if (outIdx == MediaCodec.INFO_TRY_AGAIN_LATER && inputDone) {
                break
            }
        }

        codec.stop()
        codec.release()
        extractor.release()

        // PCM16 -> float32
        val pcm16 = ByteBuffer.allocate(totalPcmBytes).order(ByteOrder.LITTLE_ENDIAN)
        for (chunk in pcmChunks) pcm16.put(chunk)
        pcm16.flip()

        val totalSamples = totalPcmBytes / 2
        val numFrames = totalSamples / channels
        val floats = FloatArray(totalSamples)
        for (i in 0 until totalSamples) {
            floats[i] = pcm16.getShort().toFloat() / 32768f
        }

        Log.i(TAG, "MediaCodec decoded: $debugName ($numFrames frames, ${channels}ch)")
        return DecodedAudio(floats, numFrames, channels, sampleRate)
    }
}
