# Harmonizer Player — Implementation Plan

## Overview

The **Harmonizer** is an orchestration service that manages frequency generation across multiple hardware/software backends. It accepts one of five generation types (Monaural, Binaural, Magnetic, Photonic, Quantal), validates hardware prerequisites, loads ambience layers when applicable, and drives playback through an infinite loop of frequency steps.

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    HarmonizerService                     │
│  (@singleton, Stream<HarmonizerState>)                  │
├─────────┬──────────┬──────────────┬────────────────────┤
│  DSP    │ HexaGen  │  Headset     │  Ambience           │
│ Service │ Service  │  Service     │  Service            │
├─────────┴──────────┴──────────────┴────────────────────┤
│              Generation Types                           │
│  ✅ Monaural  → DspService (AM mode, no headset req)   │
│  ✅ Binaural  → DspService (binaural mode + headset)   │
│  ✅ Magnetic  → HexagenService (PREPARE→FREQ→GENERATE) │
│  🔒 Photonic  → Future (disabled, placeholder)         │
│  🔒 Quantal   → Future (disabled, placeholder)         │
└─────────────────────────────────────────────────────────┘
```

### Key Decisions (Confirmed with User)
- **API format**: Single endpoint, type sent in request, response returns `List<FreqStepDto>` with `freq`, `durationMs`, `oneshot`
- **State management**: `Stream<HarmonizerState>` (consistent with existing DspService/HexagenService pattern)
- **Mini player**: ShellRoute wrapper + Positioned overlay at bottom
- **Graceful stop**: DSP's existing `stopGraceful()` for Monaural/Binaural; Magnetic falls back to immediate stop until firmware support is added
- **Service location**: `lib/src/core/harmonizer/` (flat structure)
- **Dummy pages**: Single `DummyHarmonizerPage` with all type selection, ambience, play/stop
- **Infinite loop**: Fixed infinite loop initially; cycle count configuration deferred to future iteration

---

## Phase 1 — External Dependencies (User's Manual Work)

These items must be completed by the user before Phase 3 implementation can begin.

### 1.1 Backend API Update
- [ ] **Update `POST /api/v1/harmonics/generate` request** — Add `generationType` field (enum: `monaural`, `binaural`, `magnetic`, `photonic`, `quantal`)
- [ ] **Update response model** — Replace/extend `HarmonicAssignmentDto` with `FreqStepDto`:
  ```json
  {
    "requestId": "uuid",
    "generationType": "binaural",
    "steps": [
      { "freq": 440, "durationMs": 30000, "oneshot": false },
      { "freq": 528, "durationMs": 15000, "oneshot": true }
    ]
  }
  ```
- [ ] **Provide updated `openapi.json`** to the project

### 1.2 Proto FFI — Graceful Stop for HexaGen
- [ ] **Add `AT+OPERATION=id#STOP` command** to hexaTuneProto firmware protocol
- [ ] **Implement graceful stop in firmware** — Current step completes, then DDS stops
- [ ] **Add `AT+OPERATION=id#STOP#COMPLETED` response** for acknowledgement
- [ ] **Release new hexaTuneProto version** with graceful stop support
- [ ] **Update `hexaTuneDsp` FFI bindings** if any proto changes affect the Rust library

### 1.3 Deliverables from User
- [ ] Updated `openapi.json` placed at repo root
- [ ] New hexaTuneProto release tag/version
- [ ] Confirmation that backend graceful stop is ready for integration

---

## Phase 2 — Architecture Fixes (Existing Code)

Fix existing issues that would affect Harmonizer integration.

### 2.1 HexaGen Service — Missing Graceful Stop Method
- [ ] **Add `stopOperationGraceful(int operationId)` method** to `HexagenService`
  - Sends `AT+OPERATION=id#STOP` command
  - Waits for `STOP#COMPLETED` response (with timeout)
  - Falls back to immediate reset if firmware doesn't support it yet
- [ ] **Add `stopOperationImmediate()` method** to `HexagenService`
  - Resets operation state without waiting
  - Clears command trackers
- [ ] **Add unit tests** for both stop methods

### 2.2 HexaGen Service — Operation Flow Completion Tracking
- [ ] **Add `Stream<OperationProgress>` to `HexagenService`**
  - Emits progress for each step during GENERATE phase
  - Includes: `operationId`, `completedStepId`, `totalSteps`, `isComplete`
  - Harmonizer will subscribe to track progress and calculate remaining time
