import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white10,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: CustomTheme.accentColor),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome, color: CustomTheme.accentColor),
              label: 'Generator',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps_outlined),
              activeIcon: Icon(Icons.apps, color: CustomTheme.accentColor),
              label: 'Collections',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite, color: CustomTheme.accentColor),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings, color: CustomTheme.accentColor),
              label: 'Settings',
            ),
          ],
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
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
