<!--
SPDX-FileCopyrightText: 2025 hexaTune LLC
SPDX-License-Identifier: MIT
-->

# hexaTuneApp — Flutter Application

A B2B inventory management Flutter application that connects to a REST API backend. The app provides inventory tracking, formula management, task workflows, and multi-device session management with device approval flows.

## Requirements

- **Flutter:** 3.38+ (Dart SDK ^3.9.2)
- **Platforms:** Android, iOS, Web, Linux, macOS, Windows

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate freezed models and DI code
dart run build_runner build --delete-conflicting-outputs

# Run with default dev environment (localhost:8080)
flutter run

# Run with a specific environment
flutter run --dart-define-from-file=.env.test
flutter run --dart-define-from-file=.env.stage
flutter run --dart-define-from-file=.env.prod
```

## Environment Configuration

Build-time environment variables are injected via `--dart-define-from-file`. Four environment files are available:

| File | Environment | API Base URL |
|------|-------------|--------------|
| `.env.dev` | Development | `http://127.0.0.1:8080` |
| `.env.test` | Test | `https://test-api.hexatune.com` |
| `.env.stage` | Staging | `https://stage-api.hexatune.com` |
| `.env.prod` | Production | `https://prod-api.hexatune.com` |

When no env file is provided, defaults to `dev` with `http://127.0.0.1:8080`.

Access in code via `Env.apiBaseUrl`, `Env.isDev`, `Env.isProd`, etc.

## Project Structure

```
lib/
├── main.dart                          # Entry point
├── l10n/                              # Localization (en, tr)
└── src/
    ├── app.dart                       # MaterialApp setup
    ├── pages/                         # UI pages (future)
    │   └── layout.dart
    └── core/                          # Core infrastructure
        ├── config/                    # Configuration
        ├── di/                        # Dependency injection
        ├── bootstrap/                 # App startup orchestration
        ├── network/                   # HTTP client & interceptors
        ├── auth/                      # Authentication & token management
        ├── storage/                   # Secure & preference storage
        ├── log/                       # Logging service
        ├── notification/              # Push notifications (FCM)
        ├── media/                     # Image capture & processing
        ├── device/                    # Device info & approval flows
        ├── permission/                # Runtime permissions
        ├── router/                    # GoRouter navigation
        ├── account/                   # Account & profile management
        ├── session/                   # Session management
        ├── audit/                     # Audit log queries
        ├── category/                  # Category CRUD
        ├── inventory/                 # Inventory CRUD & image upload
        ├── formula/                   # Formula & item management
        ├── task/                      # Async task workflows
        ├── theme/                     # App theming
        └── utils/                     # Utilities
```

## Core Architecture

### Bootstrap Sequence

`AppBootstrap.initialize()` runs at app startup in this order:

1. **DI container** — Registers all singletons via `injectable`/`get_it`
2. **Device fingerprint** — Collects device metadata for API identification
3. **Token loading** — Restores PASETO tokens from secure storage
4. **Notifications** — Initializes local notifications and Firebase Cloud Messaging
5. **Auth check** — Validates stored tokens, sets initial auth state
6. **Push token registration** — Sends FCM token to backend if authenticated

### Dependency Injection

Uses `get_it` + `injectable` for compile-time safe DI. All services and repositories are `@singleton`. Code generation via `build_runner` produces `injection.config.dart`.

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Network Layer

| Component | Purpose |
|-----------|---------|
| `ApiClient` | Singleton Dio instance with base URL from `Env` and timeout constants |
| `AuthInterceptor` | Attaches PASETO Bearer token, handles 401 with automatic token refresh |
| `ErrorInterceptor` | Maps HTTP errors to typed `ApiException` subtypes, parses RFC 7807 `ProblemDetails` |
| `LoggingInterceptor` | Request/response logging via Talker |

**Interceptor chain order:** Logging → Auth → Error

**Token refresh:** On 401, `AuthInterceptor` queues concurrent requests (via `QueuedInterceptor`), refreshes using a separate Dio instance to avoid interceptor recursion, then retries all queued requests.

### Authentication

- **Token format:** PASETO (Platform-Agnostic Security Tokens)
- **Storage:** `flutter_secure_storage` for `accessToken`, `refreshToken`, `sessionId`, `expiresAt`
- **Auth state stream:** `AuthService` broadcasts `authenticated`/`unauthenticated` states for reactive routing
- **Auth events:** `forceLogout`, `reAuthRequired`, `deviceApprovalRequired` emitted from interceptor layer

### Error Handling

All API errors are mapped to sealed `ApiException` subtypes:

| HTTP Status | Exception Type |
|-------------|---------------|
| 400 | `BadRequestException` |
| 401 | `UnauthorizedException` |
| 403 | `ForbiddenException` |
| 404 | `NotFoundException` |
| 409 | `ConflictException` |
| 422 | `ValidationException` |
| 429 | `RateLimitedException` |
| 5xx | `ServerException` |
| Network | `NetworkException` |
| Timeout | `TimeoutException` |
| Unknown | `UnknownException` |

