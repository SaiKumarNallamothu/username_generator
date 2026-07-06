class PlatformInfo {
  final String name;
  final String icon;
  final int maxChars;

  const PlatformInfo({
    required this.name,
    required this.icon,
    required this.maxChars,
  });
}

class CompatibilityRating {
  final String label;
  final double stars; // 1.0 to 5.0
  final bool isSafe;

  const CompatibilityRating({
    required this.label,
    required this.stars,
    required this.isSafe,
  });
}

class CompatibleGeneratorData {
  static const List<PlatformInfo> platforms = [
    PlatformInfo(name: 'BGMI', icon: '🎮', maxChars: 14),
    PlatformInfo(name: 'PUBG', icon: '🎮', maxChars: 14),
    PlatformInfo(name: 'Free Fire', icon: '🔥', maxChars: 12),
    PlatformInfo(name: 'Call of Duty', icon: '🎯', maxChars: 14),
    PlatformInfo(name: 'Discord', icon: '💬', maxChars: 32),
    PlatformInfo(name: 'Instagram', icon: '📷', maxChars: 30),
  ];

  static const List<String> safeSymbols = [
    '亗', '乂', '々', 'メ', '•', '×', '★', '☆', '♛', '♕', '✿', '〆', '『', '』', '「', '」', '【', '】', '丨'
  ];

  // Specific symbols compatibility per platform
  // High compatibility (5 stars), Medium (3 stars), Limited (2 stars)
  static CompatibilityRating getRating(String username, String platform) {
    int length = username.length;
    final platformInfo = platforms.firstWhere((p) => p.name == platform, orElse: () => platforms[0]);

    if (length > platformInfo.maxChars) {
      return const CompatibilityRating(
        label: 'Exceeds Limit',
        stars: 1.0,
        isSafe: false,
      );
    }

    // Check specific symbols support
    double score = 5.0;
    
    // Free Fire has limited support for 〆 and 丨
    if (platform == 'Free Fire') {
      if (username.contains('〆') || username.contains('丨') || username.contains('『') || username.contains('』')) {
        score -= 2.0;
      }
    }

    // PUBG and BGMI don't support certain very exotic emoji characters but support 亗, 乂, 々, メ, 〆
    if ((platform == 'BGMI' || platform == 'PUBG') && (username.contains('✿') || username.contains('♛') || username.contains('♕'))) {
      score -= 1.0;
    }

    if (score >= 4.0) {
      return CompatibilityRating(
        label: 'High Compatibility',
        stars: score,
        isSafe: true,
      );
    } else if (score >= 3.0) {
      return CompatibilityRating(
        label: 'Medium Compatibility',
        stars: score,
        isSafe: true,
      );
    } else {
      return CompatibilityRating(
        label: 'Limited Compatibility',
        stars: score,
        isSafe: false,
      );
    }
  }

  // Categories templates for custom viewing (Collections screen)
  static Map<String, List<String>> getCategories(String name) {
    final base = name.isEmpty ? 'Sai' : name;
    return {
      'Pro Players': [
        '亗${base}亗',
        'メ$base',
        '々$base',
        '亗$base',
        '『${base}_OP』',
      ],
      'Esports': [
        'RX丨$base',
        'VLT丨$base',
        'NXT丨$base',
        'RGX丨$base',
        'SOUL丨$base',
      ],
      'Royal': [
        '♛${base}♛',
        '★$base★',
        '✿$base✿',
        '♕$base♕',
        '★${base}★',
      ],
      'Minimal': [
        '$base•',
        '•$base•',
        '-$base-',
        '$base|',
        '$base×',
      ],
      'Clan': [
        'RX丨$base',
        'S8丨$base',
        '7H丨$base',
        'TX丨$base',
        'GODL丨$base',
      ],
      'Funny': [
        'Noob$base',
        'Potato$base',
        'BotHunter',
        'Laggy$base',
        'Camper$base',
      ],
      'Scary': [
        'Dark$base',
        'Ghost$base',
        'Death$base',
        'Night$base',
        'Grim$base',
      ],
      'Anime': [
        'Uchiha$base',
        '${base}Senpai',
        'Shadow$base',
        'Hokage$base',
        'Gojo$base',
      ],
    };
  }

