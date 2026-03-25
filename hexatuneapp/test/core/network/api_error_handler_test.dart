// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/network/api_error_type.dart';
import 'package:hexatuneapp/src/core/network/api_exception.dart';

Widget _buildApp({required Widget child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(),
    ),
    home: Scaffold(body: child),
  );
}

void main() {
  group('ApiErrorHandler', () {
    group('handle', () {
      testWidgets('shows error snackbar for ApiException', (tester) async {
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ApiErrorHandler.handle(
                  context,
                  const ApiException.notFound(errorType: 'not-found'),
                ),
                child: const Text('Trigger'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('not found', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('shows generic error for non-ApiException', (tester) async {
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    ApiErrorHandler.handle(context, Exception('Random error')),
                child: const Text('Trigger'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('unexpected error', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('extracts ApiException from DioException wrapper', (
        tester,
      ) async {
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ApiErrorHandler.handle(
                  context,
                  DioException(
                    requestOptions: RequestOptions(path: '/test'),
                    error: const ApiException.badRequest(
                      errorType: 'bad-request',
                    ),
                  ),
                ),
                child: const Text('Trigger'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('check your input', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('shows localized message for email-already-exists', (
        tester,
      ) async {
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ApiErrorHandler.handle(
                  context,
                  const ApiException.conflict(
                    errorType: 'email-already-exists',
                  ),
                ),
                child: const Text('Trigger'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('already registered', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('falls back to exception subtype when no errorType', (
        tester,
      ) async {
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ApiErrorHandler.handle(
                  context,
                  const ApiException.network(),
                ),
                child: const Text('Trigger'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('internet connection', skipOffstage: false),
          findsOneWidget,
        );
      });
    });

    group('resolveMessage', () {
      testWidgets('maps errorType to l10n key', (tester) async {
        late String result;
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                result = ApiErrorHandler.resolveMessage(
                  l10n,
                  const ApiException.forbidden(errorType: 'account-locked'),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(result, contains('locked'));
      });

      testWidgets('falls back to subtype for unknown errorType', (
        tester,
      ) async {
        late String result;
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                result = ApiErrorHandler.resolveMessage(
                  l10n,
                  const ApiException.timeout(errorType: 'some-unknown-type'),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(result, contains('timed out'));
      });

      testWidgets('falls back to subtype when errorType is null', (
        tester,
      ) async {
        late String result;
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                result = ApiErrorHandler.resolveMessage(
                  l10n,
                  const ApiException.server(),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(result, contains('went wrong'));
      });

      testWidgets('maps all 18 error types without error', (tester) async {
        late bool allMapped;
        await tester.pumpWidget(
          _buildApp(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                final types = [
                  ApiErrorType.unauthorized,
                  ApiErrorType.forbidden,
                  ApiErrorType.notFound,
                  ApiErrorType.badRequest,
                  ApiErrorType.validationFailed,
                  ApiErrorType.conflict,
                  ApiErrorType.internalError,
                  ApiErrorType.tooManyAttempts,
                  ApiErrorType.accountLocked,
                  ApiErrorType.accountSuspended,
                  ApiErrorType.emailNotVerified,
                  ApiErrorType.emailAlreadyExists,
                  ApiErrorType.emailAlreadyVerified,
                  ApiErrorType.providerAlreadyLinked,
                  ApiErrorType.passwordResetTokenInvalid,
                  ApiErrorType.passwordResetMaxAttempts,
                  ApiErrorType.verificationTokenInvalid,
                  ApiErrorType.verificationMaxAttempts,
                ];
                allMapped = types.every((type) {
                  final msg = ApiErrorHandler.resolveMessage(
                    l10n,
                    ApiException.unknown(errorType: type),
                  );
                  return msg.isNotEmpty;
                });
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(allMapped, isTrue);
      });
    });
  });
}