Errors carry optional `traceId` from backend `ProblemDetails` responses for debugging.

## API Domains

The app communicates with 46 endpoints across 10 domains. All endpoint paths are centralized in `ApiEndpoints`.

### Authentication — 9 endpoints
Login, register, logout, token refresh, re-authentication, forgot/reset password, email verification.

### Accounts & Profile — 3 endpoints
Get account info, get profile, update profile.

### Sessions — 3 endpoints
List active sessions, revoke all sessions, revoke other sessions.

### Devices — 6 endpoints
Register/remove push tokens, create/approve/reject device approval requests, check approval status.

### Categories — 5 endpoints
List (cursor-paginated), create, get by ID, update, delete.

### Inventories — 6 endpoints
List (cursor-paginated), create (multipart with image), get by ID, update (multipart), delete, get image URL (pre-signed).

### Formulas — 9 endpoints
List, create, get by ID, update, delete. Item management: add items, remove item, update item quantity, reorder items.

### Tasks — 4 endpoints
List (with status/type filters), create, get status, cancel.

### Audit — 1 endpoint
Query audit logs with filters (date range, action, resource type, actor).

## Repository Pattern

Every domain follows the same structure:

```
core/{domain}/
├── {domain}_repository.dart       # API calls → typed responses
└── models/
    ├── {name}_response.dart       # Response DTOs (freezed)
    └── {name}_request.dart        # Request DTOs (freezed)
```

Repositories are `@singleton`, injected with `ApiClient` and `LogService`. They return typed model objects and throw `ApiException` on errors. Paginated endpoints return `PaginatedResponse<T>` with cursor-based navigation.

## Data Models

All API models use [freezed](https://pub.dev/packages/freezed) for immutable data classes with `fromJson`/`toJson` serialization. Generated files (`*.freezed.dart`, `*.g.dart`) are produced by `build_runner`.

**JSON key format:** Backend uses camelCase for most fields. Exceptions with `@JsonKey`:
- `PaginationMeta`: `has_more`, `next_cursor` (snake_case)
- `ProblemDetails`: `trace_id` (snake_case)

## Pagination

Cursor-based pagination via `PaginationParams`:

```dart
final params = PaginationParams(cursor: 'abc', limit: 20, sort: 'name', query: 'search');
final response = await categoryRepository.list(params: params);
// response.data — List<CategoryResponse>
// response.pagination.hasMore — bool
// response.pagination.nextCursor — String?
```

## Image Handling

`ImageService` provides camera capture and gallery selection with automatic compression:
- Max resolution: 1920×1080
- Quality: 85%
- Aspect ratio: 16:9

Inventory create/update endpoints accept multipart form data with an image field.

## Push Notifications

- **Remote:** Firebase Cloud Messaging (FCM) for Android and APNs via FCM for iOS
- **Local:** `flutter_local_notifications` for foreground message display
- **Registration:** Push token is automatically sent to backend after authentication
- **Topics:** Subscription support for broadcast notifications

## Logging

`LogService` wraps [Talker](https://pub.dev/packages/talker) with:
- 6 log levels: verbose, debug, info, warning, error, critical
- Category tagging for filtering (AUTH, NETWORK, STORAGE, etc.)
- In-memory history (max 1000 entries)
- HTTP request/response logging via `LoggingInterceptor`

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/auth/auth_service_test.dart

# Static analysis
flutter analyze
```

**Test structure mirrors source:** `test/core/{domain}/` for unit tests, `integration_test/` for integration tests.

| Category | Test Files | Tests |
|----------|-----------|-------|
| Model serialization | 12 | 157 |
| Network & interceptors | 5 | 30 |
| Auth service & token | 3 | 24 |
| Repository HTTP mocks | 1 | 6 |
| Media, logging, routing | 3 | 16 |
| Integration stubs | 3 | — |
| **Total** | **27** | **257** |

**Testing libraries:** `mocktail` for mocks, `http_mock_adapter` for Dio HTTP mocks, `fake_async` for timer testing.

## Code Generation

After modifying any `@freezed` model or `@injectable`/`@singleton` service:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `*.freezed.dart` — Immutable data class implementations
- `*.g.dart` — JSON serialization logic
- `injection.config.dart` — DI registration code

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `dio` | HTTP client |
| `get_it` + `injectable` | Dependency injection |
| `freezed` + `json_serializable` | Immutable models & JSON serialization |
| `talker` | Structured logging |
| `flutter_secure_storage` | Encrypted token storage |
| `firebase_messaging` | Push notifications |
| `image_picker` + `flutter_image_compress` | Camera/gallery & image processing |
| `go_router` | Declarative navigation |
| `device_info_plus` | Device fingerprinting |
| `permission_handler` | Runtime permission management |

## Fonts

The app uses two custom font families:
- **Inter** — Primary UI font (Regular, Medium, SemiBold, Bold)
- **Rajdhani** — Secondary/accent font (Regular, Medium, SemiBold, Bold)
