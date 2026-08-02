import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
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

  // ─── CLÉS ───
  static const String _userKey = 'mou3adli_user';
  static const String _termsKey = 'mou3adli_terms';
  static const String _isLoggedInKey = 'mou3adli_is_logged_in';
  static const String _gameBestScoreKey = 'mou3adli_game_best_score';
  static const String _darkModeKey = 'mou3adli_dark_mode';

  // ─── UTILISATEUR ───
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

  // ═══════════════════════════════════════════════════════════
  // 🌙 MODE SOMBRE (NOUVEAU)
  // ═══════════════════════════════════════════════════════════

  Future<void> saveDarkMode(bool isDark) async {
    await _prefs?.setBool(_darkModeKey, isDark);
  }

  bool getDarkMode() => _prefs?.getBool(_darkModeKey) ?? false;

  // ═══════════════════════════════════════════════════════════
  // 📸 GESTION DES PHOTOS DE PROFIL
  // ═══════════════════════════════════════════════════════════

  Future<String?> saveProfileImage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory('${appDir.path}/profile_photos');
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = File('${profileDir.path}/$fileName');

      await imageFile.copy(savedFile.path);
      await _cleanupOldPhotos(profileDir, fileName);

      return savedFile.path;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur sauvegarde photo: $e');
      }
      return null;
    }
  }

  Future<void> deleteProfileImage(String? photoPath) async {
    if (photoPath == null || photoPath.isEmpty) return;
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur suppression photo: $e');
      }
    }
  }

  Future<void> _cleanupOldPhotos(Directory dir, String keepFileName) async {
    try {
      final files = await dir.list().toList();
      for (final file in files) {
        if (file is File && !file.path.endsWith(keepFileName)) {
          await file.delete();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur nettoyage photos: $e');
      }
    }
  }
}