  // Programmatically generate 50-100 compatible combinations
  static List<String> generateVariations(String name) {
    if (name.isEmpty) return [];
    
    final List<String> decorators = [
      '亗{}亗', '乂{}乂', '『{}』', 'メ{}', '{}々', '★{}★', '♛{}♛', '✿{}✿', '{}•', '•{}•',
      '{}×', '×{}×', '〆{}', '{}〆', '々{}々', '【{}】', '「{}」', '★{}', '{}★', '✿{}',
      '亗{}', '乂{}', '『{}』', '『{}_OP』', '『{}_YT』', '『{}_Gaming』',
    ];

    final List<String> prefixes = [
      'RX丨', 'VLT丨', 'S8丨', 'RGX丨', 'NXT丨', '7H丨', 'SOUL丨', 'GODL丨', 'TX丨', 'VPR丨', 'BLZ丨', 'NV丨'
    ];

    List<String> list = [];

    // 1. Single decorators
    for (var d in decorators) {
      list.add(d.replaceFirst('{}', name));
    }

    // 2. Prefixes + Name
    for (var p in prefixes) {
      list.add('$p$name');
      // Mix prefix + Name + Suffix
      list.add('$p$name•');
      list.add('$p$name〆');
    }

    // 3. Double decorators mixes
    list.add('亗乂${name}乂亗');
    list.add('★亗${name}亗★');
    list.add('✿乂${name}乂✿');
    list.add('メ${name}々');
    list.add('亗${name}〆');
    list.add('乂${name}•');

    // 4. Case variants + Suffixes
    list.add('${name}々');
    list.add('${name}〆');
    list.add('•${name}•');
    list.add('×${name}×');

    return list.toSet().toList(); // Ensure unique
  }

  // Pre-defined static collections
  static const Map<String, List<String>> staticCollections = {
    'Pro Players': ['亗Sai亗', 'メSai', '々Sai', '亗Ghost亗', 'メShadow', '々Dragon'],
    'Esports': ['RX丨Sai', 'VLT丨Sai', 'NXT丨Sai', 'RGX丨Sai', 'SOUL丨Hunter'],
    'Royal': ['♛Sai♛', '★Sai★', '✿Sai✿', '♕Ghost♕', '★Legend★'],
    'Minimal': ['Sai•', '•Sai•', '-Sai-', 'Sai|', 'Ghost•', '•Ghost•'],
    'Clan': ['RX丨Sai', 'S8丨Sai', '7H丨Sai', 'TX丨Ghost', 'S8丨Dragon'],
    'Funny': ['NoobSai', 'PotatoSai', 'BotHunter', 'NoobPlayer', 'PotatoAim'],
    'Scary': ['DarkSai', 'GhostSai', 'DeathSai', 'NightSai', 'GrimReaper'],
    'Anime': ['UchihaSai', 'SaiSenpai', 'ShadowSai', 'NarutoGamer', 'GojoOP'],
  };

  // Safe symbol collections grouped for symbol library
  static const Map<String, List<String>> symbolLibrary = {
    'Gamer Brackets': ['『』', '「」', '【】'],
    'Crowns & Flags': ['亗', '♛', '♕'],
    'Esports Connectors': ['丨', '•', '×', '〆'],
    'Symbols': ['乂', '々', 'メ', '★', '☆', '✿', '-']
  };

  // AI suggestions naming prefix / suffix rules (Offline AI Generator)
  static const List<String> aiPrefixes = [
    'Fire', 'Dragon', 'Inferno', 'Shadow', 'Alpha', 'Ghost', 'Silent', 'Cyber', 'Neon', 'Viper'
  ];

  static const List<String> aiSuffixes = [
    'Sai', 'Dragon', 'Ghost', 'King', 'Hunter', 'Rush', 'Wolf', 'Viper', 'Ace', 'Storm'
  ];

  static List<String> generateAISuggestions(String keyword) {
    if (keyword.isEmpty) return [];
    List<String> list = [];

    // Prefix suggestions
    for (var prefix in aiPrefixes.take(4)) {
      list.add('$prefix$keyword');
    }
    // Suffix suggestions
    for (var suffix in aiSuffixes.take(4)) {
      list.add('$keyword$suffix');
    }
    
    // Programmatic mixes
    list.add('${keyword}Dragon');
    list.add('Fire$keyword');

    // Automatically decorate them
    List<String> decorated = [];
    final List<String> sampleDecs = ['亗{}亗', '乂{}乂', '『{}』', 'メ{}', '{}々', '★{}★'];
    for (int i = 0; i < list.length; i++) {
      String dec = sampleDecs[i % sampleDecs.length];
      decorated.add(dec.replaceFirst('{}', list[i]));
    }

    return decorated;
  }
}
