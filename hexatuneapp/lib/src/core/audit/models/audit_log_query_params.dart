// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Query parameters for filtering audit log results.
class AuditLogQueryParams {
  const AuditLogQueryParams({
    this.actorType,
    this.action,
    this.resourceType,
    this.outcome,
    this.severity,
    this.from,
    this.to,
  });

  final String? actorType;
  final String? action;
  final String? resourceType;
  final String? outcome;
  final String? severity;
  final String? from;
  final String? to;

  /// Converts to a query parameter map, including only non-null values.
  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (actorType != null) 'actorType': actorType,
      if (action != null) 'action': action,
      if (resourceType != null) 'resourceType': resourceType,
      if (outcome != null) 'outcome': outcome,
      if (severity != null) 'severity': severity,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    };
  }
}
