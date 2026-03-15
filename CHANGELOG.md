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
