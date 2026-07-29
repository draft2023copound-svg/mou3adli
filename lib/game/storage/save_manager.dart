import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';

class SaveManager {
  static final SaveManager _instance = SaveManager._internal();
  factory SaveManager() => _instance;
  SaveManager._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async => _prefs ??= await SharedPreferences.getInstance();

  SharedPreferences get _preferences {
    if (_prefs == null) throw StateError('SaveManager not initialized.');
    return _prefs!;
  }

  Future<bool> saveGame(GameState state) async {
    try {
      return await _preferences.setString(
        kStorageKeyGameState,
        jsonEncode(state.toJson()),
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveBestScore(int score) =>
      _preferences.setInt(kStorageKeyBestScore, score);

  Future<bool> saveCurrentScore(int score) =>
      _preferences.setInt(kStorageKeyScore, score);

  GameState? loadGame() {
    try {
      final jsonString = _preferences.getString(kStorageKeyGameState);
      if (jsonString == null) return null;
      return GameState.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return null;
    }
  }

  int loadBestScore() => _preferences.getInt(kStorageKeyBestScore) ?? 0;
  int loadCurrentScore() => _preferences.getInt(kStorageKeyScore) ?? 0;

  Future<bool> clearGameSave() => _preferences.remove(kStorageKeyGameState);

  Future<bool> clearAll() async {
    final keys = [
      kStorageKeyBoard,
      kStorageKeyScore,
      kStorageKeyBestScore,
      kStorageKeyPieces,
      kStorageKeyGameState,
    ];
    // CORRECTION : Ajout des accolades dans la boucle for
    for (final key in keys) {
      await _preferences.remove(key);
    }
    return true;
  }
}