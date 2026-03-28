// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';

/// A standalone harmonizer widget with tabbed type selection, ambience/warning
/// area, and harmonize/stop controls inside a single rounded container.
class HarmonizerWidget extends StatelessWidget {
  const HarmonizerWidget({
    required this.selectedType,
    required this.harmonizerState,
    required this.headsetConnected,
    required this.hexagenConnected,
    required this.selectedAmbience,
    required this.ambienceConfigs,
    required this.isActive,
    required this.generating,
    required this.canHarmonize,
    required this.onTypeChanged,
    required this.onAmbienceChanged,
    required this.onHarmonize,
    required this.onStopGraceful,
    required this.onImmediateStart,
    required this.onImmediateEnd,
    super.key,
  });

  final GenerationType selectedType;
  final HarmonizerState harmonizerState;
  final bool headsetConnected;
  final bool hexagenConnected;
  final AmbienceConfig? selectedAmbience;
  final List<AmbienceConfig> ambienceConfigs;
  final bool isActive;
  final bool generating;
  final bool canHarmonize;
  final ValueChanged<GenerationType> onTypeChanged;
  final ValueChanged<AmbienceConfig?> onAmbienceChanged;
  final VoidCallback onHarmonize;
  final VoidCallback onStopGraceful;
  final VoidCallback onImmediateStart;
  final VoidCallback onImmediateEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Type tabs ---
          _TypeTabBar(
            selectedType: selectedType,
            isActive: isActive,
            onTypeChanged: onTypeChanged,
          ),

          // --- Top half: type-specific content ---
          _buildTypeContent(theme, l10n, colorScheme),

          Divider(height: 1, color: colorScheme.outlineVariant),

          // --- Bottom half: timer + harmonize/stop ---
          _buildControls(theme, l10n, colorScheme),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top-half: type-specific content (ambience / warnings / coming soon)
  // ---------------------------------------------------------------------------