- [ ] **Create `OperationProgress` model** in `models/`
- [ ] **Add unit tests** for operation progress streaming

### 2.3 REST API Models Update
- [ ] **Update `GenerateHarmonicsRequest`** — Add `generationType` field
- [ ] **Create `FreqStepDto` model** — `freq` (int), `durationMs` (int), `oneshot` (bool)
- [ ] **Update `GenerateHarmonicsResponse`** — Replace `assignments` with `steps: List<FreqStepDto>`, add `generationType`
- [ ] **Run `build_runner`** to regenerate freezed/json_serializable code
- [ ] **Update existing harmonics tests** to reflect new model structure
- [ ] **Update `DummyHarmonicsPage`** to work with new response format

### 2.4 AT Command Extension
- [ ] **Add `ATCommand.operationStop(int operationId)`** factory constructor
- [ ] **Add response parsing** for `STOP#COMPLETED` response type
- [ ] **Add unit tests** for new AT command

---

## Phase 3 — Harmonizer Service (New Code)

### 3.1 Models (`lib/src/core/harmonizer/models/`)

#### `generation_type.dart`
- [ ] **Create `GenerationType` enum**: `monaural`, `binaural`, `magnetic`, `photonic`, `quantal`
- [ ] **Add `isActive` getter**: true for monaural/binaural/magnetic, false for photonic/quantal
- [ ] **Add `requiresHeadset` getter**: true only for binaural
- [ ] **Add `requiresHexagen` getter**: true only for magnetic
- [ ] **Add `supportsDspAmbience` getter**: true for monaural/binaural, false for others

#### `harmonizer_state.dart`
- [ ] **Create `HarmonizerState` freezed model**:
  ```dart
  @freezed
  class HarmonizerState {
    GenerationType? activeType;
    HarmonizerStatus status;           // idle, preparing, playing, stopping, error
    String? ambienceId;
    List<FreqStepDto> freqSteps;
    int currentCycle;                  // Current loop iteration (0-based)
    int currentStepIndex;
    Duration totalCycleDuration;       // Total duration of one full cycle
    Duration firstCycleDuration;       // Including oneshots
    Duration remainingInCycle;         // Countdown
    bool isFirstCycle;
    String? errorMessage;
    bool gracefulStopRequested;
  }
  ```
- [ ] **Create `HarmonizerStatus` enum**: `idle`, `preparing`, `playing`, `stopping`, `error`

#### `harmonizer_config.dart`
- [ ] **Create `HarmonizerConfig` freezed model** (input to start playback):
  ```dart
  @freezed
  class HarmonizerConfig {
    required GenerationType type;
    String? ambienceId;
    required List<FreqStepDto> steps;
  }
  ```

### 3.2 Service (`lib/src/core/harmonizer/harmonizer_service.dart`)

#### Core Properties
- [ ] **`@singleton` service** with `DspService`, `HexagenService`, `HeadsetService`, `AmbienceService`, `DspAssetService`, `LogService` dependencies
- [ ] **`Stream<HarmonizerState> get state`** — Broadcast stream for UI binding
- [ ] **`HarmonizerState get currentState`** — Synchronous state snapshot
- [ ] **`bool get isPlaying`** — Convenience getter

#### Validation Methods
- [ ] **`HarmonizerValidation validatePrerequisites(GenerationType type)`**
  - Monaural: always valid
  - Binaural: checks `HeadsetService.isConnected`
  - Magnetic: checks `HexagenService.isConnected`
  - Photonic/Quantal: returns `notSupported`
- [ ] **Create `HarmonizerValidation` enum**: `valid`, `headsetRequired`, `hexagenRequired`, `notSupported`

#### Playback Control
- [ ] **`Future<String?> play(HarmonizerConfig config)`**
  - Validates prerequisites → loads ambience → configures DSP/HexaGen → starts infinite loop
  - Returns null on success, error string on failure
- [ ] **`Future<void> stopGraceful()`**
  - DSP types: `DspService.stopGraceful()`
  - Magnetic: immediate stop fallback (until firmware ready)
- [ ] **`Future<void> stopImmediate()`**
  - All types: immediate stop + full cleanup
- [ ] **`@disposeMethod void dispose()`**

#### Internal DSP Playback
- [ ] **`_startDspPlayback(HarmonizerConfig config)`**
  - Load ambience → configure binaural mode → convert FreqStepDto → CycleStep → start engine
