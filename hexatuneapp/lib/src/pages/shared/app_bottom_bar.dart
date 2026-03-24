// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

/// Bottom navigation bar for the main app shell.
///
/// Displays four icon buttons (two on each side) with a notched gap
/// in the center for the [AppCenterFab].
///
/// Usage:
/// ```dart
/// Scaffold(
///   bottomNavigationBar: const AppBottomBar(),
///   floatingActionButton: const AppCenterFab(),
///   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
/// )
/// ```
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key, this.onItemTapped});

  /// Called when one of the four navigation icons is tapped.
  /// The [index] ranges from 0 (leftmost) to 3 (rightmost).
  final ValueChanged<int>? onItemTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => onItemTapped?.call(0),
            color: colorScheme.onSurface,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => onItemTapped?.call(1),
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: 48),
          IconButton(
            icon: const Icon(Icons.library_music_outlined),
            onPressed: () => onItemTapped?.call(2),
            color: colorScheme.onSurface,
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => onItemTapped?.call(3),
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}

/// Center floating action button for the main bottom navigation.
///
/// Displays a large hexagonal icon and docks into the [AppBottomBar] notch.
class AppCenterFab extends StatelessWidget {
  const AppCenterFab({super.key, this.onPressed});

  /// Called when the FAB is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: onPressed ?? () {},
      child: const Icon(Icons.hexagon_outlined, size: 36),
    );
  }
}
