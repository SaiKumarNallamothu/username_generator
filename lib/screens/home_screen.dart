import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/username_templates.dart';
import '../data/fonts_data.dart';
import 'main_navigation.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final textInput = ref.watch(textInputProvider);
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(historyProvider);

    // Filter trending or default names based on search query
    final displayTrending = UsernameTemplates.trendingNames
        .where((name) => name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          // App Bar Title / Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WELCOME TO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: CustomTheme.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'UserName Generator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.accentColor,
                      shadows: [
                        Shadow(
                          color: CustomTheme.accentColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: CustomTheme.accentColor),
                onPressed: () => ref.read(navigationIndexProvider.notifier).state = 3, // Favorites screen
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (val) {
              ref.read(searchQueryProvider.notifier).state = val;
              if (val.isNotEmpty) {
                ref.read(textInputProvider.notifier).state = val;
              }
            },
            decoration: InputDecoration(
              hintText: 'Search or type name to generate fonts...',
              prefixIcon: const Icon(Icons.search, color: CustomTheme.accentColor),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: CustomTheme.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        ref.read(textInputProvider.notifier).state = 'Gamer';
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),

          // Category Selector (Quick access to Random Username categories)
          const Text(
            'Quick Categories',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: UsernameTemplates.randomCategories.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () {
                      // Navigate to generator tab, set type
                      ref.read(navigationIndexProvider.notifier).state = 1; // Generator tab
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: CustomTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),

          // Trending List (Filtered by search)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending Names',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => ref.read(navigationIndexProvider.notifier).state = 2, // Collections Screen
                child: const Text('View All', style: TextStyle(color: CustomTheme.accentColor)),
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayTrending.take(5).length,
            itemBuilder: (context, index) {
              final name = displayTrending[index];
              final isFav = favorites.contains(name);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CustomTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : CustomTheme.textSecondary,
                          ),
                          onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: CustomTheme.accentColor),
                          onPressed: () => ClipboardHelper.copy(context, ref, name),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          // Popular Fonts generator preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Fonts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => ref.read(navigationIndexProvider.notifier).state = 1, // Generator Screen
                child: const Text('Try More', style: TextStyle(color: CustomTheme.accentColor)),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CustomTheme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: FontsData.allFonts.take(4).map((font) {
                final transformed = font.transform(textInput.isEmpty ? 'Gamer' : textInput);
                final isFav = favorites.contains(transformed);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              font.name,
                              style: const TextStyle(color: CustomTheme.textSecondary, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transformed,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : CustomTheme.textSecondary,
                              size: 20,
                            ),
                            onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(transformed),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: CustomTheme.accentColor, size: 20),
                            onPressed: () => ClipboardHelper.copy(context, ref, transformed),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // History Section
          if (history.isNotEmpty) ...[
            const Text(
              'Recently Copied',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: history.take(10).length,
                itemBuilder: (context, index) {
                  final name = history[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      backgroundColor: CustomTheme.cardColor,
                      side: const BorderSide(color: Colors.white10),
                      label: Text(name, style: const TextStyle(fontSize: 12)),
                      onPressed: () => ClipboardHelper.copy(context, ref, name),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
