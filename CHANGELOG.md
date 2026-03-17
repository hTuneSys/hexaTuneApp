## [1.3.19](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.18...v1.3.19) (2026-03-17)


### Bug Fixes

* **ios:** preserve FFI export trie by setting STRIP_STYLE=non-global ([4178311](https://github.com/hTuneSys/hexaTuneApp/commit/417831124ad740983ff05d494991c1e111998b5c))

## [1.3.18](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.17...v1.3.18) (2026-03-16)


### Bug Fixes

* **ios:** resolve duplicate Rust symbols with ld -r pre-link dedup ([fbd4688](https://github.com/hTuneSys/hexaTuneApp/commit/fbd46888ce0b6f1c1922aebdddce8a4e14b1e6f1))

## [1.3.17](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.16...v1.3.17) (2026-03-16)


### Bug Fixes

* **ios:** strip duplicate Rust runtime from Proto.a before linking ([77bc0d0](https://github.com/hTuneSys/hexaTuneApp/commit/77bc0d01bcdf6fc340fb949e9eff8e2bbc94de28))

## [1.3.16](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.15...v1.3.16) (2026-03-16)


### Bug Fixes

* **ios:** use SRCROOT for link map path so CI can find it ([e5eb00a](https://github.com/hTuneSys/hexaTuneApp/commit/e5eb00a257e36553ed0dd9e6c333d3d8122c876d))

## [1.3.15](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.14...v1.3.15) (2026-03-16)


### Bug Fixes

* **ios:** harden FFI export with visibility attrs, EXPORTED_SYMBOLS_FILE, and improved CI diagnostics ([fdbaf2a](https://github.com/hTuneSys/hexaTuneApp/commit/fdbaf2a1ce1b163d289955a73e2e6f4023165719))
* **ios:** use ld_classic linker to resolve Rust FFI duplicate symbols ([e71c4f3](https://github.com/hTuneSys/hexaTuneApp/commit/e71c4f33f68d259f5a6bf593a65d6ab4bf1a95ab)), closes [#35](https://github.com/hTuneSys/hexaTuneApp/issues/35)

## [1.3.14](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.13...v1.3.14) (2026-03-16)


### Bug Fixes

* **ios:** use -Wl,-u flags instead of DEAD_CODE_STRIPPING=NO ([5679230](https://github.com/hTuneSys/hexaTuneApp/commit/567923081a42c3f5ae72af39bb79dcc71f954698)), closes [Build#34](https://github.com/Build/issues/34)

## [1.3.13](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.12...v1.3.13) (2026-03-16)


### Bug Fixes

* **ios:** add DEAD_CODE_STRIPPING=NO to prevent Rust FFI cascade stripping ([3bd2281](https://github.com/hTuneSys/hexaTuneApp/commit/3bd2281b5ee75bb9485efc0f35813a4fb2cbbb10)), closes [Build#33](https://github.com/Build/issues/33)

## [1.3.12](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.11...v1.3.12) (2026-03-16)


### Bug Fixes

* **ios:** remove -exported_symbols_list, keep only -export_dynamic ([7f8348a](https://github.com/hTuneSys/hexaTuneApp/commit/7f8348a46e8c40f3762ce5cf62336f07ec2574aa)), closes [#30](https://github.com/hTuneSys/hexaTuneApp/issues/30) [#31-32](https://github.com/hTuneSys/hexaTuneApp/issues/31-32)

## [1.3.11](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.10...v1.3.11) (2026-03-16)


### Bug Fixes

* **ios:** add -export_dynamic to preserve FFI symbols through LTO ([7d4d3dc](https://github.com/hTuneSys/hexaTuneApp/commit/7d4d3dc8a2493860f19578f5cbe37a4e381bf441))

## [1.3.10](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.9...v1.3.10) (2026-03-16)


### Bug Fixes

* **ios:** add -exported_symbols_list via xcconfig for FFI export trie ([4702497](https://github.com/hTuneSys/hexaTuneApp/commit/4702497498218569411ba5494ccfa743afd5a003))

## [1.3.9](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.8...v1.3.9) (2026-03-16)


### Bug Fixes

* **ios:** force-link FFI symbols from AppDelegate for export trie ([5f65ad4](https://github.com/hTuneSys/hexaTuneApp/commit/5f65ad46dea0c4075fc2720e3c70eb434d0eb170))

## [1.3.8](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.7...v1.3.8) (2026-03-16)


### Bug Fixes

* **ci:** add comprehensive FFI binary diagnostics ([ed2ef09](https://github.com/hTuneSys/hexaTuneApp/commit/ed2ef092fd63817b7d169e1f98c78d27d120d29d))

## [1.3.7](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.6...v1.3.7) (2026-03-16)


### Bug Fixes

* **ci:** correct diagnostic find path for working-directory default ([fddebc7](https://github.com/hTuneSys/hexaTuneApp/commit/fddebc77b89f64d567a5f8a6b738212cb586484d))

## [1.3.6](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.5...v1.3.6) (2026-03-16)


### Bug Fixes

* **ios:** pass -exported_symbols_list via OTHER_LDFLAGS for export trie visibility ([687fd76](https://github.com/hTuneSys/hexaTuneApp/commit/687fd76b2bac57942f58da63899fcf9b73f65421))

## [1.3.5](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.4...v1.3.5) (2026-03-16)


### Bug Fixes

* **ios:** force FFI symbols into export trie and use DynamicLibrary.executable() ([56e767d](https://github.com/hTuneSys/hexaTuneApp/commit/56e767d7f230602f94daaae365f04a7284a0a0f7))

## [1.3.4](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.3...v1.3.4) (2026-03-16)


### Bug Fixes

* **ios:** force-export FFI symbols to survive dead-code stripping ([dfa8af2](https://github.com/hTuneSys/hexaTuneApp/commit/dfa8af27139b8809914cb952637a5e428782757a))

## [1.3.3](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.2...v1.3.3) (2026-03-16)


### Bug Fixes

* **ios:** resolve 146 duplicate symbols by using selective linking for proto lib ([b5767dd](https://github.com/hTuneSys/hexaTuneApp/commit/b5767ddb0230e52b08d27c17902fafceea9fd1c1))

## [1.3.2](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.1...v1.3.2) (2026-03-16)


### Bug Fixes

* **dsp:** make FFI bindings retryable after init failure ([a6c3864](https://github.com/hTuneSys/hexaTuneApp/commit/a6c38645d3fe7a0ea6d10f2d8f795391c2722fea))
* **inventory:** fix iOS camera photo upload with explicit multipart content type ([aaa1d6b](https://github.com/hTuneSys/hexaTuneApp/commit/aaa1d6be8c458f4118b36d16536af3a4a73fa0c4))
* **ios:** link HexaTuneProto and decouple MIDI from FFI for device discovery ([83eefe0](https://github.com/hTuneSys/hexaTuneApp/commit/83eefe0839f695fd0d0100b9988eb1c28fa5d255))

## [1.3.1](https://github.com/hTuneSys/hexaTuneApp/compare/v1.3.0...v1.3.1) (2026-03-16)


### Bug Fixes

* **notification:** add iOS background modes, foreground presentation options, and APNs token logging ([9310b99](https://github.com/hTuneSys/hexaTuneApp/commit/9310b99dfc22dab0cf835bfd257f88989c86e427))

# [1.3.0](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.9...v1.3.0) (2026-03-16)


### Bug Fixes

* **notification:** implement foreground display, background handler, and fix iOS APNs ([9535b8c](https://github.com/hTuneSys/hexaTuneApp/commit/9535b8c9c1686895115475512bc0be0db509094e))


### Features

* **log:** add debug log monitor page with in-memory capture ([3649dba](https://github.com/hTuneSys/hexaTuneApp/commit/3649dba0aca10099b87a8b7fe3343047376c9257))

## [1.2.9](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.8...v1.2.9) (2026-03-15)


### Bug Fixes

* **ios:** add camera and photo library privacy descriptions to Info.plist ([619002d](https://github.com/hTuneSys/hexaTuneApp/commit/619002d2ae07a0a29f689203ede8141128edc2dd))

## [1.2.8](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.7...v1.2.8) (2026-03-15)


### Bug Fixes

* **ios:** add Google Sign-In client ID and URL scheme to Info.plist ([21f830b](https://github.com/hTuneSys/hexaTuneApp/commit/21f830b0b06aa1b0106b39d8ee1153dbbbf3e9b2))

## [1.2.7](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.6...v1.2.7) (2026-03-15)


### Bug Fixes

* **dsp:** defer FFI loading and show full error on splash ([99df3f9](https://github.com/hTuneSys/hexaTuneApp/commit/99df3f9a45da0a906e315f9cf60332377ef7ee03))

## [1.2.6](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.5...v1.2.6) (2026-03-15)


### Bug Fixes

* **ios:** remove HexaTuneProto force_load to fix duplicate Rust runtime symbols ([ed02fd0](https://github.com/hTuneSys/hexaTuneApp/commit/ed02fd0dc1bb2d1d8465c6655dce226fe297a309))

## [1.2.5](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.4...v1.2.5) (2026-03-15)


### Bug Fixes

* **ci:** add cocoapods to Gemfile for bundle exec compatibility ([5874698](https://github.com/hTuneSys/hexaTuneApp/commit/5874698cf69f06c2ee945f33e451058d816a7ade))

## [1.2.4](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.3...v1.2.4) (2026-03-15)


### Bug Fixes

* **ci:** remove explicit pod commands from Fastfile ([d0732d8](https://github.com/hTuneSys/hexaTuneApp/commit/d0732d8a2b890308cd962113207e9f74330917c5))

## [1.2.3](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.2...v1.2.3) (2026-03-15)


### Bug Fixes

* **ci:** add Pods xcconfig includes, Gemfile, fix Fastfile chdir, update actions ([3dce8f6](https://github.com/hTuneSys/hexaTuneApp/commit/3dce8f66900f3849ee6fa79aa558e5d508cfb8c9))
* **ios:** remove xcframeworks from link phase to fix 146 duplicate symbols ([0f210ff](https://github.com/hTuneSys/hexaTuneApp/commit/0f210ff9d88a64b28ef471905dc9b8b8e01037f9))

## [1.2.2](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.1...v1.2.2) (2026-03-15)


### Bug Fixes

* **ios:** replace -all_load with targeted -force_load for FFI libs ([9ff2e67](https://github.com/hTuneSys/hexaTuneApp/commit/9ff2e675e36138b2b4bb0bc0e32d2c5b63385976))

## [1.2.1](https://github.com/hTuneSys/hexaTuneApp/compare/v1.2.0...v1.2.1) (2026-03-15)


### Bug Fixes

* **ios:** add -all_load linker flag and link HexaTuneProto framework ([389bff0](https://github.com/hTuneSys/hexaTuneApp/commit/389bff0ca8ecd506e4b5563856d233a440eafd93))

# [1.2.0](https://github.com/hTuneSys/hexaTuneApp/compare/v1.1.2...v1.2.0) (2026-03-15)


### Features

* **bootstrap:** show live progress on splash during initialization ([a4e787c](https://github.com/hTuneSys/hexaTuneApp/commit/a4e787c73183d37507b796d6443166d513af4f9f))

## [1.1.2](https://github.com/hTuneSys/hexaTuneApp/compare/v1.1.1...v1.1.2) (2026-03-15)


### Bug Fixes

* **ios:** remove incorrect Apple Pay entitlement ([338d1b6](https://github.com/hTuneSys/hexaTuneApp/commit/338d1b611b6d159c07c039239061e29178571ee9))

## [1.1.1](https://github.com/hTuneSys/hexaTuneApp/compare/v1.1.0...v1.1.1) (2026-03-15)


### Bug Fixes

* **config:** use debug androidClientId for dev environment ([3fb77ef](https://github.com/hTuneSys/hexaTuneApp/commit/3fb77effc7d9f8209c8da2f63c3a3035282320ef))

# [1.1.0](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.6...v1.1.0) (2026-03-15)


### Features

* **platform:** add billing and push permissions, remove background service ([055846b](https://github.com/hTuneSys/hexaTuneApp/commit/055846babfbcbdf91fca49e7c49d6c0ea3ba0a96))

## [1.0.6](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.5...v1.0.6) (2026-03-14)


### Bug Fixes

* **ios:** add Appfile and explicit app_identifier for TestFlight upload ([8e8990f](https://github.com/hTuneSys/hexaTuneApp/commit/8e8990f0f0ff34c4378f7accc98b2da3260dbf08))

## [1.0.5](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.4...v1.0.5) (2026-03-14)


### Bug Fixes

* **ios:** resolve Swift type mismatch in DspAudioService ([a0401a4](https://github.com/hTuneSys/hexaTuneApp/commit/a0401a4ad131c785b565154dc5059de7ea20338f))

## [1.0.4](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.3...v1.0.4) (2026-03-14)


### Bug Fixes

* **ios:** correct Swift file paths in Xcode project references ([3595708](https://github.com/hTuneSys/hexaTuneApp/commit/359570844382351c1ff4e6e6b92abb90e7f7e821))

## [1.0.3](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.2...v1.0.3) (2026-03-14)


### Bug Fixes

* **ios:** add native Swift files to Xcode project references ([aaf4c50](https://github.com/hTuneSys/hexaTuneApp/commit/aaf4c50bff89740a69d7d85c1e606c92bb2e93c2))

## [1.0.2](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.1...v1.0.2) (2026-03-14)


### Bug Fixes

* **ios:** update provisioning profile name in Release.xcconfig ([72b8257](https://github.com/hTuneSys/hexaTuneApp/commit/72b8257d7433c135daebda7a32c0e0c01dbe59e2))

## [1.0.1](https://github.com/hTuneSys/hexaTuneApp/compare/v1.0.0...v1.0.1) (2026-03-14)


### Bug Fixes

* **ios:** correct provisioning profile name in exportOptions.plist ([aafa05b](https://github.com/hTuneSys/hexaTuneApp/commit/aafa05bfceba074d255c85036cf13b589b8d9a9e))

# 1.0.0 (2026-03-14)


### Bug Fixes

* **ci:** override gradle java.home for CI compatibility ([f775714](https://github.com/hTuneSys/hexaTuneApp/commit/f7757148b4b7781c449c1dd38604205157d5f16c))


### Features

* core API infrastructure — OpenAPI v2, wallet module, multi-env Firebase, CI/CD workflows ([#1](https://github.com/hTuneSys/hexaTuneApp/issues/1)) ([5584a7e](https://github.com/hTuneSys/hexaTuneApp/commit/5584a7e0470431dba4295e040f730dcf320d18f3)), closes [#F5F5F5](https://github.com/hTuneSys/hexaTuneApp/issues/F5F5F5) [#F5F5F5](https://github.com/hTuneSys/hexaTuneApp/issues/F5F5F5)

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added (Unreleased)

- Initial setup of hexaTuneApp project structure.

### Changed

- Placeholder for upcoming changes.

### Fixed

- Placeholder for bug fixes.

---

## [0.0.0] - YYYY-MM-DD

### Added

- Project creation and initial commit.
