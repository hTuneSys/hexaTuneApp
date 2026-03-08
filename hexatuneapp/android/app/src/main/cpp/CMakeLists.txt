# SPDX-FileCopyrightText: 2025 hexaTune LLC
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.10)
project(native_audio_bridge C)

add_library(native_audio_bridge SHARED native_audio_bridge.c)

target_link_directories(native_audio_bridge PRIVATE
    ${CMAKE_SOURCE_DIR}/../jniLibs/${ANDROID_ABI}/
)
target_link_libraries(native_audio_bridge hexatune_dsp_ffi log)
