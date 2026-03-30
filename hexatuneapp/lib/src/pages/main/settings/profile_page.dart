// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/rest/account/account_repository.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Profile page for editing user profile.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _displayNameCtrl = TextEditingController();
  final _avatarUrlCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  ProfileResponse? _profile;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _avatarUrlCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<AccountRepository>();
      final profile = await repo.getProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _displayNameCtrl.text = profile.displayName ?? '';
          _avatarUrlCtrl.text = profile.avatarUrl ?? '';
          _bioCtrl.text = profile.bio ?? '';
        });
      }
      log.devLog('Profile data loaded', category: LogCategory.ui);
    } catch (e) {
      log.devLog('Load profile data failed: $e', category: LogCategory.ui);
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<AccountRepository>();
      final updated = await repo.updateProfile(
        UpdateProfileRequest(
          displayName: _displayNameCtrl.text.trim().isEmpty
              ? null
              : _displayNameCtrl.text.trim(),
          avatarUrl: _avatarUrlCtrl.text.trim().isEmpty
              ? null
              : _avatarUrlCtrl.text.trim(),
          bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
        ),
      );
      if (mounted) {
        setState(() => _profile = updated);
        final l10n = AppLocalizations.of(context)!;
        AppSnackBar.success(context, message: l10n.profileUpdated);
      }
      log.devLog('Profile updated', category: LogCategory.ui);
    } catch (e) {
      log.devLog('Update profile failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.settings),
        ),
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
          ),
        ],
      ),
      body: _buildBody(theme, l10n),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l10n) {
    if (_isLoading && _profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _profile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(l10n.profileNoData, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadData,
              child: Text(l10n.profileRetry),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + AppBottomBar.scrollPadding,
      ),
      children: [_buildFormSection(theme, l10n)],
    );
  }

  Widget _buildFormSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileDisplayName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceContainerLow,
          child: TextField(
            controller: _displayNameCtrl,
            decoration: InputDecoration(hintText: l10n.profileDisplayName),
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.profileAvatarUrl,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceContainerLow,
          child: TextField(
            controller: _avatarUrlCtrl,
            decoration: InputDecoration(hintText: l10n.profileAvatarUrl),
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.profileBio,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surfaceContainerLow,
          child: TextField(
            controller: _bioCtrl,
            decoration: InputDecoration(hintText: l10n.profileBio),
            maxLines: 3,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _isLoading ? null : _updateProfile,
          style: FilledButton.styleFrom(
            elevation: 1,
            minimumSize: const Size.fromHeight(48),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(l10n.profileSave),
        ),
      ],
    );
  }
}
