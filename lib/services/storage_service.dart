import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/term_model.dart';

/// 💾 Service centralisé de persistance locale
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ─── UTILISATEUR ───
  static const String _userKey = 'mou3adli_user';
  static const String _termsKey = 'mou3adli_terms';
  static const String _isLoggedInKey = 'mou3adli_is_logged_in';
  static const String _gameBestScoreKey = 'mou3adli_game_best_score';

  Future<void> saveUser(User user) async {
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setBool(_isLoggedInKey, true);
  }

  User? getUser() {
    final json = _prefs?.getString(_userKey);
    if (json == null) return null;
    try {
      return User.fromJson(jsonDecode(json));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_termsKey);
    await _prefs?.setBool(_isLoggedInKey, false);
  }

  bool get isLoggedIn => _prefs?.getBool(_isLoggedInKey) ?? false;

  // ─── TRIMESTRES & NOTES ───
  Future<void> saveTerms(List<Term> terms) async {
    final list = terms.map((t) => t.toJson()).toList();
    await _prefs?.setString(_termsKey, jsonEncode(list));
  }

  List<Term>? getTerms() {
    final json = _prefs?.getString(_termsKey);
    if (json == null) return null;
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => Term.fromJson(e)).toList();
    } catch (_) {
      return null;
    }
  }

  // ─── JEU BLAST ───
  Future<void> saveGameBestScore(int score) async {
    await _prefs?.setInt(_gameBestScoreKey, score);
  }

  int getGameBestScore() => _prefs?.getInt(_gameBestScoreKey) ?? 0;
}