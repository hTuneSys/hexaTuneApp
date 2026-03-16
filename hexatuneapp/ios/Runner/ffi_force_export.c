// SPDX-FileCopyrightText: 2026 hexaTune LLC
// SPDX-License-Identifier: MIT

// Force all Rust FFI symbols to survive dead-code stripping.
//
// On iOS, the main executable is built with DEAD_CODE_STRIPPING=YES by
// default. Even with -force_load, the linker can strip symbols that are
// not reachable from the entry-point graph. Dart FFI uses
// DynamicLibrary.process() → dlsym(RTLD_DEFAULT, ...) which requires
// symbols to be present in the executable's export trie.
//
// This file creates explicit references to every FFI symbol so the
// dead-code stripper considers them reachable. The __attribute__((used))
// annotation prevents the compiler from eliminating the array itself.

#include "hexatune_dsp_ffi.h"
#include "hexa_tune_proto.h"

__attribute__((used))
static const void *_ffi_force_export[] = {
    // ── DSP engine ──────────────────────────────────────────────
    (const void *)&htd_engine_init,
    (const void *)&htd_engine_destroy,
    (const void *)&htd_engine_start,
    (const void *)&htd_engine_stop,
    (const void *)&htd_engine_stop_graceful,
    (const void *)&htd_engine_render,
    (const void *)&htd_engine_set_base,
    (const void *)&htd_engine_clear_base,
    (const void *)&htd_engine_set_texture,
    (const void *)&htd_engine_clear_texture,
    (const void *)&htd_engine_set_event,
    (const void *)&htd_engine_clear_event,
    (const void *)&htd_engine_clear_all_layers,
    (const void *)&htd_engine_set_base_gain,
    (const void *)&htd_engine_set_texture_gain,
    (const void *)&htd_engine_set_event_gain,
    (const void *)&htd_engine_set_binaural_gain,
    (const void *)&htd_engine_set_master_gain,
    (const void *)&htd_engine_update_config,
    (const void *)&htd_engine_load_base_wav,
    (const void *)&htd_engine_is_running,
    (const void *)&htd_engine_sample_rate,
    // ── Protocol encoding ───────────────────────────────────────
    (const void *)&htp_at_encode,
    (const void *)&htp_at_parse,
    (const void *)&htp_sysex_frame,
    (const void *)&htp_sysex_unframe,
    (const void *)&htp_usb_packetize,
    (const void *)&htp_usb_depacketize,
    (const void *)&htp_encode_to_packets,
};
