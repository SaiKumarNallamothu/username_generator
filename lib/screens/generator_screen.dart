import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/compatible_generator_data.dart';
import 'main_navigation.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inputController = TextEditingController(text: 'Gamer');
  final TextEditingController _aiKeywordController = TextEditingController(text: 'Fire');
  final TextEditingController _clanNameController = TextEditingController(text: 'Ghost');

  String _selectedAICategory = 'Cool';
  String _selectedClanTag = 'RX';
  String _selectedConnector = '丨';
  String _selectedGeneratorCategory = 'Pro';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _inputController.addListener(() {
      ref.read(textInputProvider.notifier).state = _inputController.text;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    _aiKeywordController.dispose();
    _clanNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textInput = ref.watch(textInputProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final favorites = ref.watch(favoritesProvider);
    final isPremium = ref.watch(premiumProvider);

    final platformInfo = CompatibleGeneratorData.platforms.firstWhere(
      (p) => p.name == selectedPlatform,
      orElse: () => CompatibleGeneratorData.platforms[0],
    );

    final currentLength = textInput.length;
    final isWithinLimit = currentLength <= platformInfo.maxChars;
    final checkerColor = isWithinLimit ? CustomTheme.successColor : CustomTheme.errorColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GAMING STUDIO',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: CustomTheme.accentColor,
          labelColor: CustomTheme.accentColor,
          unselectedLabelColor: CustomTheme.textSecondary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Generate'),
            Tab(text: 'AI Ideas'),
            Tab(text: 'Clan Tags'),
            Tab(text: 'Symbols'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Text Input Field (No standard appbar, glass feel)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                // Platform Selection chips
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: CompatibleGeneratorData.platforms.length,
                    itemBuilder: (context, index) {
                      final platform = CompatibleGeneratorData.platforms[index];
                      final isSelected = selectedPlatform == platform.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: InkWell(
                          onTap: () {
                            ref.read(selectedPlatformProvider.notifier).state = platform.name;
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSelected ? CustomTheme.goldGradient : null,
                              color: isSelected ? null : CustomTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                Text(platform.icon, style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 6),
                                Text(
                                  platform.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? CustomTheme.primaryColor : Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Main input
                TextField(
                  controller: _inputController,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.edit, color: CustomTheme.accentColor),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        '$currentLength / ${platformInfo.maxChars}',
                        style: GoogleFonts.poppins(color: checkerColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Real-time preview card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: CustomTheme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: CustomTheme.accentColor.withValues(alpha: 0.25), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: CustomTheme.accentColor.withValues(alpha: 0.05),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '亗$textInput亗',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.accentColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Live Platform Preview ($selectedPlatform)',
                        style: GoogleFonts.inter(fontSize: 11, color: CustomTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Generate variations list
                _buildGenerateTab(textInput, selectedPlatform, favorites),

                // 2. AI suggestions chat
                _buildAISuggestions(favorites, isPremium),

                // 3. Clan Tags Cockpit
                _buildClanTagsTab(favorites),

                // 4. Safe Symbols
                _buildSymbolsTab(),
              ],
            ),
          ),

          // Warnings footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            color: CustomTheme.secondaryColor,
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 14, color: CustomTheme.accentColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Esports Studio: Estimated compatibility ratings. Validation is not officially verified by game developers.',
                    style: GoogleFonts.inter(fontSize: 9, color: CustomTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 84), // Spacing for floating capsule navigation bar
        ],
      ),
    );
  }

  // --- 1. Generate tab ---
  Widget _buildGenerateTab(String textInput, String platform, List<String> favorites) {
    if (textInput.isEmpty) {
      return const Center(child: Text('Type a username above to load studio presets.'));
    }

    final variations = CompatibleGeneratorData.generateVariations(textInput);

    return Column(
      children: [
        // Style Categories scrolling chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['Pro', 'Esports', 'Royal', 'Minimal', 'Clan', 'Funny', 'Scary', 'Anime'].map((cat) {
              final isSelected = _selectedGeneratorCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                    cat,
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
                      _selectedGeneratorCategory = cat;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: variations.length,
            itemBuilder: (context, index) {
              final variant = variations[index];
              final rating = CompatibleGeneratorData.getRating(variant, platform);
              final isFav = favorites.contains(variant);

              // Calculate compatibility percentage representation
              final double percent = rating.stars / 5.0;
              final Color indicatorColor = rating.isSafe ? CustomTheme.successColor : CustomTheme.errorColor;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CustomTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            variant,
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : CustomTheme.textSecondary, size: 20),
                              onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(variant),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: CustomTheme.accentColor, size: 20),
                              onPressed: () => ClipboardHelper.copy(context, ref, variant),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Compatibility Indicator progress bar
                    Row(
                      children: [
                        Text(
                          'Compatibility',
                          style: GoogleFonts.inter(fontSize: 11, color: CustomTheme.textSecondary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percent,
                              color: indicatorColor,
                              backgroundColor: Colors.white10,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(percent * 100).toInt()}%',
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: indicatorColor),
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
    );
  }

  // --- 2. AI Suggestions tab ---
  Widget _buildAISuggestions(List<String> favorites, bool isPremium) {
    final suggestions = CompatibleGeneratorData.generateAISuggestions(_aiKeywordController.text);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chat prompt glass field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: CustomTheme.secondaryColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: CustomTheme.accentColor),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _aiKeywordController,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Enter AI prompt keywords...',
                      fillColor: Colors.transparent,
                      filled: false,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Categories dropdown
          DropdownButtonFormField<String>(
            value: _selectedAICategory,
            decoration: const InputDecoration(labelText: 'AI Mode Filter'),
            dropdownColor: CustomTheme.secondaryColor,
            items: ['Cool', 'Funny', 'Cute', 'Scary', 'Anime'].map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedAICategory = val);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: !isPremium && ['Scary', 'Anime'].contains(_selectedAICategory)
                ? Center(
                    child: Card(
                      color: CustomTheme.secondaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock, size: 48, color: CustomTheme.accentColor),
                            const SizedBox(height: 12),
                            const Text(
                              'Premium Required',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomTheme.accentColor),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Unlock Scary & Anime themed suggestions!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: CustomTheme.textSecondary),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(premiumProvider.notifier).togglePremium();
                              },
                              child: const Text('Get Premium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final name = suggestions[index];
                      final isFav = favorites.contains(name);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: CustomTheme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : CustomTheme.textSecondary),
                                  onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(name),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, color: CustomTheme.accentColor),
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
  }

  // --- 3. Clan Tags Tab ---
  Widget _buildClanTagsTab(List<String> favorites) {
    final generatedTag = '$_selectedClanTag$_selectedConnector${_clanNameController.text}';
    final isFav = favorites.contains(generatedTag);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomTheme.cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: CustomTheme.cyberCyan.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Column(
              children: [
                Text('CLAN PREVIEW', style: GoogleFonts.poppins(fontSize: 10, color: CustomTheme.textSecondary, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  generatedTag,
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: CustomTheme.cyberCyan),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Tag'),
                      onPressed: () => ClipboardHelper.copy(context, ref, generatedTag),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                      onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(generatedTag),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Esports Clan Tag Configuration', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            controller: _clanNameController,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Player Nickname'),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedClanTag,
                  decoration: const InputDecoration(labelText: 'Esports Prefix'),
                  dropdownColor: CustomTheme.secondaryColor,
                  items: ['RX', 'VLT', 'RGX', 'NXT', 'S8', '7H'].map((tag) {
                    return DropdownMenuItem(value: tag, child: Text(tag));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedClanTag = v);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedConnector,
                  decoration: const InputDecoration(labelText: 'Connector'),
                  dropdownColor: CustomTheme.secondaryColor,
                  items: ['丨', '•', '×', '〆', '-'].map((conn) {
                    return DropdownMenuItem(value: conn, child: Text(conn));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedConnector = v);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. Symbols Tab ---
  Widget _buildSymbolsTab() {
    final categories = CompatibleGeneratorData.symbolLibrary;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories.keys.elementAt(index);
        final symbols = categories[category]!;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: CustomTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: CustomTheme.cyberCyan, fontSize: 13),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: symbols.length,
                  itemBuilder: (context, i) {
                    final sym = symbols[i];
                    return InkWell(
                      onTap: () => ClipboardHelper.copy(context, ref, sym),
                      borderRadius: BorderRadius.circular(30), // Circular glows
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomTheme.secondaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: CustomTheme.accentColor.withValues(alpha: 0.15)),
                          boxShadow: [
                            BoxShadow(
                              color: CustomTheme.accentColor.withValues(alpha: 0.05),
                              blurRadius: 4,
                            )
                          ]
                        ),
                        child: Center(
                          child: Text(sym, style: const TextStyle(fontSize: 18, color: CustomTheme.accentColor)),
                        ),
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
}