- [ ] **`_startMagneticPlayback(HarmonizerConfig config)`**
  - PREPARE → FREQ×N → GENERATE → on complete restart (infinite loop)

#### Time Tracking
- [ ] **`_startTimeTracker()`** — 1s periodic timer: remaining time, cycle detection, oneshot handling

### 3.3 DI Registration
- [ ] Add `HarmonizerService` to injectable config
- [ ] Run `build_runner`

### 3.4 Unit Tests (`test/core/harmonizer/`)
- [ ] **`generation_type_test.dart`** — All enum getters
- [ ] **`harmonizer_state_test.dart`** — State transitions, durations
- [ ] **`harmonizer_config_test.dart`** — Config creation
- [ ] **`harmonizer_service_test.dart`** — Full service test suite:
  - Prerequisite validation (headset, hexagen, unsupported types)
  - Monaural play (DSP AM mode, no headset)
  - Binaural play (DSP binaural mode, headset verified)
  - Magnetic play (PREPARE→FREQ→GENERATE flow)
  - Graceful stop, immediate stop
  - Ambience loading
  - State stream transitions
  - Cycle time tracking
  - Error handling
  - Dispose cleanup

---

## Phase 4 — UI Components (Dummy Pages & Mini Player)

### 4.1 Route Registration
- [ ] Add `harmonizer` to `RouteNames`: `/dev/harmonizer`
- [ ] Add `GoRoute` in `app_router.dart`
- [ ] Add navigation link in `DummyHomePage`

### 4.2 ShellRoute Wrapper
- [ ] **Create `HarmonizerShellWrapper`** (`lib/src/pages/dummy/widgets/harmonizer_shell_wrapper.dart`)
  - `Stack` with child + `Positioned(bottom: 0)` mini player
  - Listens to `HarmonizerService.state`
  - Shows when playing AND not on harmonizer page
- [ ] **Wrap `/dev/*` routes** with `ShellRoute` in `app_router.dart`

### 4.3 Mini Harmonizer Widget (`lib/src/pages/dummy/widgets/mini_harmonizer_bar.dart`)
- [ ] **Layout**: Left=total duration | Center=stop button | Right=countdown
- [ ] **Stop behavior**: tap=graceful, 3s long-press=immediate
- [ ] **Fade-out**: ~2s after stop completes
- [ ] **Theme**: MD3 `SurfaceContainer` + theme colors

### 4.4 DummyHarmonizerPage
- [ ] **Type selection**: 5 chips (3 active, 2 disabled "coming soon")
- [ ] **Prerequisite warnings**: Container messages for missing hardware
- [ ] **Ambience selector**: Dropdown from AmbienceService (Monaural/Binaural only)
- [ ] **"+" button**: Navigate to DummyAmbiencePage
- [ ] **Play/Stop controls**: Play button + stop (tap=graceful, long-press=immediate)
- [ ] **Duration display**: Total cycle | Remaining countdown
- [ ] **Hardcoded test freq list** for dummy testing
- [ ] **Frequency steps list** display with freq, duration, oneshot badge

### 4.5 l10n Strings
- [ ] Add harmonizer strings to `app_en.arb` and `app_tr.arb`
- [ ] Run `flutter gen-l10n`

### 4.6 Widget Tests
- [ ] **`dummy_harmonizer_page_test.dart`** — Type toggles, warnings, play states

---

## Phase 5 — Documentation

- [ ] All public APIs have dartdoc comments
- [ ] Update `docs/ARCHITECTURE.md` — Harmonizer section
- [ ] Update `docs/PROJECT_STRUCTURE.md` — Directory listing

---

## Dependency Graph

```
Phase 1 (User: Backend + Proto)
    │
    ├──→ Phase 2.3 (REST model update — needs openapi.json)
    ├──→ Phase 2.1 (HexaGen graceful stop — needs proto)
    └──→ Phase 2.4 (AT command extension — needs proto)

Independent (can start now):
    Phase 2.2 (operation progress — existing code improvement)
    Phase 3.1 (model definitions — no external dependency)
    Phase 4.1 (route registration)
    Phase 4.5 (l10n strings)
```

## Notes

- **Infinite loop**: Hardcoded as infinite. Cycle count configuration is a future feature.
- **Frequency list source**: Backend API. Hardcoded values for dummy testing.
- **Mini player disappear**: Fades out ~2s after stop.
- **Concurrent playback**: Only one session at a time. New play stops current.
- **Memory**: DSP decode cache auto-cleared by service layer (previous fix).
