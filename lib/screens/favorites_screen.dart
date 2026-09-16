import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _selectedFolder = 'All';

  final List<String> _folders = ['All', 'Pro', 'Clan', 'Royal', 'Minimal', 'Esports', 'Anime', 'Funny'];

  bool _belongsToFolder(String name, String folder) {
    if (folder == 'All') return true;
    final lower = name.toLowerCase();
    
    switch (folder) {
      case 'Royal':
        return name.contains('♛') || name.contains('★') || name.contains('✿') || name.contains('♕') || name.contains('👑');
      case 'Clan':
      case 'Esports':
        return name.contains('丨') || name.contains('RX') || name.contains('VLT') || name.contains('S8') || name.contains('NXT') || name.contains('RGX') || name.contains('SOUL') || name.contains('GODL') || name.contains('TX');
      case 'Minimal':
        return name.contains('•') || name.contains('-') || name.contains('|') || name.contains('×');
      case 'Anime':
        return lower.contains('uchiha') || lower.contains('senpai') || lower.contains('shadow') || lower.contains('gojo') || lower.contains('naruto') || lower.contains('otaku') || lower.contains('kun');
      case 'Funny':
        return lower.contains('noob') || lower.contains('potato') || lower.contains('bot') || lower.contains('laggy') || lower.contains('camper');
      case 'Pro':
        return name.contains('亗') || name.contains('乂') || name.contains('々') || name.contains('メ') || name.contains('〆') || name.contains('『');
      default:
        return true;
    }
  }

  void _showFavoriteActions(BuildContext context, String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomTheme.secondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.copy, color: CustomTheme.cyberCyan),
                  title: Text('Copy Username', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    ClipboardHelper.copy(context, ref, name);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined, color: CustomTheme.accentColor),
                  title: Text('Share Username', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing coming soon!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: CustomTheme.errorColor),
                  title: Text('Remove from Favorites', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: CustomTheme.errorColor)),
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(favoritesProvider.notifier).removeFavorite(name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed "$name" from favorites'),
                        backgroundColor: CustomTheme.errorColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);

    // Filter by query + folder
    final filteredFavs = favorites.where((name) {
      final matchesQuery = name.toLowerCase().contains(_query.toLowerCase());
      final matchesFolder = _belongsToFolder(name, _selectedFolder);
      return matchesQuery && matchesFolder;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAVORITES',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Premium illustration concept
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: CustomTheme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Center(
                      child: Icon(Icons.favorite_border, size: 54, color: Colors.white12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Favorites Yet',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first legendary username.',
                    style: GoogleFonts.inter(color: CustomTheme.textSecondary, fontSize: 13),
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
                  
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _query = val;
                      });
                    },
                    style: GoogleFonts.inter(color: Colors.white),
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

                  // Folder list
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _folders.length,
                      itemBuilder: (context, index) {
                        final folder = _folders[index];
                        final isSelected = _selectedFolder == folder;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              folder,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isSelected ? CustomTheme.primaryColor : Colors.white,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: CustomTheme.accentColor,
                            backgroundColor: CustomTheme.secondaryColor,
                            onSelected: (val) {
                              setState(() {
                                _selectedFolder = folder;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Favorites List
                  Expanded(
                    child: filteredFavs.isEmpty
                        ? Center(
                            child: Text(
                              'No favorites match your filter.',
                              style: GoogleFonts.inter(color: CustomTheme.textSecondary),
                            ),
                          )
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: filteredFavs.length,
                            itemBuilder: (context, index) {
                              final name = filteredFavs[index];
                              return InkWell(
                                onLongPress: () => _showFavoriteActions(context, name),
                                onTap: () => _showFavoriteActions(context, name),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: CustomTheme.cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 5,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.more_horiz,
                                            color: CustomTheme.accentColor.withValues(alpha: 0.7),
                                            size: 20,
                                          ),
                                        ],
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
            ),
    );
  }
}
