import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/compatible_generator_data.dart';
import 'main_navigation.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late PageController _bannerPageController;
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  final List<Map<String, String>> _bannerItems = [
    {
      'title': '🔥 Trending Gamer Names',
      'subtitle': 'Explore what the top streamers and pros are using.',
      'gradient': 'gold'
    },
    {
      'title': '⭐ New Clan Tags',
      'subtitle': 'Create your unified team esports tag in seconds.',
      'gradient': 'cyan'
    },
    {
      'title': '🏆 Pro Collections',
      'subtitle': 'Explore tournament-compatible presets.',
      'gradient': 'goldCyan'
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController(initialPage: 0);
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerPageController.hasClients) {
        setState(() {
          _currentBannerIndex = (_currentBannerIndex + 1) % _bannerItems.length;
        });
        _bannerPageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerPageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 👋';
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(historyProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            
            // Top Section (Greeting + Avatar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready to create your next gaming identity?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: CustomTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                // Avatar representation
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: CustomTheme.goldCyanGradient,
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: CustomTheme.cyberCyan.withValues(alpha: 0.2),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.black, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Large glass search field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref.read(textInputProvider.notifier).state = val.isEmpty ? 'Gamer' : val;
                    },
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search usernames...',
                      prefixIcon: const Icon(Icons.search, color: CustomTheme.accentColor),
                      suffixIcon: const Icon(Icons.keyboard_voice_outlined, color: CustomTheme.textSecondary),
                      fillColor: CustomTheme.cardColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Platform Selector chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: CompatibleGeneratorData.platforms.length,
                itemBuilder: (context, index) {
                  final platform = CompatibleGeneratorData.platforms[index];
                  final isSelected = selectedPlatform == platform.name;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: AnimatedScale(
                      scale: isSelected ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: InkWell(
                        onTap: () {
                          ref.read(selectedPlatformProvider.notifier).state = platform.name;
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isSelected ? CustomTheme.goldGradient : null,
                            color: isSelected ? null : CustomTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? CustomTheme.accentColor : Colors.white10,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: CustomTheme.accentColor.withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Text(platform.icon, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 8),
                              Text(
                                platform.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? CustomTheme.primaryColor : Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Auto Scroll Banner
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _bannerPageController,
                itemCount: _bannerItems.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _bannerItems[index];
                  final grad = item['gradient'] == 'gold'
                      ? CustomTheme.goldGradient
                      : item['gradient'] == 'cyan'
                          ? CustomTheme.cyanGradient
                          : CustomTheme.goldCyanGradient;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: grad,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (item['gradient'] == 'gold' ? CustomTheme.accentColor : CustomTheme.cyberCyan)
                              .withValues(alpha: 0.1),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title']!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: CustomTheme.primaryColor.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Quick Action Grid (2 column)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildActionTile('Generate Username', Icons.auto_awesome, CustomTheme.goldGradient, () {
                  ref.read(navigationIndexProvider.notifier).state = 1;
                }),
                _buildActionTile('Clan Tags', Icons.group, CustomTheme.cyanGradient, () {
                  ref.read(navigationIndexProvider.notifier).state = 1;
                }),
                _buildActionTile('AI Generator', Icons.psychology, CustomTheme.goldCyanGradient, () {
                  ref.read(navigationIndexProvider.notifier).state = 1;
                }),
                _buildActionTile('Symbols', Icons.emoji_symbols, CustomTheme.goldGradient, () {
                  ref.read(navigationIndexProvider.notifier).state = 1;
                }),
                _buildActionTile('Collections', Icons.grid_view_rounded, CustomTheme.cyanGradient, () {
                  ref.read(navigationIndexProvider.notifier).state = 2;
                }),
                _buildActionTile('Favorites', Icons.favorite, CustomTheme.goldCyanGradient, () {
                  ref.read(navigationIndexProvider.notifier).state = 3;
                }),
              ],
            ),
            const SizedBox(height: 28),

            // Trending Gamer Names Horizontal list
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Names',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => ref.read(navigationIndexProvider.notifier).state = 2,
                  child: Text('View All', style: GoogleFonts.poppins(color: CustomTheme.accentColor)),
                )
              ],
            ),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: CompatibleGeneratorData.staticCollections['Pro Players']!.length,
                itemBuilder: (context, index) {
                  final name = CompatibleGeneratorData.staticCollections['Pro Players']![index];
                  final isFav = favorites.contains(name);

                  return Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text('★★★★★', style: TextStyle(color: CustomTheme.accentColor, fontSize: 12)),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Popular Categories (Circular Gaming Badges)
            Text(
              'Popular Categories',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildCategoryBadge('👑 Royal', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('⚔ Pro', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('🔥 Trending', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('😈 Dark', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('🌸 Cute', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('🎌 Anime', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('👥 Clan', () => ref.read(navigationIndexProvider.notifier).state = 2),
                  _buildCategoryBadge('💀 Horror', () => ref.read(navigationIndexProvider.notifier).state = 2),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recent timeline activity
            if (history.isNotEmpty) ...[
              Text(
                'Recent Activity',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Column(
                children: history.take(3).map((name) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomTheme.cyberCyan,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Copied: "$name"',
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                          ),
                        ),
                        Text(
                          'Just Now',
                          style: GoogleFonts.inter(fontSize: 11, color: CustomTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 100), // Spacing for floating capsule
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, LinearGradient gradient, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: CustomTheme.primaryColor),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomTheme.cardColor,
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  label.split(' ')[0], // Icon
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label.split(' ').sublist(1).join(' '), // Text
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
