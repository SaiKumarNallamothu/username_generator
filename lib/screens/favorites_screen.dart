import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import 'main_navigation.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    
    // Filter locally
    final filteredFavs = favorites
        .where((name) => name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORITES'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 72, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    'No Favorites Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create and save your names from the Generator!',
                    style: TextStyle(color: Colors.white30, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(navigationIndexProvider.notifier).state = 1; // Generator tab
                    },
                    child: const Text('Start Generating'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Search within favorites
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _query = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search favorites...',
                      prefixIcon: const Icon(Icons.search, color: CustomTheme.accentColor),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: CustomTheme.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _query = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredFavs.length,
                      itemBuilder: (context, index) {
                        final name = filteredFavs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: CustomTheme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: CustomTheme.errorColor),
                                    onPressed: () => ref.read(favoritesProvider.notifier).removeFavorite(name),
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
                  ),
                ],
              ),
            ),
    );
  }
}
