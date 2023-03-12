import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super({}) {
    _loadState();
  }

  static const String favoritesKey = 'favorites';

  Future<void> add(int id) async {
    state = {...state, id};
    _saveState();
  }

  Future<void> toggle(int id) async {
    state.contains(id) ? remove(id) : add(id);
  }

  Future<void> remove(int id) async {
    state = state.where((i) => i != id).toSet();
    _saveState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = (prefs.getStringList(favoritesKey) ?? [])
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toSet();
    state = favorites;
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = state.map((i) => i.toString()).toList();
    prefs.setStringList(favoritesKey, favoritesList);
  }
}

final favoritesProvider =
    StateNotifierProvider.autoDispose<FavoritesNotifier, Set<int>>(
        (ref) => FavoritesNotifier());
