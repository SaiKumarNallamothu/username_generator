import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/compatible_generator_data.dart';
import '../services/ad_service.dart';
import 'main_navigation.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inputController = TextEditingController(text: 'Gamer');

  String _selectedGeneratorCategory = 'Pro';

  // --- Builder Tab State ---
  String _builderPrefix = 'None';
  String _builderClanTag = 'None';
  String _builderConnector = 'None';
  String _builderSuffix = 'None';

  // --- Roller Tab State ---
  String _rollerPrefix = '亗';
  String _rollerName = 'Shadow';
  String _rollerSuffix = '亗';
  bool _isRolling = false;
  Timer? _rollerTimer;

  void _rollName() {
    if (_isRolling) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _isRolling = true;
    });
    int count = 0;
    _rollerTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        _rollerPrefix = (CompatibleGeneratorData.rollerPrefixes.toList()..shuffle()).first;
        _rollerName = (CompatibleGeneratorData.rollerNames.toList()..shuffle()).first;
        _rollerSuffix = (CompatibleGeneratorData.rollerSuffixes.toList()..shuffle()).first;
      });
      count++;
      if (count >= 12) {
        timer.cancel();
        setState(() {
          _isRolling = false;
        });
        HapticFeedback.heavyImpact();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && mounted) {
        ref.read(generatorTabProvider.notifier).state = _tabController.index;
      }
    });
    _inputController.addListener(() {
      ref.read(textInputProvider.notifier).state = _inputController.text;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    _rollerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(generatorTabProvider);
    if (_tabController.index != activeTab && !_tabController.indexIsChanging) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_tabController.index != activeTab && mounted) {
          _tabController.animateTo(activeTab);
        }
      });
    }

    final textInput = ref.watch(textInputProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final favorites = ref.watch(favoritesProvider);

    final platformInfo = CompatibleGeneratorData.platforms.firstWhere(
      (p) => p.name == selectedPlatform,
      orElse: () => CompatibleGeneratorData.platforms[0],
    );

    final currentLength = textInput.length;
    final isWithinLimit = currentLength <= platformInfo.maxChars;
    final checkerColor = isWithinLimit ? CustomTheme.successColor : CustomTheme.errorColor;

    // Dynamically calculate the active name shown in the preview card
    final p = _builderPrefix == 'None' ? '' : _builderPrefix;
    final t = _builderClanTag == 'None' ? '' : _builderClanTag;
    final c = _builderConnector == 'None' ? '' : _builderConnector;
    final s = _builderSuffix == 'None' ? '' : _builderSuffix;
    final String activeDecoratedName = t.isNotEmpty ? '$p$t$c$textInput$s' : '$p$textInput$s';

    final rating = CompatibleGeneratorData.getRating(activeDecoratedName, selectedPlatform);
    final double percent = rating.stars / 5.0;
    final Color indicatorColor = rating.isSafe ? CustomTheme.successColor : CustomTheme.errorColor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'GAMING STUDIO',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: CustomTheme.accentColor,
          labelColor: CustomTheme.accentColor,
          unselectedLabelColor: CustomTheme.textSecondary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Presets'),
            Tab(text: 'Decorator'),
            Tab(text: 'Symbols'),
            Tab(text: 'Bios & Roller'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Text Input Field & Platform Selection
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

                // Main input text field
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
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                        activeDecoratedName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.accentColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Platform Preview ($selectedPlatform)',
                            style: GoogleFonts.inter(fontSize: 11, color: CustomTheme.textSecondary),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            rating.isSafe ? Icons.check_circle : Icons.warning_rounded,
                            size: 12,
                            color: indicatorColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(percent * 100).toInt()}% compatibility',
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: indicatorColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy Custom Name'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomTheme.accentColor,
                              foregroundColor: CustomTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              AdService.instance.showRewardedInterstitialAd(
                                onRewardEarned: () {
                                  ClipboardHelper.copy(context, ref, activeDecoratedName);
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(
                              favorites.contains(activeDecoratedName) ? Icons.favorite : Icons.favorite_border,
                              color: favorites.contains(activeDecoratedName) ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              ref.read(favoritesProvider.notifier).toggleFavorite(activeDecoratedName);
                            },
                          ),
                        ],
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
                // 1. Presets Tab
                _buildGenerateTab(textInput, selectedPlatform, favorites),

                // 2. Decorator Tab
                _buildDecoratorTab(),

                // 3. Symbols Tab
                _buildSymbolsTab(),

                // 4. Bios & Roller Tab
                _buildBiosAndRollerTab(textInput, selectedPlatform, favorites),
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
        ],
      ),
    );
  }

  // --- 1. Presets Tab ---
  Widget _buildGenerateTab(String textInput, String platform, List<String> favorites) {
    if (textInput.isEmpty) {
      return const Center(child: Text('Type a username above to load studio presets.'));
    }

    final variations = CompatibleGeneratorData.generateVariations(textInput, category: _selectedGeneratorCategory);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Style Categories scrolling chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SizedBox(
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
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final variant = variations[index];
                final rating = CompatibleGeneratorData.getRating(variant, platform);
                final isFav = favorites.contains(variant);

                // Calculate compatibility percentage representation
                final double percent = rating.stars / 5.0;
                final Color indicatorColor = rating.isSafe ? CustomTheme.successColor : CustomTheme.errorColor;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _inputController.text = variant;
                      _builderPrefix = 'None';
                      _builderClanTag = 'None';
                      _builderConnector = 'None';
                      _builderSuffix = 'None';
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
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
                            IconButton(
                              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : CustomTheme.textSecondary, size: 20),
                              onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(variant),
                            ),
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
                  ),
                );
              },
              childCount: variations.length,
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. AI Suggestions tab ---
  Widget _buildAISuggestions(List<String> favorites, bool isPremium) {
    final suggestions = CompatibleGeneratorData.generateAISuggestions(_aiKeywordController.text, _selectedAICategory);

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
            initialValue: _selectedAICategory,
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
                  initialValue: _selectedClanTag,
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
                  initialValue: _selectedConnector,
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

  // --- Builder Tab ---
  Widget _buildBuilderTab(String textInput, String platform, List<String> favorites) {
    final p = _builderPrefix == 'None' ? '' : _builderPrefix;
    final t = _builderClanTag == 'None' ? '' : _builderClanTag;
    final c = _builderConnector == 'None' ? '' : _builderConnector;
    final s = _builderSuffix == 'None' ? '' : _builderSuffix;

    final String builtName = t.isNotEmpty ? '$p$t$c$textInput$s' : '$p$textInput$s';
    final isFav = favorites.contains(builtName);
    final rating = CompatibleGeneratorData.getRating(builtName, platform);
    final double percent = rating.stars / 5.0;
    final Color indicatorColor = rating.isSafe ? CustomTheme.successColor : CustomTheme.errorColor;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 96.0),
      children: [
        Text(
          'MANUAL CONSTRUCTOR COMPONENTS',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: CustomTheme.cyberCyan, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),

        // Prefixes selector
        DropdownButtonFormField<String>(
          initialValue: _builderPrefix,
          decoration: const InputDecoration(labelText: 'Prefix Decorator'),
          dropdownColor: CustomTheme.secondaryColor,
          items: CompatibleGeneratorData.builderPrefixes.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
          onChanged: (v) => setState(() => _builderPrefix = v ?? 'None'),
        ),
        const SizedBox(height: 12),

        // Clan Tag selector
        DropdownButtonFormField<String>(
          initialValue: _builderClanTag,
          decoration: const InputDecoration(labelText: 'Clan Prefix Tag'),
          dropdownColor: CustomTheme.secondaryColor,
          items: CompatibleGeneratorData.builderClanTags.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
          onChanged: (v) => setState(() => _builderClanTag = v ?? 'None'),
        ),
        const SizedBox(height: 12),

        // Connector selector
        if (_builderClanTag != 'None') ...[
          DropdownButtonFormField<String>(
            initialValue: _builderConnector,
            decoration: const InputDecoration(labelText: 'Connector Symbol'),
            dropdownColor: CustomTheme.secondaryColor,
            items: CompatibleGeneratorData.builderConnectors.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (v) => setState(() => _builderConnector = v ?? 'None'),
          ),
          const SizedBox(height: 12),
        ],

        // Suffixes selector
        DropdownButtonFormField<String>(
          initialValue: _builderSuffix,
          decoration: const InputDecoration(labelText: 'Suffix Decorator'),
          dropdownColor: CustomTheme.secondaryColor,
          items: CompatibleGeneratorData.builderSuffixes.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
          onChanged: (v) => setState(() => _builderSuffix = v ?? 'None'),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            setState(() {
              _builderPrefix = 'None';
              _builderClanTag = 'None';
              _builderConnector = 'None';
              _builderSuffix = 'None';
            });
          },
          child: const Text('Reset Decorators'),
        ),
      ],
    );
  }

  // --- 3. Symbols Tab ---
  Widget _buildSymbolsTab() {
    final categories = CompatibleGeneratorData.symbolLibrary;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 96),
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
                      onTap: () => _addSymbol(sym),
                      borderRadius: BorderRadius.circular(30),
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

  // --- 4. Bios & Roller Tab ---
  Widget _buildBiosAndRollerTab(String textInput, String platform, List<String> favorites) {
    final String rolledName = '$_rollerPrefix$_rollerName$_rollerSuffix';

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 96.0),
      children: [
        // Roller Card
        Card(
          color: CustomTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'ESPORTS SLOT MACHINE',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: CustomTheme.cyberCyan, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                Text(
                  'Roll to discover tournament-ready names.',
                  style: GoogleFonts.inter(fontSize: 12, color: CustomTheme.textSecondary),
                ),
                const SizedBox(height: 20),

                // Slot machine reels view
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSlotReel(_rollerPrefix, CustomTheme.cyberCyan),
                    const SizedBox(width: 8),
                    _buildSlotReel(_rollerName, Colors.white),
                    const SizedBox(width: 8),
                    _buildSlotReel(_rollerSuffix, CustomTheme.cyberCyan),
                  ],
                ),
                const SizedBox(height: 20),

                // Roll action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme.accentColor,
                        foregroundColor: CustomTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: _isRolling ? null : _rollName,
                      child: _isRolling
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: CustomTheme.primaryColor, strokeWidth: 2),
                            )
                          : Text(
                              'ROLL NAME ⚡',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                    ),
                    if (!_isRolling) ...[
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                        label: const Text('Use in Workspace'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          setState(() {
                            _inputController.text = rolledName;
                            _builderPrefix = 'None';
                            _builderClanTag = 'None';
                            _builderConnector = 'None';
                            _builderSuffix = 'None';
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Fancy Bio Slogans
        Text(
          'FANCY BIO SIGNATURES',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: CustomTheme.cyberCyan, letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        ...CompatibleGeneratorData.bioSlogans.map((slogan) {
          final fancyBio = '꧁$slogan꧂';
          return InkWell(
            onTap: () {
              setState(() {
                _inputController.text = fancyBio;
                _builderPrefix = 'None';
                _builderClanTag = 'None';
                _builderConnector = 'None';
                _builderSuffix = 'None';
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: CustomTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fancyBio,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Icon(Icons.arrow_upward, color: CustomTheme.accentColor, size: 18),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),

        // Colored Profile Signatures
        Text(
          'COLORED PROFILE SIGNATURE CODES',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: CustomTheme.cyberCyan, letterSpacing: 1.5),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to load these color codes into your workspace, then copy them to paste in BGMI/Free Fire profile signature.',
          style: GoogleFonts.inter(fontSize: 11, color: CustomTheme.textSecondary),
        ),
        const SizedBox(height: 12),
        ...CompatibleGeneratorData.signatureColors.map((colorItem) {
          final code = '[${colorItem['code']}]亗 $textInput 亗';
          return InkWell(
            onTap: () {
              setState(() {
                _inputController.text = code;
                _builderPrefix = 'None';
                _builderClanTag = 'None';
                _builderConnector = 'None';
                _builderSuffix = 'None';
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: CustomTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          colorItem['name']!,
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          code,
                          style: const TextStyle(fontSize: 12, color: CustomTheme.textSecondary, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_upward, color: CustomTheme.accentColor, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSlotReel(String val, Color textColor) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: CustomTheme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CustomTheme.accentColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: CustomTheme.accentColor.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 60),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            val,
            key: ValueKey<String>(val),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _addSymbol(String sym) {
    final text = _inputController.text;
    final selection = _inputController.selection;
    String newText;
    int newCursorPosition;

    if (selection.start >= 0) {
      newText = text.replaceRange(selection.start, selection.end, sym);
      newCursorPosition = selection.start + sym.length;
    } else {
      newText = text + sym;
      newCursorPosition = newText.length;
    }

    _inputController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
