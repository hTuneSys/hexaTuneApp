// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

package com.hexatune.hexatuneapp

object DspNativeAudioBridge {
    init {
        System.loadLibrary("hexatune_dsp_ffi")
        System.loadLibrary("native_audio_bridge")
    }

    @JvmStatic external fun nativeRender(enginePtr: Long, output: FloatArray, numFrames: Int): Int

    @JvmStatic external fun nativeSetBase(enginePtr: Long, samples: FloatArray, numFrames: Int, channels: Int): Int
    @JvmStatic external fun nativeSetTexture(enginePtr: Long, index: Int, samples: FloatArray, numFrames: Int, channels: Int): Int
    @JvmStatic external fun nativeSetEvent(
        enginePtr: Long, index: Int,
        samples: FloatArray, numFrames: Int, channels: Int,
        minIntervalMs: Int, maxIntervalMs: Int,
        volumeMin: Float, volumeMax: Float,
        panMin: Float, panMax: Float
    ): Int

    @JvmStatic external fun nativeClearBase(enginePtr: Long): Int
    @JvmStatic external fun nativeClearTexture(enginePtr: Long, index: Int): Int
    @JvmStatic external fun nativeClearEvent(enginePtr: Long, index: Int): Int
    @JvmStatic external fun nativeClearAllLayers(enginePtr: Long): Int
    @JvmStatic external fun nativeStopGraceful(enginePtr: Long): Int
}
