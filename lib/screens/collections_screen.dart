import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/username_templates.dart';
import 'main_navigation.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final collections = UsernameTemplates.collections;

    return Scaffold(
      appBar: AppBar(
        title: const Text('COLLECTIONS'),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: collections.keys.length,
        itemBuilder: (context, index) {
          final category = collections.keys.elementAt(index);
          final names = collections[category] ?? [];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: CustomTheme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white10),
            ),
            child: ExpansionTile(
              collapsedTextColor: Colors.white,
              textColor: CustomTheme.accentColor,
              iconColor: CustomTheme.accentColor,
              collapsedIconColor: CustomTheme.textSecondary,
              title: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                '${names.length} templates available',
                style: const TextStyle(color: CustomTheme.textSecondary, fontSize: 12),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: names.length,
                    itemBuilder: (context, i) {
                      final name = names[i];
                      final isFav = favorites.contains(name);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: CustomTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : CustomTheme.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(name),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, color: CustomTheme.accentColor, size: 20),
                                  onPressed: () => ClipboardHelper.copy(context, ref, name),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