  Widget _buildTypeContent(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _typeContentBody(theme, l10n, colorScheme),
    );
  }

  Widget _typeContentBody(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    // Photonic / Quantal — coming soon
    if (!selectedType.isActive) {
      return _buildInfoRow(
        theme,
        colorScheme,
        Icons.schedule,
        _typeLabel(selectedType, l10n),
        l10n.harmonizerComingSoon,
        isWarning: false,
      );
    }

    // Magnetic
    if (selectedType == GenerationType.magnetic) {
      if (!hexagenConnected) {
        return _buildInfoRow(
          theme,
          colorScheme,
          Icons.cable_outlined,
          l10n.harmonizerTypeMagnetic,
          l10n.harmonizerHexagenRequired,
          isWarning: true,
        );
      }
      return _buildTypeLabel(theme, l10n.harmonizerTypeMagnetic);
    }

    // Binaural — headset check
    if (selectedType == GenerationType.binaural && !headsetConnected) {
      return _buildInfoRow(
        theme,
        colorScheme,
        Icons.headphones_outlined,
        l10n.harmonizerTypeBinaural,
        l10n.harmonizerHeadsetRequired,
        isWarning: true,
      );
    }

    // Monaural or Binaural (headset connected) — show ambience selector
    final typeText = selectedType == GenerationType.binaural
        ? l10n.harmonizerTypeBinaural
        : l10n.harmonizerTypeMonaural;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(typeText, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildAmbienceRow(theme, l10n, colorScheme),
      ],
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String subtitle, {
    required bool isWarning,
  }) {
    final contentColor = isWarning
        ? colorScheme.error
        : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, color: contentColor, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: contentColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeLabel(ThemeData theme, String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: theme.textTheme.titleMedium),
    );
  }

  Widget _buildAmbienceRow(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: l10n.harmonizerSelectAmbience,
        isDense: true,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AmbienceConfig?>(
          value: selectedAmbience,
          isExpanded: true,
          isDense: true,
          items: [
            DropdownMenuItem<AmbienceConfig?>(
              value: null,
              child: Text(l10n.harmonizerNoAmbience),
            ),
            ...ambienceConfigs.map(
              (c) => DropdownMenuItem(value: c, child: Text(c.name)),
            ),
          ],
          onChanged: onAmbienceChanged,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom-half: Total Time | Harmonize/Stop | Remaining
  // ---------------------------------------------------------------------------

  Widget _buildControls(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final isHarmonizing =
        harmonizerState.status == HarmonizerStatus.harmonizing ||
        harmonizerState.status == HarmonizerStatus.stopping;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              // Left: Total Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.harmonizerTotalDuration,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isHarmonizing
                          ? _formatDuration(
                              harmonizerState.isFirstCycle
                                  ? harmonizerState.firstCycleDuration
                                  : harmonizerState.totalCycleDuration,
                            )
                          : '--:--',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              // Center: Harmonize / Stop button
              _buildCenterButton(theme, l10n, colorScheme, isHarmonizing),

              // Right: Remaining
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.harmonizerRemaining,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isHarmonizing
                          ? _formatDuration(harmonizerState.remainingInCycle)
                          : '--:--',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Error text
          if (harmonizerState.status == HarmonizerStatus.error &&
              harmonizerState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.harmonizerError(harmonizerState.errorMessage!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isHarmonizing,
  ) {
    const double size = 64;
    final isStopping = harmonizerState.status == HarmonizerStatus.stopping;

    if (generating || isStopping) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: size * 0.5,
            height: size * 0.5,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: isStopping ? colorScheme.error : null,
            ),
          ),
        ),
      );
    }

    if (isHarmonizing) {
      return GestureDetector(
        onLongPressStart: (_) => onImmediateStart(),
        onLongPressEnd: (_) => onImmediateEnd(),
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.error,
          ),
          child: IconButton(
            icon: Icon(
              Icons.stop_rounded,
              color: colorScheme.onError,
              size: 36,
            ),
            onPressed: onStopGraceful,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: canHarmonize
            ? colorScheme.primary
            : colorScheme.surfaceContainerHigh,
      ),
      child: IconButton(
        icon: Icon(
          Icons.join_inner_rounded,
          color: canHarmonize
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withAlpha(97),
          size: 36,
        ),
        onPressed: canHarmonize ? onHarmonize : null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _typeLabel(GenerationType type, AppLocalizations l10n) {
    return switch (type) {
      GenerationType.monaural => l10n.harmonizerTypeMonaural,
      GenerationType.binaural => l10n.harmonizerTypeBinaural,
      GenerationType.magnetic => l10n.harmonizerTypeMagnetic,
      GenerationType.photonic => l10n.harmonizerTypePhotonic,
      GenerationType.quantal => l10n.harmonizerTypeQuantal,
    };
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

// =============================================================================
// _TypeTabBar — five tabs at the top of the container
// =============================================================================

class _TypeTabBar extends StatelessWidget {
  const _TypeTabBar({
    required this.selectedType,
    required this.isActive,
    required this.onTypeChanged,
  });

  final GenerationType selectedType;
  final bool isActive;
  final ValueChanged<GenerationType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: GenerationType.values.map((type) {
          final isSelected = selectedType == type;
          return _buildTab(theme, colorScheme, l10n, type, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildTab(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    GenerationType type,
    bool isSelected,
  ) {
    final label = _shortLabel(type, l10n);
    final icon = _typeIcon(type);
    final canTap = !isActive && type.isActive;

    return Expanded(
      child: GestureDetector(
        onTap: canTap || (!isActive && !type.isActive)
            ? () => onTypeChanged(type)
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : null,
            border: isSelected
                ? Border(
                    bottom: BorderSide(color: colorScheme.primary, width: 2),
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? colorScheme.primary
                    : !type.isActive
                    ? colorScheme.onSurface.withAlpha(97)
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : !type.isActive
                      ? colorScheme.onSurface.withAlpha(97)
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(GenerationType type) {
    return switch (type) {
      GenerationType.monaural => Icons.speaker_outlined,
      GenerationType.binaural => Icons.headphones_outlined,
      GenerationType.magnetic => Icons.waves_outlined,
      GenerationType.photonic => Icons.lock_outline,
      GenerationType.quantal => Icons.lock_outline,
    };
  }

  String _shortLabel(GenerationType type, AppLocalizations l10n) {
    return switch (type) {
      GenerationType.monaural => l10n.harmonizerTypeMonaural,
      GenerationType.binaural => l10n.harmonizerTypeBinaural,
      GenerationType.magnetic => l10n.harmonizerTypeMagnetic,
      GenerationType.photonic => l10n.harmonizerTypePhotonic,
      GenerationType.quantal => l10n.harmonizerTypeQuantal,
    };
  }
}
