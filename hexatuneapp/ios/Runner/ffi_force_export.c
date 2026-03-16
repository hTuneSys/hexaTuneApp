// SPDX-FileCopyrightText: 2026 hexaTune LLC
// SPDX-License-Identifier: MIT

// Force all Rust FFI symbols into the iOS executable and export trie.
//
// Problem: Dart FFI on iOS uses dlsym(RTLD_DEFAULT, ...) which requires
// symbols in the Mach-O export trie. Static library symbols from Rust
// archives (.a) may be omitted by the linker's dead-code stripper when
// they have no code-level references from the entry-point graph.
//
// Solution: This file creates an unbreakable reference chain:
//   _main -> AppDelegate -> hexa_force_link_symbols() -> all FFI symbols
//
// AppDelegate.swift MUST call hexa_force_link_symbols() during launch.
// This ensures the linker includes all referenced Rust objects and marks
// them as reachable, placing them in the export trie.

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

// Called from AppDelegate.swift to create a code-level reference chain
// from _main to every Rust FFI symbol. Returns the number of symbols.
int hexa_force_link_symbols(void) {
    int count = (int)(sizeof(_ffi_force_export) / sizeof(_ffi_force_export[0]));
    volatile const void *ref = NULL;
    for (int i = 0; i < count; i++) {
        ref = _ffi_force_export[i];
    }
    (void)ref;
    return count;
}
