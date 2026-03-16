#!/bin/bash
# Deduplicate Rust runtime symbols in Proto.a to prevent
# "duplicate symbol" errors when linking with DSP.a.
#
# Both DSP and Proto are Rust staticlibs that bundle identical Rust
# runtime crates (compiler_builtins, std, panic_unwind, etc.) with
# unhashed ABI symbols (_rust_eh_personality, __adddf3, etc.).
# DSP is -force_load'ed (all objects loaded), so Proto's copies of
# these symbols cause "duplicate symbol" errors on ld_prime (Xcode 16+).
#
# Strategy: pre-link all Proto objects with `ld -r` to resolve internal
# references, then use `nmedit -R` to localize symbols that duplicate
# DSP. The linker sees Proto's duplicates as local (invisible) and uses
# DSP's global definitions instead.

set -euo pipefail

# Resolve architecture-specific paths
if [ "${PLATFORM_NAME:-}" = "iphonesimulator" ]; then
  PROTO_SRC="${PROJECT_DIR}/Frameworks/HexaTuneProto.xcframework/ios-arm64-simulator/libhexa_tune_proto_ffi.a"
  DSP_SRC="${PROJECT_DIR}/Frameworks/HexaTuneDspFfi.xcframework/ios-arm64-simulator/libhexatune_dsp_ffi.a"
else
  PROTO_SRC="${PROJECT_DIR}/Frameworks/HexaTuneProto.xcframework/ios-arm64/libhexa_tune_proto_ffi.a"
  DSP_SRC="${PROJECT_DIR}/Frameworks/HexaTuneDspFfi.xcframework/ios-arm64/libhexatune_dsp_ffi.a"
fi

PROTO_DST="${PROJECT_DIR}/build/libhexa_tune_proto_ffi_stripped.a"

if [ ! -f "$PROTO_SRC" ]; then
  echo "error: Proto archive not found: $PROTO_SRC" >&2
  exit 1
fi

if [ ! -f "$DSP_SRC" ]; then
  echo "error: DSP archive not found: $DSP_SRC" >&2
  exit 1
fi

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# Step 1: Extract all Proto objects
PROTO_DIR="$WORK_DIR/proto"
mkdir -p "$PROTO_DIR"
cd "$PROTO_DIR"
ar x "$PROTO_SRC"
PROTO_COUNT=$(find . -name '*.o' | wc -l | tr -d ' ')

# Step 2: Pre-link all Proto objects into a single relocatable object.
# This resolves all internal symbol references (e.g., Proto's core::
# hashed symbols referencing Proto's compiler_builtins) so we can safely
# localize the duplicate symbols without breaking internal linkage.
ld -r -o "$WORK_DIR/proto_combined.o" *.o

# Step 3: Find symbols that duplicate between Proto and DSP.
# Extract global defined symbols from both archives and intersect.
DSP_DIR="$WORK_DIR/dsp"
mkdir -p "$DSP_DIR"
cd "$DSP_DIR"
ar x "$DSP_SRC"

nm -gU "$WORK_DIR/proto_combined.o" 2>/dev/null | awk '{print $NF}' | sort -u > "$WORK_DIR/proto_globals.txt" || true
nm -gU *.o 2>/dev/null | awk '{print $NF}' | sort -u > "$WORK_DIR/dsp_globals.txt" || true

# Intersect to find true duplicates
comm -12 "$WORK_DIR/proto_globals.txt" "$WORK_DIR/dsp_globals.txt" > "$WORK_DIR/duplicates.txt"

# Also add _rust_eh_personality — it may not appear in nm -g --defined-only
# for DSP (can be in bitcode or have special visibility) but is always
# the primary duplicate that triggers ld errors.
echo "_rust_eh_personality" >> "$WORK_DIR/duplicates.txt"
sort -u -o "$WORK_DIR/duplicates.txt" "$WORK_DIR/duplicates.txt"

DUP_COUNT=$(wc -l < "$WORK_DIR/duplicates.txt" | tr -d ' ')

# Step 4: Localize duplicate symbols in the combined Proto object.
# nmedit -R makes listed symbols local (invisible to the linker for
# duplicate resolution). Internal references are already resolved by ld -r.
cp "$WORK_DIR/proto_combined.o" "$WORK_DIR/proto_deduped.o"
nmedit -R "$WORK_DIR/duplicates.txt" "$WORK_DIR/proto_deduped.o" 2>/dev/null || true

# Step 5: Create the final archive
mkdir -p "$(dirname "$PROTO_DST")"
rm -f "$PROTO_DST"
ar rcs "$PROTO_DST" "$WORK_DIR/proto_deduped.o"

echo "Proto dedup: ${PROTO_COUNT} objects → 1 combined, ${DUP_COUNT} symbols localized → $PROTO_DST"
