import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';
import '../data/fonts_data.dart';
import '../data/symbols_data.dart';
import '../data/username_templates.dart';
import 'main_navigation.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inputController = TextEditingController(text: 'Gamer');
  
  // AI Generator state
  final TextEditingController _aiKeywordController = TextEditingController(text: 'Fire');
  String _selectedAICategory = 'Cool';
  List<String> _aiSuggestions = [];

  // Clan Tag state
  String _selectedClanTag = 'RX';
  String _selectedConnector = '•';
  final TextEditingController _clanNameController = TextEditingController(text: 'Ghost');

  // Name Length Checker state
  final TextEditingController _checkerController = TextEditingController();
  int _maxLength = 14;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _inputController.addListener(() {
      ref.read(textInputProvider.notifier).state = _inputController.text;
    });
    _generateAISuggestions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    _aiKeywordController.dispose();
    _clanNameController.dispose();
    _checkerController.dispose();
    super.dispose();
  }

  void _generateAISuggestions() {
    setState(() {
      _aiSuggestions = UsernameTemplates.generateAISuggestions(
        _aiKeywordController.text,
        _selectedAICategory,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textInput = ref.watch(textInputProvider);
    final favorites = ref.watch(favoritesProvider);
    final isPremium = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GENERATOR'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: CustomTheme.accentColor,
          labelColor: CustomTheme.accentColor,
          unselectedLabelColor: CustomTheme.textSecondary,
          tabs: const [
            Tab(text: 'Stylish Fonts'),
            Tab(text: 'Decorations'),
            Tab(text: 'AI suggestions'),
            Tab(text: 'Clan Tags'),
            Tab(text: 'Symbol Library'),
            Tab(text: 'Invisible space'),
            Tab(text: 'Length Checker'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Stylish Fonts
          _buildFontsTab(textInput, favorites),

          // 2. Decorations
          _buildDecorationsTab(textInput, favorites),

          // 3. AI Suggestions
          _buildAITab(favorites, isPremium),

          // 4. Clan Tags
          _buildClanTagsTab(favorites),

          // 5. Symbol Library
          _buildSymbolsTab(),

          // 6. Invisible Character
          _buildInvisibleTab(),

          // 7. Length Checker
          _buildLengthCheckerTab(),
        ],
      ),
    );
  }

  // --- 1. Fonts Tab ---
  Widget _buildFontsTab(String textInput, List<String> favorites) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              hintText: 'Enter name here...',
              prefixIcon: Icon(Icons.edit, color: CustomTheme.accentColor),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: FontsData.allFonts.length,
              itemBuilder: (context, index) {
                final font = FontsData.allFonts[index];
                final transformed = font.transform(textInput.isEmpty ? 'Gamer' : textInput);
                final isFav = favorites.contains(transformed);

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(font.name, style: const TextStyle(color: CustomTheme.textSecondary, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(transformed, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : CustomTheme.textSecondary),
                            onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(transformed),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: CustomTheme.accentColor),
                            onPressed: () => ClipboardHelper.copy(context, ref, transformed),
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
    );
  }

  // --- 2. Decorations Tab ---
  Widget _buildDecorationsTab(String textInput, List<String> favorites) {
    final baseName = textInput.isEmpty ? 'Gamer' : textInput;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              hintText: 'Enter name here...',
              prefixIcon: Icon(Icons.edit, color: CustomTheme.accentColor),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: UsernameTemplates.decorators.length,
              itemBuilder: (context, index) {
                final decorated = UsernameTemplates.decorators[index].replaceFirst('{}', baseName);
                final isFav = favorites.contains(decorated);

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
                          decorated,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : CustomTheme.textSecondary),
                            onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(decorated),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: CustomTheme.accentColor),
                            onPressed: () => ClipboardHelper.copy(context, ref, decorated),
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
    );
  }

  // --- 3. AI Suggestions Tab ---
  Widget _buildAITab(List<String> favorites, bool isPremium) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Dynamic suggestions based on theme!',
            style: TextStyle(color: CustomTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _aiKeywordController,
            decoration: const InputDecoration(
              hintText: 'Enter keyword (e.g. Fire, Sai)',
              prefixIcon: Icon(Icons.psychology, color: CustomTheme.accentColor),
            ),
            onChanged: (v) => _generateAISuggestions(),
          ),
          const SizedBox(height: 16),
          // Categories dropdown
          DropdownButtonFormField<String>(
            value: _selectedAICategory,
            decoration: const InputDecoration(labelText: 'Theme Category'),
            dropdownColor: CustomTheme.secondaryColor,
            items: UsernameTemplates.aiPrefixes.keys.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedAICategory = val;
                });
                _generateAISuggestions();
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: !isPremium && ['Mythical', 'Fantasy', 'Scary', 'Sci-Fi'].contains(_selectedAICategory)
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
                              'Unlock Mythical, Fantasy, Scary & Sci-Fi suggestions!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: CustomTheme.textSecondary),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(premiumProvider.notifier).togglePremium();
                              },
                              child: const Text('Get Premium Now'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _aiSuggestions.length,
                    itemBuilder: (context, index) {
                      final name = _aiSuggestions[index];
                      final isFav = favorites.contains(name);
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
                            )
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

  // --- 4. Clan Tags Tab ---
  Widget _buildClanTagsTab(List<String> favorites) {
    final generatedTag = '$_selectedClanTag$_selectedConnector${_clanNameController.text}';
    final isFav = favorites.contains(generatedTag);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [CustomTheme.secondaryColor, CustomTheme.cardColor],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CustomTheme.accentColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('PREVIEW', style: TextStyle(fontSize: 11, color: CustomTheme.textSecondary, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(
                  generatedTag,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomTheme.accentColor),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy'),
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
          const SizedBox(height: 24),
          const Text('Configure Clan Name & Tag', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _clanNameController,
            decoration: const InputDecoration(labelText: 'Gamer Name'),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedClanTag,
                  decoration: const InputDecoration(labelText: 'Clan Tag'),
                  dropdownColor: CustomTheme.secondaryColor,
                  items: UsernameTemplates.clanTags.map((tag) {
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
                  items: UsernameTemplates.clanConnectors.map((conn) {
                    return DropdownMenuItem(value: conn, child: Text(conn));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedConnector = v);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- 5. Symbols Tab ---
  Widget _buildSymbolsTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: SymbolsData.categories.length,
      itemBuilder: (context, index) {
        final category = SymbolsData.categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: CustomTheme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.accentColor, fontSize: 15),
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
                  itemCount: category.symbols.length,
                  itemBuilder: (context, i) {
                    final sym = category.symbols[i];
                    return InkWell(
                      onTap: () => ClipboardHelper.copy(context, ref, sym),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Center(
                          child: Text(sym, style: const TextStyle(fontSize: 18)),
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

  // --- 6. Invisible Character Tab ---
  Widget _buildInvisibleTab() {
    const String invisibleChar = 'ㅤ'; // Unicode character HANGUL FILLER (U+3164)
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CustomTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                const Icon(Icons.blur_on, size: 48, color: CustomTheme.accentColor),
                const SizedBox(height: 12),
                const Text(
                  'Invisible Blank Space',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Copy this character to get a blank name or custom spacer in game profiles (BGMI, Free Fire, etc.)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CustomTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Invisible Character'),
                  onPressed: () => ClipboardHelper.copy(context, ref, invisibleChar),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('How to Use:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          const Text(
            '1. Tap the "Copy Invisible Character" button above.\n'
            '2. Open your target game or app (e.g., BGMI, Discord).\n'
            '3. Paste the character in the username field.\n'
            '4. It will show as blank/empty space where typical spaces are blocked.',
            style: TextStyle(color: CustomTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }

  // --- 7. Length Checker Tab ---
  Widget _buildLengthCheckerTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter a name to count its character length against limits.',
            style: TextStyle(color: CustomTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _checkerController,
            decoration: const InputDecoration(
              hintText: 'Type username...',
              prefixIcon: Icon(Icons.text_fields, color: CustomTheme.accentColor),
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: _maxLength,
            decoration: const InputDecoration(labelText: 'Limit Threshold'),
            dropdownColor: CustomTheme.secondaryColor,
            items: [10, 12, 14, 16, 20].map((limit) {
              return DropdownMenuItem(value: limit, child: Text('$limit Characters'));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _maxLength = val);
            },
          ),
          const SizedBox(height: 24),
          // Progress and feedback card
          Builder(
            builder: (context) {
              final len = _checkerController.text.length;
              final isUnder = len <= _maxLength;
              final color = isUnder ? CustomTheme.successColor : CustomTheme.errorColor;
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(isUnder ? Icons.check_circle : Icons.error, color: color, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUnder ? 'Supported Length' : 'Exceeded Limit',
                            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$len / $_maxLength Characters',
                            style: TextStyle(color: color.withValues(alpha: 0.8), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
