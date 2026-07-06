import 'package:flutter_test/flutter_test.dart';
import 'package:username_generator/data/fonts_data.dart';

void main() {
  test('Unicode Font Transformation Test', () {
    const input = 'Gamer';
    
    // Check gothic bold transformer
    final gothicBoldStyle = FontsData.allFonts.firstWhere((f) => f.identifier == 'gothic_bold');
    final transformedGothic = gothicBoldStyle.transform(input);
    expect(transformedGothic, contains('𝕲')); // 'G' in Gothic bold
    expect(transformedGothic, contains('𝖆')); // 'a' in Gothic bold

    // Check script elegant transformer
    final scriptStyle = FontsData.allFonts.firstWhere((f) => f.identifier == 'script_elegant');
    final transformedScript = scriptStyle.transform(input);
    expect(transformedScript, contains('𝒢')); // 'G' in Script elegant
    expect(transformedScript, contains('𝒶')); // 'a' in Script elegant

    // Check gothic light transformer
    final gothicLightStyle = FontsData.allFonts.firstWhere((f) => f.identifier == 'gothic_light');
    final transformedGothicLight = gothicLightStyle.transform(input);
    expect(transformedGothicLight, contains('𝔊')); // 'G' in Gothic Light
    expect(transformedGothicLight, contains('𝔞')); // 'a' in Gothic Light

    // Check circled letters
    final circledStyle = FontsData.allFonts.firstWhere((f) => f.identifier == 'circled_letters');
    final transformedCircled = circledStyle.transform(input);
    expect(transformedCircled, contains('Ⓖ')); // 'G' in circled letters
    expect(transformedCircled, contains('ⓐ')); // 'a' in circled letters

    // Check square letters
    final squareStyle = FontsData.allFonts.firstWhere((f) => f.identifier == 'square_letters');
    final transformedSquare = squareStyle.transform(input);
    expect(transformedSquare, contains('🄶')); // 'G' in square letters
    expect(transformedSquare, contains('🄰')); // 'a' in square letters

    // Check mirror
    final mirrorStyle = FontsData.allFonts.firstWhere((f) => f.identifier == 'mirror');
    final transformedMirror = mirrorStyle.transform(input);
    expect(transformedMirror, contains('ɿ')); // 'r' mirrored (first character in reversed)
    expect(transformedMirror, contains('ɘ')); // 'e' mirrored
    expect(transformedMirror, contains('m')); // 'm' mirrored
    expect(transformedMirror, contains('ɒ')); // 'a' mirrored
    expect(transformedMirror, contains('G')); // 'G' mirrored
  });
}
