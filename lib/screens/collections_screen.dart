import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/compatible_generator_data.dart';
import 'main_navigation.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final textInput = ref.watch(textInputProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    
    final categories = CompatibleGeneratorData.getCategories(textInput);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COLLECTIONS',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          // Glass status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: CustomTheme.secondaryColor,
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Style Pack Preview: "$textInput"',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: CustomTheme.textSecondary),
                ),
                Text(
                  'Platform: $selectedPlatform',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: CustomTheme.accentColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100), // Spacing for floating capsule
              itemCount: categories.keys.length,
              itemBuilder: (context, index) {
                final category = categories.keys.elementAt(index);
                final names = categories[category] ?? [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  color: CustomTheme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white10),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      collapsedTextColor: Colors.white,
                      textColor: CustomTheme.accentColor,
                      iconColor: CustomTheme.accentColor,
                      collapsedIconColor: CustomTheme.textSecondary,
                      title: Text(
                        category,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        '${names.length} custom variations available',
                        style: GoogleFonts.inter(color: CustomTheme.textSecondary, fontSize: 11),
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
                              final rating = CompatibleGeneratorData.getRating(name, selectedPlatform);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: CustomTheme.secondaryColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(
                                                rating.isSafe ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                                                size: 10,
                                                color: rating.isSafe ? CustomTheme.successColor : CustomTheme.errorColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${rating.stars.toInt()}/5★ compatibility',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: rating.isSafe ? CustomTheme.successColor : CustomTheme.errorColor,
                                                ),
                                              ),
                                            ],
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
                                            size: 18,
                                          ),
                                          onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(name),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy, color: CustomTheme.accentColor, size: 18),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
