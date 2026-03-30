// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/models/device_response.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Devices management page for viewing and removing registered devices.
class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<DeviceResponse>? _devices;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<DeviceRepository>();
      final devices = await repo.listDevices();
      if (mounted) {
        setState(() => _devices = devices);
      }
      log.devLog(
        'Devices loaded: ${devices.length}',
        category: LogCategory.device,
      );
    } catch (e) {
      log.devLog('Load devices failed: $e', category: LogCategory.device);
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDevice(DeviceResponse device) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogTheme = Theme.of(ctx);
        return AlertDialog(
          title: Text(l10n.devicesDeleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.devicesDeleteCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                elevation: 1,
                backgroundColor: dialogTheme.colorScheme.error,
                foregroundColor: dialogTheme.colorScheme.onError,
              ),
              child: Text(l10n.devicesDeleteConfirmAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<DeviceRepository>();
      await repo.deleteDevice(device.id);
      if (mounted) {
        setState(() => _devices?.removeWhere((d) => d.id == device.id));
        AppSnackBar.success(context, message: l10n.devicesDeleted);
      }
      log.devLog('Device deleted: ${device.id}', category: LogCategory.device);
    } catch (e) {
      log.devLog('Delete device failed: $e', category: LogCategory.device);
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
        title: Text(l10n.devicesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadDevices,
          ),
        ],
      ),
      body: _buildBody(theme, l10n),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l10n) {
    if (_isLoading && _devices == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _devices == null) {
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
            Text(l10n.devicesNoDevices, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loadDevices,
              child: Text(l10n.devicesRetry),
            ),
          ],
        ),
      );
    }

    final devices = _devices;
    if (devices == null || devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.devices_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(l10n.devicesNoDevices, style: theme.textTheme.titleMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDevices,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + AppBottomBar.scrollPadding,
        ),
        itemCount: devices.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _buildDeviceCard(theme, l10n, devices[index]),
      ),
    );
  }

  Widget _buildDeviceCard(
    ThemeData theme,
    AppLocalizations l10n,
    DeviceResponse device,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: device.isTrusted
                      ? Chip(
                          label: Text(l10n.devicesTrusted),
                          avatar: Icon(
                            Icons.verified,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          backgroundColor: theme.colorScheme.primaryContainer,
                          labelStyle: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          side: BorderSide.none,
                        )
                      : Chip(
                          label: Text(l10n.devicesNotTrusted),
                          avatar: Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: theme.colorScheme.error,
                          ),
                          backgroundColor: theme.colorScheme.errorContainer,
                          labelStyle: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          side: BorderSide.none,
                        ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  tooltip: l10n.devicesDelete,
                  onPressed: _isLoading ? null : () => _deleteDevice(device),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow(theme, l10n.devicesUserAgent, device.userAgent),
            _infoRow(theme, l10n.devicesIpAddress, device.ipAddress),
            _infoRow(theme, l10n.devicesFirstSeen, device.firstSeenAt),
            _infoRow(theme, l10n.devicesLastSeen, device.lastSeenAt),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
