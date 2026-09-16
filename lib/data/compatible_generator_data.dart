import 'package:flutter/material.dart';
import 'username_templates.dart';

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
    int length = username.characters.length;
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
        '亗$base亗',
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
        '♛$base♛',
        '★$base★',
        '✿$base✿',
        '♕$base♕',
        '★$base★',
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

  // Programmatically generate 50-100 compatible combinations with category filtering support
  static List<String> generateVariations(String name, {String category = 'All'}) {
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

    if (category == 'All' || category == 'Pro') {
      for (var d in decorators) {
        list.add(d.replaceFirst('{}', name));
      }
      list.add('亗乂$name乂亗');
      list.add('★亗$name亗★');
      list.add('✿乂$name乂✿');
      list.add('メ$name々');
      list.add('亗$name〆');
      list.add('乂$name•');
    }

    if (category == 'All' || category == 'Esports' || category == 'Clan') {
      for (var p in prefixes) {
        list.add('$p$name');
        list.add('$p$name•');
        list.add('$p$name〆');
      }
    }

    if (category == 'Royal') {
      list.addAll(['♛$name♛', '★$name★', '✿$name✿', '♕$name♕', '★$name★', '👑$name👑', '★亗$name亗★']);
    }

    if (category == 'Minimal') {
      list.addAll(['$name•', '•$name•', '-$name-', '$name|', '$name×', '×$name×', '$name〆', '•$name']);
    }

    if (category == 'Funny') {
      list.addAll(['Noob$name', 'Potato$name', 'Bot$name', 'Laggy$name', 'Camper$name', 'Noob$name•', 'Potato$name〆', 'Behind$name']);
    }

    if (category == 'Scary') {
      list.addAll(['Dark$name', 'Ghost$name', 'Death$name', 'Night$name', 'Grim$name', 'Dark$name亗', 'Ghost$name乂', 'Death$name〆']);
    }

    if (category == 'Anime') {
      list.addAll(['Uchiha$name', '${name}Senpai', 'Shadow$name', 'Hokage$name', 'Gojo$name', 'Uchiha$name々', 'Otaku$name', '${name}Kun']);
    }

    // Default fallbacks if category produced few items
    if (list.length < 5) {
      list.add('$name々');
      list.add('$name〆');
      list.add('•$name•');
      list.add('×$name×');
    }

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
  static List<String> generateAISuggestions(String keyword, [String category = 'Cool']) {
    if (keyword.isEmpty) return [];
    return UsernameTemplates.generateAISuggestions(keyword, category);
  }

  // --- Builder Data ---
  static const List<String> builderPrefixes = ['None', '亗', '乂', '『', '★', '♛', '✿', '〆'];
  static const List<String> builderClanTags = ['None', 'RX', 'VLT', 'RGX', 'NXT', 'S8', '7H', 'SOUL', 'GODL'];
  static const List<String> builderConnectors = ['None', '丨', '•', '×', '〆', '-'];
  static const List<String> builderSuffixes = ['None', '亗', '乂', '々', 'メ', '★', '♛', '✿', '〆', '』'];

  // --- Bio Slogans & Color Signatures ---
  static const List<String> bioSlogans = [
    'Dream. Grind. Win.',
    'Only Headshots 🎯',
    'Lagging But Deadly ⚡',
    'Bush Camper Pro 🍃',
    'No Recoil King 👑',
    'Born to Rule ⚔️',
    'Eat. Sleep. Game. Repeat.',
    'Toxic Aimer 💀',
  ];

  static const List<Map<String, String>> signatureColors = [
    {'name': 'Neon Gold', 'code': 'FFD700'},
    {'name': 'Cyber Cyan', 'code': '00F2FE'},
    {'name': 'Electric Purple', 'code': '8B5CF6'},
    {'name': 'Neon Pink', 'code': 'FF007F'},
    {'name': 'Acid Green', 'code': '22C55E'},
    {'name': 'Fire Red', 'code': 'EF4444'},
  ];

  // --- Slot Roller Words ---
  static const List<String> rollerPrefixes = ['亗', '乂', '★', '♛', '✿', 'メ', '〆'];
  static const List<String> rollerNames = ['Shadow', 'Viper', 'Ghost', 'Dragon', 'Hunter', 'Rush', 'Wolf', 'Ace', 'Slayer', 'Phantom'];
  static const List<String> rollerSuffixes = ['亗', '乂', '々', 'メ', '★', '〆', '•'];
}
