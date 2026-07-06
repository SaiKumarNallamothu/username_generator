import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import 'home_screen.dart';
import 'generator_screen.dart';
import 'collections_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    GeneratorScreen(),
    CollectionsScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      extendBody: true, // Allows content to flow behind floating capsule bar
      body: SafeArea(
        bottom: false, // flow all the way down
        child: IndexedStack(
          index: selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: CustomTheme.secondaryColor.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, ref, 0, Icons.home_outlined, Icons.home, selectedIndex),
                    _buildNavItem(context, ref, 1, Icons.auto_awesome_outlined, Icons.auto_awesome, selectedIndex),
                    _buildNavItem(context, ref, 2, Icons.apps_outlined, Icons.apps, selectedIndex),
                    _buildNavItem(context, ref, 3, Icons.favorite_outline, Icons.favorite, selectedIndex),
                    _buildNavItem(context, ref, 4, Icons.settings_outlined, Icons.settings, selectedIndex),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref,
    int index,
    IconData inactiveIcon,
    IconData activeIcon,
    int selectedIndex,
  ) {
    final isSelected = selectedIndex == index;
    final activeColor = index % 2 == 0 ? CustomTheme.accentColor : CustomTheme.cyberCyan;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(navigationIndexProvider.notifier).state = index;
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          size: 26,
          color: isSelected ? activeColor : CustomTheme.textSecondary,
        ),
      ),
    );
  }
}

class ClipboardHelper {
  static void copy(BuildContext context, WidgetRef ref, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ref.read(historyProvider.notifier).addHistory(text);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: CustomTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Copied: "$text"',
                style: const TextStyle(
                  color: CustomTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: CustomTheme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
