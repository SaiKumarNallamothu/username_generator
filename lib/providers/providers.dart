import 'package:flutter_riverpod/legacy.dart';
import '../services/storage_service.dart';

// Navigation state
final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Platform selection state (defaults to 'BGMI')
final selectedPlatformProvider = StateProvider<String>((ref) => 'BGMI');

// Active tab index for GeneratorScreen (defaults to 0)
final generatorTabProvider = StateProvider<int>((ref) => 0);

// User input state for font generators
final textInputProvider = StateProvider<String>((ref) => 'Gamer');

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Favorites notifier
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super(StorageService.getFavorites());

  void toggleFavorite(String name) {
    if (state.contains(name)) {
      StorageService.removeFavorite(name);
      state = state.where((item) => item != name).toList();
    } else {
      StorageService.saveFavorite(name);
      state = [name, ...state];
    }
  }

  void addFavorite(String name) {
    if (!state.contains(name)) {
      StorageService.saveFavorite(name);
      state = [name, ...state];
    }
  }

  void removeFavorite(String name) {
    StorageService.removeFavorite(name);
    state = state.where((item) => item != name).toList();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

// History notifier
class HistoryNotifier extends StateNotifier<List<String>> {
  HistoryNotifier() : super(StorageService.getHistory());

  void addHistory(String name) {
    StorageService.addHistory(name);
    // Refresh state from storage to keep it sync'd and ordered
    state = StorageService.getHistory();
  }

  void clearHistory() {
    StorageService.clearHistory();
    state = [];
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<String>>((ref) {
  return HistoryNotifier();
});

// Premium Status notifier
class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(StorageService.isPremium());

  void togglePremium() {
    final newValue = !state;
    StorageService.setPremium(newValue);
    state = newValue;
  }

  void setPremium(bool value) {
    StorageService.setPremium(value);
    state = value;
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});
