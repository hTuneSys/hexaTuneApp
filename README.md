<!--
SPDX-FileCopyrightText: 2025 hexaTune LLC
SPDX-License-Identifier: MIT
-->

<p align="center">
  <strong>hexaTuneApp</strong>
</p>

<p align="center">
  <em>Harmonic Tuning Engine Management System</em>
</p>

<p align="center">
  <a href="https://github.com/hTuneSys/hexaTuneApp/releases"><img src="https://img.shields.io/github/v/release/hTuneSys/hexaTuneApp?style=flat-square" alt="Release"></a>
  <a href="https://opensource.org/license/mit/"><img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License"></a>
  <a href="https://github.com/hTuneSys/hexaTuneApp/actions"><img src="https://img.shields.io/github/actions/workflow/status/hTuneSys/hexaTuneApp/release.yml?style=flat-square&label=CI" alt="CI"></a>
  <a href="https://hexatune.com"><img src="https://img.shields.io/badge/hexatune.com-website-brightgreen?style=flat-square" alt="Website"></a>
</p>

---

## Overview

**hexaTuneApp** is the open-source cross-platform application for the [hexaTune](https://hexatune.com) **Harmonic Field Synthesis System**. It serves as the primary management interface for hexaTune's Harmonic Tuning Engines — programmable systems that generate and reproduce structured wave patterns across sound, electromagnetic fields, and light.

The application connects to the hexaTune backend infrastructure, provides native DSP-powered audio synthesis, and communicates directly with hexaGen hardware devices over USB MIDI. It enables users to manage inventories, compose harmonic formulas, generate frequency sequences, control signal output across multiple mediums, and monitor the entire harmonic field synthesis pipeline from a single interface.

Built with Flutter for cross-platform support, Rust-based native FFI libraries for real-time signal processing, and a hexagonal architecture backend — hexaTuneApp bridges the gap between the hexaTune cloud platform and physical Harmonic Tuning Engine devices.

## Harmonic Field Synthesis

hexaTune is a research and technology platform that provides the foundation for generating structured wave patterns derived from natural phenomena or recorded datasets. The system supports five harmonic generation types:

| Generation Type | Description |
|----------------|-------------|
| **Monaural** | Single-channel frequency patterns for direct acoustic output |
| **Binaural** | Dual-channel frequencies creating beat patterns through stereo separation |
| **Magnetic** | Electromagnetic field generation via hexaGen hardware |
| **Photonic** | Light-based wave pattern modulation |
| **Quantal** | Quantum-level harmonic field synthesis |

These generation types can be applied to user-defined formulas or pre-built flows to produce harmonic packet sequences that are then routed to the appropriate output — software DSP engine, hexaGen hardware, or connected headset devices.

## Technology Stack

| Layer | Technology |
|-------|-----------|
| **Application** | Flutter 3.38+ · Dart SDK ^3.9.2 |
| **DSP Engine** | Rust native library (`libhexatune_dsp_ffi`) via Dart FFI |
| **Protocol Layer** | Rust native library (`libhexa_tune_proto_ffi`) via Dart FFI |
| **Backend** | Rust · DDD + Hexagonal Architecture · PASETO Authentication |
| **Hardware** | hexaGen USB MIDI device · AT command protocol |
| **CI/CD** | GitHub Actions · Fastlane · Semantic Release |
| **Platforms** | Android · iOS · Web · Linux · macOS · Windows |

## Architecture

hexaTuneApp follows a layered architecture with clear separation of concerns:

```
┌─────────────────────────────────────────────────────┐
│                    UI Layer                          │
│              Pages · Widgets · Layout                │
├─────────────────────────────────────────────────────┤
│                 Service Layer                        │
│    Harmonizer · DSP · Ambience · Headset · HexaGen  │
├──────────────┬──────────────┬───────────────────────┤
│  REST Layer  │   FFI Layer  │   Hardware Layer      │
│  14 API      │  DSP Engine  │   USB MIDI · AT       │
│  Domains     │  Proto Codec │   Commands            │
├──────────────┴──────────────┴───────────────────────┤
│              Core Infrastructure                     │
│  DI · Auth · Storage · Network · Logging · Router   │
└─────────────────────────────────────────────────────┘
```

### Bootstrap Sequence

Application startup follows a deterministic initialization order:

1. **Dependency Injection** — Registers all singletons via `get_it` + `injectable`
2. **Device Fingerprint** — Collects device metadata for API identification
3. **Token Restoration** — Loads PASETO tokens from secure storage
4. **Notification Init** — Configures Firebase Cloud Messaging and local notifications
5. **Auth Validation** — Validates stored tokens and sets initial auth state
6. **Push Registration** — Sends FCM token to backend if authenticated

### Dependency Injection

All services and repositories are registered as `@singleton` via `get_it` + `injectable` with compile-time safety. Code generation produces the DI configuration automatically.

### Network Layer

| Component | Purpose |
|-----------|---------|
| `ApiClient` | Singleton Dio HTTP client with environment-based configuration |
| `AuthInterceptor` | Attaches PASETO Bearer tokens, handles 401 with automatic refresh |
| `ErrorInterceptor` | Maps HTTP errors to typed exceptions, parses RFC 7807 ProblemDetails |
| `LoggingInterceptor` | Request/response logging with Talker integration |

**Interceptor chain:** Logging → Auth → Error

### Authentication

- **Token format:** PASETO v4.public (Platform-Agnostic Security Tokens)
- **Providers:** Email/password, Google OAuth, Apple Sign-In
- **Token refresh:** Automatic on 401 with queued concurrent request retry
- **Secure storage:** Encrypted storage for access tokens, refresh tokens, and session data
- **Auth events:** Force logout, re-authentication required, device approval required

### Error Handling

All API errors follow RFC 7807 ProblemDetails with typed exception mapping:

| HTTP Status | Exception |
|-------------|-----------|
| 400 | `BadRequestException` |
| 401 | `UnauthorizedException` |
| 403 | `ForbiddenException` |
| 404 | `NotFoundException` |
| 409 | `ConflictException` |
| 422 | `ValidationException` |
| 429 | `RateLimitedException` |
| 5xx | `ServerException` |
| Network/Timeout | `NetworkException` / `TimeoutException` |

## Native FFI Libraries

hexaTuneApp integrates two Rust-based native libraries via Dart FFI for real-time signal processing and device communication.

### hexaTuneDsp — Digital Signal Processing Engine

The DSP engine (`libhexatune_dsp_ffi`) provides real-time audio synthesis with multi-layer ambience playback and binaural beat generation.

**Capabilities:**
- Real-time waveform rendering at 48 kHz sample rate
- Multi-layer audio architecture: base layer + up to 3 texture layers + up to 5 event layers
- Binaural beat generation with configurable carrier frequency (220 Hz) and delta stepping
- Per-layer gain control with master gain and crossfade support (2048 frames / ~42 ms)
- Random event scheduling with configurable interval, volume, and stereo pan ranges
- Graceful stop with crossfade for seamless audio transitions

**FFI Surface (22 functions):**
- **Lifecycle:** `init`, `destroy`, `start`, `stop`, `stopGraceful`, `render`
- **Layer Management:** `setBase`, `setTexture`, `setEvent`, `clearBase`, `clearTexture`, `clearEvent`, `clearAllLayers`
- **Gain Control:** `setBaseGain`, `setTextureGain`, `setEventGain`, `setBinauralGain`, `setMasterGain`
- **Configuration:** `updateConfig`, `isRunning`, `sampleRate`

**Platform Integration:**
- **Android:** Dynamic loading from `libhexatune_dsp_ffi.so` (arm64-v8a, armeabi-v7a, x86_64)
- **iOS:** Statically linked into the binary via `DynamicLibrary.process()` with xcframework

### hexaTuneProto — Communication Protocol Codec

The protocol library (`libhexa_tune_proto_ffi`) handles encoding and decoding of the AT command protocol used for hexaGen device communication over USB MIDI.

**Encoding Pipeline:**
```
AT Command → SysEx Frame (F0…F7) → USB MIDI Packets
```

**Decoding Pipeline:**
```
USB MIDI Packets → SysEx Unframe → AT Response Parse
```

**FFI Surface (8 function categories):**
- **AT Encoding:** `htpAtEncode()` — Compile AT command strings to binary
- **AT Parsing:** `htpAtParse()` — Parse AT response bytes into structured results
- **SysEx Framing:** `htpSysexFrame()` / `htpSysexUnframe()` — Add/remove MIDI SysEx wrapper
- **USB Packetization:** `htpUsbPacketize()` / `htpUsbDepacketize()` — Convert between SysEx and USB MIDI packets
- **Full Pipeline:** `encodeToPackets()` — Complete AT → SysEx → USB in one call

**AT Command Set:**
- `AT+VERSION` — Query device firmware version
- `AT+OPERATION=PREPARE|GENERATE` — Control generation phases
- `AT+FREQ=<id>#<hz>#<ms>` — Set frequency with duration
- `AT+SETRGB=<r>#<g>#<b>` — Control device RGB LED indicators
- `AT+RESET` — Reset device state
- `AT+FWUPDATE` — Initiate firmware update

## Ambience Sound System

The application ships with a built-in ambience library for creating immersive soundscapes during harmonic sessions:

| Layer Type | Sounds | Purpose |
|-----------|--------|---------|
| **Base** | Forest, Ocean, Rain | Continuous background atmosphere |
| **Texture** | Fire, Grass, Leaf, Night, Snow, Soft Wind, Strong Wind, Water Drop, Wave | Layered environmental detail |
| **Events** | Bird, Frog, Owl, Insect, Thunder, Sea Gull, Woodpecker, and more | Randomized natural events |

Ambience presets can be created, saved, and managed with configurable per-layer gain controls. The DSP engine renders all layers in real-time with stereo panning and random event scheduling.

## Harmonizer Service

The Harmonizer is the central orchestration layer that coordinates harmonic generation across all output targets:

1. **Fetches harmonic sequences** from the backend API based on user-selected formulas or flows
2. **Routes output** to the appropriate target — software DSP, hexaGen hardware, or headset
3. **Manages playback state** with real-time streaming updates to the UI
4. **Layers ambience** beneath the harmonic output for immersive sessions
5. **Monitors device connections** (hexaGen via USB MIDI, headsets via Bluetooth)

## API Domains

The application communicates with the hexaTune backend across 14 API domains with 60+ endpoints:

| Domain | Endpoints | Description |
|--------|-----------|-------------|
| **Authentication** | 12 | Login, register, OAuth (Google/Apple), email verification, password reset, token refresh |
| **Accounts & Profile** | 3 | Account info, profile view and update |
| **Sessions** | 3 | Active session listing, selective and bulk revocation |
| **Devices** | 8 | Push token management, device approval request/approve/reject workflow |
| **Categories** | 5 | Taxonomy management with label-based filtering |
| **Inventories** | 6 | Inventory item CRUD with image upload and pre-signed URL access |
| **Formulas** | 9 | Formula composition with item management, ordering, and quantity control |
| **Flows** | 4 | Pre-built harmonic flow browsing with step visualization |
| **Steps** | 4 | Individual step definitions — building blocks for flows |
| **Packages** | 4 | Curated content package browsing with localization |
| **Harmonics** | 1 | Harmonic sequence generation from formulas or flows |
| **Tasks** | 4 | Background job scheduling, monitoring, and cancellation |
| **Audit** | 1 | Compliance audit log querying with advanced filters |
| **Wallet** | 6 | Balance management, in-app purchases (Apple/Google), transaction history |

All list endpoints use **cursor-based pagination** with full-text search and label filtering support. Content endpoints support **locale parameters** for multi-language access.

## Key Features

### Harmonic Generation & Playback
- Generate harmonic packet sequences across five generation types (Monaural, Binaural, Magnetic, Photonic, Quantal)
- Real-time multi-layer audio rendering with binaural beat synthesis
- Configurable cycle steps with delta frequency and duration control
- Immersive ambience layering with natural soundscapes

### hexaGen Hardware Integration
- Direct USB MIDI communication with hexaGen signal generation devices
- AT command protocol for frequency programming, RGB control, and device management
- Multi-phase operation support: prepare → frequency loading → generation → monitoring
- Real-time device status polling and progress tracking

### Inventory & Formula Management
- Full CRUD for categories, inventory items, and formulas
- Formula composition with drag-to-reorder item management
- Image upload with automatic compression (1920×1080, 85% quality)
- Label-based taxonomy with cross-domain filtering

### Flow & Step System
- Browse pre-built harmonic flows with step-by-step visualization
- Each flow contains an ordered sequence of steps with quantity and timing parameters
- Steps serve as reusable building blocks across multiple flows
- Localized content delivery in multiple languages

### User & Security Management
- Multi-provider authentication: email/password + Google OAuth + Apple Sign-In
- Provider linking — connect multiple auth methods to a single account
- Multi-tenant support with membership roles and tenant switching
- Device approval workflow for trusted device management
- Session monitoring with selective and bulk revocation
- Comprehensive audit logging with severity levels and trace IDs

### Wallet & Purchases
- In-app purchases via Apple App Store and Google Play Store
- Coin-based wallet with balance tracking
- Transaction history with purchase verification
- Backend-verified purchase completion for security

### Background Task System
- Create and schedule background processing jobs
- Status monitoring with progress tracking
- Task cancellation with reason logging
- Support for recurring tasks via cron expressions

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) 3.38+
- Dart SDK ^3.9.2
- [Node.js](https://nodejs.org/) (for commit linting and release automation)
- [pnpm](https://pnpm.io/) (for project tooling)

### Installation

```bash
# Clone the repository
git clone https://github.com/hTuneSys/hexaTuneApp.git
cd hexaTuneApp

# Install project tooling
pnpm install
pnpm prepare

# Install Flutter dependencies
cd hexatuneapp
flutter pub get

# Generate freezed models and DI configuration
dart run build_runner build --delete-conflicting-outputs
```

### Running the Application

```bash
# Development (localhost:8080)
flutter run

# With a specific environment
flutter run --dart-define-from-file=.env.dev
flutter run --dart-define-from-file=.env.test
flutter run --dart-define-from-file=.env.stage
flutter run --dart-define-from-file=.env.prod
```

### Environment Configuration

| File | Environment | API Base URL |
|------|-------------|--------------|
| `.env.dev` | Development | `http://127.0.0.1:8080` |
| `.env.test` | Test | `https://test-api.hexatune.com` |
| `.env.stage` | Staging | `https://stage-api.hexatune.com` |
| `.env.prod` | Production | `https://prod-api.hexatune.com` |

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Static analysis
flutter analyze

# Format code
dart format .
```

## Project Structure

```
hexaTuneApp/
├── .github/                          # CI/CD workflows & GitHub configuration
├── docs/                             # Project documentation
├── fastlane/                         # iOS/Android deployment automation
├── hexatuneapp/                      # Flutter application root
│   ├── lib/
│   │   ├── main.dart                 # Application entry point
│   │   ├── l10n/                     # Localization (English, Turkish)
│   │   └── src/
│   │       ├── app.dart              # MaterialApp configuration
│   │       ├── pages/                # UI pages & layout
│   │       └── core/
│   │           ├── bootstrap/        # App startup orchestration
│   │           ├── config/           # Environment & API configuration
│   │           ├── di/               # Dependency injection (get_it + injectable)
│   │           ├── dsp/              # DSP audio engine & ambience system
│   │           ├── proto/            # Protocol FFI (AT commands, SysEx, USB MIDI)
│   │           ├── hardware/         # hexaGen & headset device drivers
│   │           ├── harmonizer/       # Harmonic generation orchestration
│   │           ├── network/          # HTTP client & interceptors
│   │           ├── rest/             # 14 API domain repositories
│   │           ├── auth/             # PASETO token & auth state management
│   │           ├── storage/          # Secure & preference storage
│   │           ├── notification/     # Push notifications (FCM + local)
│   │           ├── payment/          # In-app purchase integration
│   │           ├── media/            # Image capture & compression
│   │           ├── permission/       # Runtime permission handling
│   │           ├── log/              # Structured logging service
│   │           ├── router/           # GoRouter navigation
│   │           ├── theme/            # Material Design 3 theming
│   │           └── utils/            # Shared utilities
│   ├── assets/
│   │   ├── audio/ambience/           # 28 WAV sound files (base, texture, events)
│   │   ├── fonts/                    # Inter & Rajdhani font families
│   │   └── icon/                     # App icons & ambience SVG icons
│   ├── android/                      # Android platform (JNI native libs)
│   ├── ios/                          # iOS platform (xcframeworks)
│   └── test/                         # Unit & widget tests
├── openapi.json                      # Backend API specification
├── package.json                      # Node.js tooling & scripts
└── CHANGELOG.md                      # Semantic versioning changelog
```

## CI/CD

The project uses GitHub Actions for continuous integration and Fastlane for mobile deployment:

| Workflow | Purpose |
|----------|---------|
| `android-play.yml` | Build Android APK and upload to Google Play |
| `ios-testflight.yml` | Build iOS IPA and upload to TestFlight |
| `commitlint.yml` | Validate conventional commit messages |
| `branch-name-check.yml` | Enforce branch naming conventions |
| `pr-title-check.yml` | Validate pull request title format |
| `release.yml` | Automated semantic release on main merge |
| `reuse-lint.yml` | SPDX license compliance checking |

## Documentation

Comprehensive documentation is available in the `docs/` directory:

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | System architecture, layers, and design patterns |
| [Development Guide](docs/DEVELOPMENT_GUIDE.md) | Dev setup, internal structure, and best practices |
| [Getting Started](docs/GETTING_STARTED.md) | Quick setup and first run instructions |
| [Project Structure](docs/PROJECT_STRUCTURE.md) | Full directory tree and file purposes |
| [Style Guide](docs/STYLE_GUIDE.md) | Dart/Flutter coding conventions |
| [Configuration](docs/CONFIGURATION.md) | Environment variables and CI/CD config |
| [Branch Strategy](docs/BRANCH_STRATEGY.md) | Git branching model and merge rules |
| [Commit Strategy](docs/COMMIT_STRATEGY.md) | Conventional commit format |
| [PR Strategy](docs/PR_STRATEGY.md) | Pull request conventions and review rules |
| [Contributing](docs/CONTRIBUTING.md) | How to contribute |
| [Branding](docs/BRANDING.md) | Visual identity and theming |
| [Security](docs/SECURITY.md) | Security policy and vulnerability reporting |
| [FAQ](docs/FAQ.md) | Frequently asked questions |

## Contributing

We welcome contributions to hexaTuneApp. Please refer to our [Contributing Guide](docs/CONTRIBUTING.md) for details on:

- Branch naming conventions (`feat/`, `fix/`, `refactor/`, `docs/`, `test/`, `ci/`)
- Conventional commit format
- Pull request workflow and review process
- Code style and formatting requirements

## Security

For reporting security vulnerabilities, please refer to our [Security Policy](docs/SECURITY.md). Contact [info@hexatune.com](mailto:info@hexatune.com) for responsible disclosure.

## License

This project is licensed under the [MIT License](LICENSE).

Copyright © 2025 [hexaTune LLC](https://hexatune.com)

---

<p align="center">
  Built by <a href="https://hexatune.com">hexaTune LLC</a> · GitHub: <a href="https://github.com/hTuneSys">hTuneSys</a>
</p>
