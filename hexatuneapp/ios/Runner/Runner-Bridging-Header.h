#import "GeneratedPluginRegistrant.h"
#include "hexatune_dsp_ffi.h"
#include "hexa_tune_proto.h"

// Force-link all Rust FFI symbols into the executable export trie.
// Must be called from AppDelegate during application launch.
int hexa_force_link_symbols(void);
