import 'package:flutter_test/flutter_test.dart';
import 'package:username_generator/data/compatible_generator_data.dart';

void main() {
  group('Username Generator Core Logic & Compatibility Tests', () {
    test('Game Compatible Username Generator Logic Test', () {
      const name = 'Sai';
      
      // 1. Check variation generator outputs
      final variations = CompatibleGeneratorData.generateVariations(name);
      expect(variations, isNotEmpty);
      expect(variations, contains('亗Sai亗'));
      expect(variations, contains('乂Sai乂'));
      expect(variations, contains('RX丨Sai'));

      // 2. Check length rating rules
      // BGMI allows 14 chars. '亗Sai亗' has length 5 (safe)
      final bgmiRating = CompatibleGeneratorData.getRating('亗Sai亗', 'BGMI');
      expect(bgmiRating.stars, greaterThanOrEqualTo(4.0));
      expect(bgmiRating.isSafe, isTrue);

      // Free Fire has limit of 12 chars.
      // A name of 15 characters should fail (exceeds limit)
      final toolongRating = CompatibleGeneratorData.getRating('亗Sai亗VeryLongNameHere', 'Free Fire');
      expect(toolongRating.stars, equals(1.0));
      expect(toolongRating.isSafe, isFalse);
      expect(toolongRating.label, equals('Exceeds Limit'));

      // Free Fire has limited support for '〆' (reduced score)
      final ffRatingWithInvalidChar = CompatibleGeneratorData.getRating('Sai〆', 'Free Fire');
      expect(ffRatingWithInvalidChar.stars, lessThan(4.0)); // Should be 3.0 (medium compatibility)

      // 3. Check v4.0 interactive features data assets
      expect(CompatibleGeneratorData.bioSlogans, isNotEmpty);
      expect(CompatibleGeneratorData.signatureColors, isNotEmpty);
      expect(CompatibleGeneratorData.signatureColors.first['code'], equals('FFD700')); // Gold
      expect(CompatibleGeneratorData.rollerNames, contains('Shadow'));
    });

    test('Category-based Username Variation Filtering', () {
      const name = 'Gamer';

      final royalVars = CompatibleGeneratorData.generateVariations(name, category: 'Royal');
      expect(royalVars, contains('♛Gamer♛'));
      expect(royalVars, contains('★Gamer★'));

      final animeVars = CompatibleGeneratorData.generateVariations(name, category: 'Anime');
      expect(animeVars, contains('UchihaGamer'));
      expect(animeVars, contains('GamerSenpai'));

      final minimalVars = CompatibleGeneratorData.generateVariations(name, category: 'Minimal');
      expect(minimalVars, contains('Gamer•'));
      expect(minimalVars, contains('-Gamer-'));
    });

    test('Category-Aware AI Suggestions', () {
      const keyword = 'Dragon';

      final coolAI = CompatibleGeneratorData.generateAISuggestions(keyword, 'Cool');
      expect(coolAI, isNotEmpty);
      expect(coolAI.any((item) => item.contains('Dragon')), isTrue);

      final animeAI = CompatibleGeneratorData.generateAISuggestions(keyword, 'Anime');
      expect(animeAI, isNotEmpty);
      expect(animeAI.any((item) => item.contains('Senpai') || item.contains('Gamer') || item.contains('Shadow') || item.contains('Kun')), isTrue);
    });

    test('Grapheme Cluster Accurate Compatibility Ratings', () {
      // 12 graphemes: '亗亗亗123456789'
      const username = '亗亗亗123456789';
      final rating = CompatibleGeneratorData.getRating(username, 'Free Fire'); // Max 12
      expect(rating.isSafe, isTrue);
      expect(rating.label, isNot(equals('Exceeds Limit')));
    });
  });
}

