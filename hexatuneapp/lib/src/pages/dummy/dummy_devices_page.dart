// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approve_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/create_approval_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/rest/device/models/reject_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/unregister_push_token_request.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';

/// Dummy page for testing device and approval endpoints.
class DummyDevicesPage extends StatefulWidget {
  const DummyDevicesPage({super.key});

  @override
  State<DummyDevicesPage> createState() => _DummyDevicesPageState();
}

class _DummyDevicesPageState extends State<DummyDevicesPage> {
  final _approvalIdCtrl = TextEditingController();
  final _operationTypeCtrl = TextEditingController(text: 'device_login');
  final _rejectReasonCtrl = TextEditingController();
  final _deviceIdCtrl = TextEditingController();
  String? _resultText;
  bool _isLoading = false;

  @override
  void dispose() {
    _approvalIdCtrl.dispose();
    _operationTypeCtrl.dispose();
    _rejectReasonCtrl.dispose();
    _deviceIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _run(String label, Future<String> Function() action) async {
    setState(() {
      _isLoading = true;
      _resultText = null;
    });
    final log = getIt<LogService>();
    try {
      log.devLog('→ $label', category: LogCategory.ui);
      final result = await action();
      if (mounted) setState(() => _resultText = '✓ $label\n$result');
    } catch (e) {
      log.devLog('✗ $label failed: $e', category: LogCategory.ui);
      if (mounted) setState(() => _resultText = '✗ $label\n$e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Devices & Approvals')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Push Token
          Text('Push Token', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Register'),
                  onPressed: _isLoading
                      ? null
                      : () => _run('Register Push Token', () async {
                          final notifService = getIt<NotificationService>();
                          if (notifService.fcmToken == null) {
                            await notifService.init();
                          }
                          final token = notifService.fcmToken;
                          if (token == null) return 'No FCM token available';
                          final repo = getIt<DeviceRepository>();
                          await repo.registerPushToken(
                            RegisterPushTokenRequest(
                              token: token,
                              platform: Platform.isIOS ? 'ios' : 'android',
                              appId: Env.appBundleId,
                            ),
                          );
                          final preview = token.length > 20
                              ? '${token.substring(0, 20)}…'
                              : token;
                          return 'Token registered: $preview';
                        }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.notifications_off),
                  label: const Text('Remove'),
                  onPressed: _isLoading
                      ? null
                      : () => _run('Remove Push Token', () async {
                          final repo = getIt<DeviceRepository>();
                          await repo.removePushToken(
                            UnregisterPushTokenRequest(appId: Env.appBundleId),
                          );
                          return 'Push token removed';
                        }),
                ),
              ),
            ],
          ),
          const Divider(height: 32),

          // Request Approval
          Text('Device Approval', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _operationTypeCtrl,
            decoration: const InputDecoration(
              labelText: 'Operation Type',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () => _run('Request Approval', () async {
                    final deviceService = getIt<DeviceService>();
                    final repo = getIt<DeviceRepository>();
                    final resp = await repo.requestApproval(
                      CreateApprovalRequestDto(
                        requestingDeviceId: deviceService.deviceId,
                        operationType: _operationTypeCtrl.text.trim(),
                      ),
                    );
                    _approvalIdCtrl.text = resp.requestId;
                    return 'Request ID: ${resp.requestId}\n'
                        'Status: ${resp.status}\n'
                        'Expires: ${resp.expiresAt}';
                  }),
            child: const Text('Request Approval'),
          ),
          const Divider(height: 32),

          // Approval actions
          Text('Approval Actions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _approvalIdCtrl,
            decoration: const InputDecoration(
              labelText: 'Approval Request ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _run('Check Status', () async {
                        final repo = getIt<DeviceRepository>();
                        final resp = await repo.checkApprovalStatus(
                          _approvalIdCtrl.text.trim(),
                        );
                        return 'Status: ${resp.status}\n'
                            'Expired: ${resp.isExpired}\n'
                            'Created: ${resp.createdAt}';
                      }),
                child: const Text('Check Status'),
              ),
              FilledButton(
                onPressed: _isLoading
                    ? null
                    : () => _run('Approve', () async {
                        final deviceService = getIt<DeviceService>();
                        final repo = getIt<DeviceRepository>();
                        final resp = await repo.approveRequest(
                          _approvalIdCtrl.text.trim(),
                          ApproveRequestDto(
                            approvingDeviceId: deviceService.deviceId,
                          ),
                        );
                        return 'Approved at: ${resp.approvedAt}';
                      }),
                child: const Text('Approve'),
              ),
              OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () => _run('Reject', () async {
                        final deviceService = getIt<DeviceService>();
                        final repo = getIt<DeviceRepository>();
                        final resp = await repo.rejectRequest(
                          _approvalIdCtrl.text.trim(),
                          RejectRequestDto(
                            rejectingDeviceId: deviceService.deviceId,
                          ),
                        );
                        return 'Rejected at: ${resp.rejectedAt}';
                      }),
                child: const Text('Reject'),
              ),
            ],
          ),
          const Divider(height: 32),

          // Device List / Delete
          Text('Device Management', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text('List Devices'),
            onPressed: _isLoading
                ? null
                : () => _run('List Devices', () async {
                    final repo = getIt<DeviceRepository>();
                    final devices = await repo.listDevices();
                    if (devices.isEmpty) return 'No devices found';
                    return devices
                        .map(
                          (d) =>
                              'ID: ${d.id}\n'
                              '  Trusted: ${d.isTrusted}\n'
                              '  Agent: ${d.userAgent}\n'
                              '  IP: ${d.ipAddress}\n'
                              '  First: ${d.firstSeenAt}\n'
                              '  Last: ${d.lastSeenAt}',
                        )
                        .join('\n\n');
                  }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _deviceIdCtrl,
            decoration: const InputDecoration(
              labelText: 'Device ID (UUID)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete Device'),
            onPressed: _isLoading
                ? null
                : () => _run('Delete Device', () async {
                    final id = _deviceIdCtrl.text.trim();
                    if (id.isEmpty) return 'Device ID is required';
                    final repo = getIt<DeviceRepository>();
                    await repo.deleteDevice(id);
                    return 'Device $id deleted';
                  }),
          ),
          const Divider(height: 32),

          // Result display
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_resultText != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _resultText!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
