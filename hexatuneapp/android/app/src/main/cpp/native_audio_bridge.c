// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

#include <jni.h>
#include <stdint.h>
#include <string.h>

// --- Structs mirroring hexatune_dsp_ffi.h ---

typedef struct { float frequency_delta; float duration_seconds; int oneshot; } HtdCycleItem;

typedef struct {
    float carrier_frequency;
    int   binaural_enabled;
    const HtdCycleItem *cycle_items;
    uint32_t cycle_count;
    float sample_rate;
    float base_gain;
    float texture_gain;
    float event_gain;
    float binaural_gain;
    float master_gain;
} HtdEngineConfig;

typedef struct {
    const float *samples;
    uint32_t num_frames;
    uint32_t channels;
} HtdLayerConfig;

typedef struct {
    const float *samples;
    uint32_t num_frames;
    uint32_t channels;
    uint32_t min_interval_ms;
    uint32_t max_interval_ms;
    float volume_min;
    float volume_max;
    float pan_min;
    float pan_max;
} HtdEventConfig;

// --- Rust FFI function declarations ---

extern int32_t htd_engine_render(void *engine, float *output, uint32_t num_frames);
extern int32_t htd_engine_set_base(void *engine, const HtdLayerConfig *config);
extern int32_t htd_engine_clear_base(void *engine);
extern int32_t htd_engine_set_texture(void *engine, uint32_t index, const HtdLayerConfig *config);
extern int32_t htd_engine_clear_texture(void *engine, uint32_t index);
extern int32_t htd_engine_set_event(void *engine, uint32_t index, const HtdEventConfig *config);
extern int32_t htd_engine_clear_event(void *engine, uint32_t index);
extern int32_t htd_engine_clear_all_layers(void *engine);
extern int32_t htd_engine_stop_graceful(void *engine);

// --- JNI function implementations ---

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeRender(
    JNIEnv *env, jclass clazz, jlong engine_ptr, jfloatArray output, jint num_frames) {
    float *buf = (*env)->GetPrimitiveArrayCritical(env, output, NULL);
    if (!buf) return -1;
    int32_t rc = htd_engine_render((void*)engine_ptr, buf, (uint32_t)num_frames);
    (*env)->ReleasePrimitiveArrayCritical(env, output, buf, 0);
    return rc;
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeSetBase(
    JNIEnv *env, jclass clazz, jlong engine_ptr,
    jfloatArray samples, jint num_frames, jint channels) {
    float *buf = (*env)->GetPrimitiveArrayCritical(env, samples, NULL);
    if (!buf) return -1;
    HtdLayerConfig cfg = { .samples = buf, .num_frames = (uint32_t)num_frames, .channels = (uint32_t)channels };
    int32_t rc = htd_engine_set_base((void*)engine_ptr, &cfg);
    (*env)->ReleasePrimitiveArrayCritical(env, samples, buf, JNI_ABORT);
    return rc;
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeSetTexture(
    JNIEnv *env, jclass clazz, jlong engine_ptr, jint index,
    jfloatArray samples, jint num_frames, jint channels) {
    float *buf = (*env)->GetPrimitiveArrayCritical(env, samples, NULL);
    if (!buf) return -1;
    HtdLayerConfig cfg = { .samples = buf, .num_frames = (uint32_t)num_frames, .channels = (uint32_t)channels };
    int32_t rc = htd_engine_set_texture((void*)engine_ptr, (uint32_t)index, &cfg);
    (*env)->ReleasePrimitiveArrayCritical(env, samples, buf, JNI_ABORT);
    return rc;
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeSetEvent(
    JNIEnv *env, jclass clazz, jlong engine_ptr, jint index,
    jfloatArray samples, jint num_frames, jint channels,
    jint min_ms, jint max_ms, jfloat vol_min, jfloat vol_max,
    jfloat pan_min, jfloat pan_max) {
    float *buf = (*env)->GetPrimitiveArrayCritical(env, samples, NULL);
    if (!buf) return -1;
    HtdEventConfig cfg = {
        .samples = buf, .num_frames = (uint32_t)num_frames, .channels = (uint32_t)channels,
        .min_interval_ms = (uint32_t)min_ms, .max_interval_ms = (uint32_t)max_ms,
        .volume_min = vol_min, .volume_max = vol_max,
        .pan_min = pan_min, .pan_max = pan_max
    };
    int32_t rc = htd_engine_set_event((void*)engine_ptr, (uint32_t)index, &cfg);
    (*env)->ReleasePrimitiveArrayCritical(env, samples, buf, JNI_ABORT);
    return rc;
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeClearBase(
    JNIEnv *env, jclass clazz, jlong engine_ptr) {
    return htd_engine_clear_base((void*)engine_ptr);
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeClearTexture(
    JNIEnv *env, jclass clazz, jlong engine_ptr, jint index) {
    return htd_engine_clear_texture((void*)engine_ptr, (uint32_t)index);
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeClearEvent(
    JNIEnv *env, jclass clazz, jlong engine_ptr, jint index) {
    return htd_engine_clear_event((void*)engine_ptr, (uint32_t)index);
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeClearAllLayers(
    JNIEnv *env, jclass clazz, jlong engine_ptr) {
    return htd_engine_clear_all_layers((void*)engine_ptr);
}

JNIEXPORT jint JNICALL
Java_com_hexatune_hexatuneapp_DspNativeAudioBridge_nativeStopGraceful(
    JNIEnv *env, jclass clazz, jlong engine_ptr) {
    return htd_engine_stop_graceful((void*)engine_ptr);
}
