import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:username_generator/services/storage_service.dart';

void main() {
  group('StorageService Unit Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      final tempDir = Directory.systemTemp.createTempSync('storage_test');
      await StorageService.init(tempDir.path);
    });

    test('Favorites persistence operations', () async {
      expect(StorageService.getFavorites(), isEmpty);

      await StorageService.saveFavorite('亗Gamer亗');
      expect(StorageService.getFavorites(), contains('亗Gamer亗'));

      await StorageService.removeFavorite('亗Gamer亗');
      expect(StorageService.getFavorites(), isNot(contains('亗Gamer亗')));
    });

    test('History persistence operations', () async {
      await StorageService.addHistory('ShadowOP');
      expect(StorageService.getHistory(), contains('ShadowOP'));

      await StorageService.clearHistory();
      expect(StorageService.getHistory(), isEmpty);
    });

    test('Premium status toggle', () async {
      expect(StorageService.isPremium(), isFalse);

      await StorageService.setPremium(true);
      expect(StorageService.isPremium(), isTrue);
    });
  });
}
