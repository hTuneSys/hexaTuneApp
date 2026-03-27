// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_verification_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/provider_repository.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/storage/otp_timer_service.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/otp_input_field.dart';
import 'package:hexatuneapp/src/pages/provider/provider_reset_password_sheet.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Production provider management page with email, Google, and Apple sections.
class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key});

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  List<ProviderResponse> _providers = [];
  bool _isLoading = false;
  bool _isActionLoading = false;

  // Email link form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Email OTP verification
  final _otpKey = GlobalKey<OtpInputFieldState>();
  String _otpCode = '';
  String? _pendingVerifyEmail;
  int _resendSeconds = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Data loading
  // ---------------------------------------------------------------------------

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<ProviderRepository>();
      final providers = await repo.listProviders();
      if (!mounted) return;
      setState(() => _providers = providers);
      log.devLog(
        '✓ Providers loaded: ${providers.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load providers failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Provider helpers
  // ---------------------------------------------------------------------------

  ProviderResponse? _findProvider(String type) {
    for (final p in _providers) {
      if (p.providerType.toLowerCase() == type.toLowerCase()) return p;
    }
    return null;
  }

  bool get _isEmailVerified => _findProvider('email')?.emailVerified ?? true;

  // ---------------------------------------------------------------------------
  // Email actions
  // ---------------------------------------------------------------------------

  Future<void> _linkEmail() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      AppSnackBar.error(context, message: l10n.providerEmailRequired);
      return;
    }
    if (password.isEmpty) {
      AppSnackBar.error(context, message: l10n.providerPasswordRequired);
      return;
    }

    setState(() => _isActionLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Link email provider: $email', category: LogCategory.ui);

      final repo = getIt<ProviderRepository>();
      final result = await repo.linkEmail(
        LinkEmailProviderRequest(email: email, password: password),
      );

      final otpTimer = getIt<OtpTimerService>();
      await otpTimer.saveOtpExpiry(
        OtpFlow.emailProviderLink,
        email,
        result.expiresInSeconds,
      );

      log.devLog('✓ Email link OTP sent', category: LogCategory.ui);

      if (!mounted) return;
      setState(() {
        _pendingVerifyEmail = email;
        _resendSeconds = result.expiresInSeconds;
      });
      _startCountdown();
      await _loadProviders();
    } catch (e) {
      log.devLog('✗ Link email failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _verifyEmail() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _pendingVerifyEmail ?? _findProvider('email')?.email;
    if (email == null || _otpCode.length < 6) {
      AppSnackBar.error(context, message: l10n.otpRequired);
      return;
    }

    setState(() => _isActionLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Verify provider email: $email', category: LogCategory.ui);

      final authRepo = getIt<AuthRepository>();
      await authRepo.verifyEmail(
        VerifyEmailRequest(email: email, code: _otpCode),
      );

      log.devLog('✓ Provider email verified', category: LogCategory.ui);

      if (!mounted) return;
      AppSnackBar.success(context, message: l10n.providerEmailLinked);
      setState(() {
        _pendingVerifyEmail = null;
        _otpCode = '';
      });
      _otpKey.currentState?.clear();
      await _loadProviders();
    } catch (e) {
      log.devLog('✗ Verify email failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _resendVerification() async {
    final email = _pendingVerifyEmail ?? _findProvider('email')?.email;
    if (email == null) return;

    setState(() => _isActionLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Resend verification: $email', category: LogCategory.ui);

      final authRepo = getIt<AuthRepository>();
      final result = await authRepo.resendVerification(
        ResendVerificationRequest(email: email),
      );

      final otpTimer = getIt<OtpTimerService>();
      await otpTimer.saveOtpExpiry(
        OtpFlow.emailProviderLink,
        email,
        result.expiresInSeconds,
      );

      log.devLog('✓ Verification resent', category: LogCategory.ui);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.success(context, message: l10n.verificationCodeResent);
      setState(() => _resendSeconds = result.expiresInSeconds);
      _startCountdown();
    } catch (e) {
      log.devLog('✗ Resend failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Google actions
  // ---------------------------------------------------------------------------

  Future<void> _linkGoogle() async {
    setState(() => _isActionLoading = true);
    final log = getIt<LogService>();

    try {
      final oauthService = getIt<OAuthService>();
      final request = await oauthService.signInWithGoogle();

      final repo = getIt<ProviderRepository>();
      await repo.linkGoogle(
        LinkGoogleProviderRequest(idToken: request.idToken),
      );

      log.devLog('✓ Google linked', category: LogCategory.ui);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.success(context, message: l10n.providerGoogleLinked);
      await _loadProviders();
    } on OAuthCancelledException {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.info(context, message: l10n.providerOAuthCancelled);
    } on OAuthException catch (e) {
      log.devLog('✗ Google link failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } catch (e) {
      log.devLog('✗ Google link failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Apple actions
  // ---------------------------------------------------------------------------

  Future<void> _linkApple() async {
    setState(() => _isActionLoading = true);
    final log = getIt<LogService>();

    try {
      final oauthService = getIt<OAuthService>();
      final request = await oauthService.signInWithApple();

      final repo = getIt<ProviderRepository>();
      await repo.linkApple(LinkAppleProviderRequest(idToken: request.idToken));

      log.devLog('✓ Apple linked', category: LogCategory.ui);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.success(context, message: l10n.providerAppleLinked);
      await _loadProviders();
    } on OAuthCancelledException {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.info(context, message: l10n.providerOAuthCancelled);
    } on OAuthNotAvailableException {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.info(context, message: l10n.providerOAuthNotAvailable);
    } on OAuthException catch (e) {
      log.devLog('✗ Apple link failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } catch (e) {
      log.devLog('✗ Apple link failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Unlink
  // ---------------------------------------------------------------------------

  Future<void> _unlinkProvider(String providerType) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.providerUnlink),
        content: Text(l10n.providerUnlinkConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.providerUnlinkCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.providerUnlinkConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isActionLoading = true);
    final log = getIt<LogService>();

    try {
      log.devLog('→ Unlink provider: $providerType', category: LogCategory.ui);

      final repo = getIt<ProviderRepository>();
      await repo.unlinkProvider(providerType);

      log.devLog('✓ Provider unlinked', category: LogCategory.ui);

      if (!mounted) return;
      AppSnackBar.success(context, message: l10n.providerUnlinked);
      if (providerType == 'email') {
        setState(() => _pendingVerifyEmail = null);
      }
      await _loadProviders();
    } catch (e) {
      log.devLog('✗ Unlink failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Reset password
  // ---------------------------------------------------------------------------

  void _showResetPasswordSheet() {
    final email = _findProvider('email')?.email;
    if (email == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ProviderResetPasswordSheet(
        email: email,
        onSuccess: () => _loadProviders(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Timer
  // ---------------------------------------------------------------------------

  void _startCountdown() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _formattedTimer {
    final m = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.providerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadProviders,
          ),
        ],
      ),
      body: _isLoading && _providers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + AppBottomBar.scrollPadding,
              ),
              children: [
                _buildEmailSection(l10n, theme),
                const SizedBox(height: 16),
                _buildGoogleSection(l10n, theme),
                const SizedBox(height: 16),
                _buildAppleSection(l10n, theme),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // Email section
  // ---------------------------------------------------------------------------

  Widget _buildEmailSection(AppLocalizations l10n, ThemeData theme) {
    final emailProvider = _findProvider('email');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.email, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.providerEmailSection,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (emailProvider != null)
                  Chip(
                    label: Text(
                      _isEmailVerified
                          ? l10n.providerEmailVerified
                          : l10n.providerEmailNotVerified,
                    ),
                    backgroundColor: _isEmailVerified
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.errorContainer,
                    labelStyle: theme.textTheme.labelSmall?.copyWith(
                      color: _isEmailVerified
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                    ),
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (emailProvider == null)
              _buildEmailLinkForm(l10n, theme)
            else if (!_isEmailVerified || _pendingVerifyEmail != null)
              _buildEmailVerifySection(l10n, theme, emailProvider)
            else
              _buildEmailVerifiedSection(l10n, theme, emailProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailLinkForm(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceContainerLow,
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: l10n.providerEmailHint),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceContainerLow,
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: l10n.providerPasswordHint,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _linkEmail(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _isActionLoading ? null : _linkEmail,
          icon: _isActionLoading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.link),
          label: Text(l10n.providerLinkWithEmail),
        ),
      ],
    );
  }

  Widget _buildEmailVerifySection(
    AppLocalizations l10n,
    ThemeData theme,
    ProviderResponse provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(provider.email ?? '', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(
          l10n.providerVerifyEmailSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        OtpInputField(
          key: _otpKey,
          onCompleted: (code) {
            _otpCode = code;
            _verifyEmail();
          },
          onChanged: (code) => _otpCode = code,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _isActionLoading ? null : _verifyEmail,
          child: _isActionLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(l10n.verify),
        ),
        const SizedBox(height: 8),
        Center(
          child: _resendSeconds > 0
              ? Text(
                  l10n.resendIn(_formattedTimer),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : TextButton(
                  onPressed: _isActionLoading ? null : _resendVerification,
                  child: Text(l10n.resendCode),
                ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isActionLoading ? null : () => _unlinkProvider('email'),
          icon: Icon(Icons.link_off, color: theme.colorScheme.error),
          label: Text(
            l10n.providerUnlink,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailVerifiedSection(
    AppLocalizations l10n,
    ThemeData theme,
    ProviderResponse provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(provider.email ?? '', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          l10n.providerLinkedAt(provider.linkedAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _isActionLoading ? null : _showResetPasswordSheet,
          icon: const Icon(Icons.lock_reset),
          label: Text(l10n.providerResetPassword),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isActionLoading ? null : () => _unlinkProvider('email'),
          icon: Icon(Icons.link_off, color: theme.colorScheme.error),
          label: Text(
            l10n.providerUnlink,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Google section
  // ---------------------------------------------------------------------------

  Widget _buildGoogleSection(AppLocalizations l10n, ThemeData theme) {
    final googleProvider = _findProvider('google');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.g_mobiledata, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.providerGoogleSection,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (googleProvider == null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isActionLoading ? null : _linkGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: Text(l10n.providerLinkWithGoogle),
                ),
              )
            else ...[
              if (googleProvider.email != null)
                Text(googleProvider.email!, style: theme.textTheme.bodyMedium),
              Text(
                l10n.providerLinkedAt(googleProvider.linkedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isActionLoading
                      ? null
                      : () => _unlinkProvider('google'),
                  icon: Icon(Icons.link_off, color: theme.colorScheme.error),
                  label: Text(
                    l10n.providerUnlink,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Apple section
  // ---------------------------------------------------------------------------

  Widget _buildAppleSection(AppLocalizations l10n, ThemeData theme) {
    final appleProvider = _findProvider('apple');
    final isAppleAvailable = Platform.isIOS || Platform.isMacOS;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.apple, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.providerAppleSection,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (appleProvider == null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isActionLoading && isAppleAvailable
                      ? null
                      : isAppleAvailable
                      ? _linkApple
                      : null,
                  icon: const Icon(Icons.apple),
                  label: Text(
                    isAppleAvailable
                        ? l10n.providerLinkWithApple
                        : l10n.providerOAuthNotAvailable,
                  ),
                ),
              )
            else ...[
              if (appleProvider.email != null)
                Text(appleProvider.email!, style: theme.textTheme.bodyMedium),
              Text(
                l10n.providerLinkedAt(appleProvider.linkedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isActionLoading
                      ? null
                      : () => _unlinkProvider('apple'),
                  icon: Icon(Icons.link_off, color: theme.colorScheme.error),
                  label: Text(
                    l10n.providerUnlink,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
