#!/bin/bash
# Strip duplicate Rust runtime objects from Proto.a to prevent
# "duplicate symbol _rust_eh_personality" when linking with DSP.a.
#
# Both DSP and Proto are Rust staticlibs that bundle identical Rust
# runtime crates (std, panic_unwind, compiler_builtins, etc.).
# DSP is -force_load'ed (all objects loaded), so Proto must NOT
# contribute its own copies of these crates — otherwise the linker
# sees duplicate definitions after LTO materialisation.
#
# This script keeps only Proto-specific objects (hexa_tune_proto*)
# and discards shared Rust runtime objects.

set -euo pipefail

# Resolve architecture-specific Proto.a path
if [ "${PLATFORM_NAME:-}" = "iphonesimulator" ]; then
  PROTO_SRC="${PROJECT_DIR}/Frameworks/HexaTuneProto.xcframework/ios-arm64-simulator/libhexa_tune_proto_ffi.a"
else
  PROTO_SRC="${PROJECT_DIR}/Frameworks/HexaTuneProto.xcframework/ios-arm64/libhexa_tune_proto_ffi.a"
fi

PROTO_DST="${TARGET_TEMP_DIR}/libhexa_tune_proto_ffi_stripped.a"

if [ ! -f "$PROTO_SRC" ]; then
  echo "error: Proto archive not found: $PROTO_SRC" >&2
  exit 1
fi

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# Extract all objects
cd "$WORK_DIR"
ar x "$PROTO_SRC"

# Keep ONLY Proto-specific objects; remove Rust runtime duplicates
# Proto objects match: hexa_tune_proto*
# Everything else (std, panic_unwind, compiler_builtins, core, alloc,
# unwind, libc, object, memchr, addr2line, gimli, cfg_if,
# rustc_demangle, std_detect, hashbrown, miniz_oxide, adler2, etc.)
# is a Rust runtime crate that DSP.a already provides via -force_load.
KEEP_OBJECTS=()
for obj in *.o; do
  case "$obj" in
    hexa_tune_proto*)
      KEEP_OBJECTS+=("$obj")
      ;;
  esac
done

if [ ${#KEEP_OBJECTS[@]} -eq 0 ]; then
  echo "error: no Proto-specific objects found in archive" >&2
  exit 1
fi

# Create stripped archive with only Proto-specific objects
mkdir -p "$(dirname "$PROTO_DST")"
ar rcs "$PROTO_DST" "${KEEP_OBJECTS[@]}"

echo "Stripped Proto archive: ${#KEEP_OBJECTS[@]} objects kept → $PROTO_DST"
