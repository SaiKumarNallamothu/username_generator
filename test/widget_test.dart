import 'package:flutter_test/flutter_test.dart';
import 'package:username_generator/data/compatible_generator_data.dart';

void main() {
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
}
