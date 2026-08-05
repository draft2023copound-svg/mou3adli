import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/term_model.dart';
import '../models/evaluation_model.dart';
import '../models/subject_model.dart';
import '../data/tunisian_curriculum.dart';
import '../services/sendgrid_service.dart';
import '../services/storage_service.dart';

/// 🧠 Cerveau central de Mou3adli — Gère tout l'état de l'application
class AppProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  User? _user;
  List<Term> _terms = [];
  String _currentTermId = 't2';
  int _gameBestScore = 0;
  bool _isDarkMode = false;

  User? get user => _user;
  List<Term> get terms => _terms;
  String get currentTermId => _currentTermId;
  int get gameBestScore => _gameBestScore;
  bool get isDarkMode => _isDarkMode;

  Term? get currentTerm {
    try {
      return _terms.firstWhere((t) => t.id == _currentTermId);
    } catch (_) {
      return _terms.isNotEmpty ? _terms.first : null;
    }
  }

  double get currentGeneralAverage => currentTerm?.generalAverage ?? 0;

  bool get isLoggedIn => _user != null;

  /// 🚀 Initialisation au démarrage de l'app
  Future<void> initialize() async {
    await _storage.init();
    _user = _storage.getUser();
    _gameBestScore = _storage.getGameBestScore();
    _isDarkMode = _storage.getDarkMode();
    final savedTerms = _storage.getTerms();

    if (_user != null && savedTerms != null) {
      _terms = savedTerms;
    } else if (_user != null) {
      _terms = TunisianCurriculum.generateTerms(
        _user!.cycle,
        _user!.classLevel,
        _user!.stream,
        optionId: _user!.optionId,
      );
      await _storage.saveTerms(_terms);
    }

    notifyListeners();
  }

  /// 🌙 BASCULER LE MODE SOMBRE
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _storage.saveDarkMode(value);
    notifyListeners();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 🔑 CONNEXION AVEC EMAIL + PASSWORD
  Future<bool> login(String email, String password) async {
    final saved = _storage.getUser();
    if (saved != null && saved.email == email) {
      final hashedInput = _hashPassword(password);
      if (saved.passwordHash == hashedInput) {
        _user = saved;
        final savedTerms = _storage.getTerms();
        _terms = savedTerms ?? TunisianCurriculum.generateTerms(
          _user!.cycle,
          _user!.classLevel,
          _user!.stream,
          optionId: _user!.optionId,
        );
        await _storage.saveTerms(_terms);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  /// 🔐 CRÉER UN COMPTE AVEC PASSWORD
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String schoolName,
    required String cycle,
    required String classLevel,
    String? stream,
    String? optionId,
  }) async {
    _user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      passwordHash: _hashPassword(password),
      schoolName: schoolName,
      cycle: cycle,
      classLevel: classLevel,
      stream: stream,
      optionId: optionId,
      createdAt: DateTime.now(),
    );

    _terms = TunisianCurriculum.generateTerms(
      cycle,
      classLevel,
      stream,
      optionId: optionId,
    );

    await _storage.saveUser(_user!);
    await _storage.saveTerms(_terms);
    notifyListeners();
  }

  /// 📧 ENVOYER LIEN DE RÉINITIALISATION
  Future<bool> sendPasswordReset(String email) async {
    final saved = _storage.getUser();
    if (saved == null || saved.email != email) return false;

    final token = DateTime.now().millisecondsSinceEpoch.toString();
    final expiry = DateTime.now().add(const Duration(hours: 1));

    saved.resetToken = token;
    saved.resetTokenExpiry = expiry;
    await _storage.saveUser(saved);

    return await SendGridService.sendPasswordResetEmailSimple(
      toEmail: email,
      resetToken: token,
      userName: saved.fullName,
    );
  }

  /// 🔄 RÉINITIALISER LE MOT DE PASSE
  Future<bool> resetPassword(String token, String newPassword) async {
    final saved = _storage.getUser();
    if (saved == null) return false;
    if (saved.resetToken != token) return false;
    if (saved.resetTokenExpiry == null || DateTime.now().isAfter(saved.resetTokenExpiry!)) return false;

    saved.passwordHash = _hashPassword(newPassword);
    saved.resetToken = null;
    saved.resetTokenExpiry = null;
    await _storage.saveUser(saved);

    return true;
  }

  /// 🚪 DÉCONNEXION — Garde les données en mémoire, déconnecte juste la session
  Future<void> logout() async {
    // NE PAS appeler _storage.clearUser() — ça supprime tout !
    // On garde les données dans le stockage pour que l'élève puisse se reconnecter

    _user = null;           // Déconnecte la session active
    _terms = [];            // Vide la mémoire (mais pas le stockage)
    _currentTermId = 't2';  // Reset le trimestre courant
    notifyListeners();
  }

  /// 📝 METTRE À JOUR LE PROFIL
  Future<void> updateProfile({
    String? fullName,
    String? schoolName,
    String? photoUrl,
    String? classLevel,
    String? stream,
    String? optionId,
  }) async {
    if (_user == null) return;

    bool shouldRegenerateTerms = false;

    if (fullName != null) _user!.fullName = fullName;
    if (schoolName != null) _user!.schoolName = schoolName;
    if (photoUrl != null) _user!.photoUrl = photoUrl;

    if (classLevel != null && classLevel != _user!.classLevel) {
      _user!.classLevel = classLevel;
      shouldRegenerateTerms = true;
    }
    if (stream != null && stream != _user!.stream) {
      _user!.stream = stream;
      shouldRegenerateTerms = true;
    }
    if (optionId != null && optionId != _user!.optionId) {
      _user!.optionId = optionId;
      shouldRegenerateTerms = true;
    }

    await _storage.saveUser(_user!);

    if (shouldRegenerateTerms) {
      _terms = TunisianCurriculum.generateTerms(
        _user!.cycle,
        _user!.classLevel,
        _user!.stream,
        optionId: _user!.optionId,
      );
      await _storage.saveTerms(_terms);
    }

    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  // 📸 MISE À JOUR DE LA PHOTO DE PROFIL
  // ═══════════════════════════════════════════════════════════

  Future<bool> updateProfilePhoto(File imageFile) async {
    if (_user == null) return false;

    try {
      if (_user!.photoUrl != null && _user!.photoUrl!.isNotEmpty) {
        await _storage.deleteProfileImage(_user!.photoUrl);
      }

      final savedPath = await _storage.saveProfileImage(imageFile);
      if (savedPath == null) return false;

      _user!.photoUrl = savedPath;
      await _storage.saveUser(_user!);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur updateProfilePhoto: $e');
      return false;
    }
  }

  Future<bool> removeProfilePhoto() async {
    if (_user == null) return false;

    try {
      if (_user!.photoUrl != null && _user!.photoUrl!.isNotEmpty) {
        await _storage.deleteProfileImage(_user!.photoUrl);
      }

      _user!.photoUrl = null;
      await _storage.saveUser(_user!);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur removeProfilePhoto: $e');
      return false;
    }
  }

  /// 📊 CHANGER DE TRIMESTRE ACTIF
  void setCurrentTerm(String termId) {
    _currentTermId = termId;
    notifyListeners();
  }

  /// ✏️ SAUVEGARDER UNE NOTE
  Future<void> updateGrade(String termId, String subjectId, String evalId, double? score) async {
    final termIndex = _terms.indexWhere((t) => t.id == termId);
    if (termIndex == -1) return;

    final subjectIndex = _terms[termIndex].subjects.indexWhere((s) => s.id == subjectId);
    if (subjectIndex == -1) return;

    final evalIndex = _terms[termIndex].subjects[subjectIndex].evaluations.indexWhere((e) => e.id == evalId);
    if (evalIndex == -1) return;

    final oldSubject = _terms[termIndex].subjects[subjectIndex];
    final newEvals = List<Evaluation>.of(oldSubject.evaluations);
    newEvals[evalIndex] = newEvals[evalIndex].copyWith(score: score);

    final newSubject = oldSubject.copyWith(evaluations: newEvals);
    final newSubjects = List<Subject>.of(_terms[termIndex].subjects);
    newSubjects[subjectIndex] = newSubject;

    final newTerm = Term(
      id: _terms[termIndex].id,
      nameFr: _terms[termIndex].nameFr,
      nameAr: _terms[termIndex].nameAr,
      subjects: newSubjects,
      startDate: _terms[termIndex].startDate,
      endDate: _terms[termIndex].endDate,
      isActive: _terms[termIndex].isActive,
    );

    _terms[termIndex] = newTerm;
    await _storage.saveTerms(_terms);
    notifyListeners();
  }

  /// 🎮 SAUVEGARDER LE MEILLEUR SCORE DU JEU
  Future<void> updateGameBestScore(int score) async {
    if (score > _gameBestScore) {
      _gameBestScore = score;
      await _storage.saveGameBestScore(score);
      notifyListeners();
    }
  }

  /// 📈 MOYENNE ANNUELLE
  double get annualAverage {
    if (_terms.isEmpty) return 0;
    double total = 0;
    int count = 0;
    for (final t in _terms) {
      final avg = t.generalAverage;
      if (avg > 0) {
        total += avg;
        count++;
      }
    }
    if (count == 0) return 0;
    return total / count;
  }

  /// 🏆 CLASSEMENT DES MATIÈRES
  List<Map<String, dynamic>> get subjectRankings {
    final term = currentTerm;
    if (term == null) return [];

    final ranked = term.subjects
        .where((s) => s.average > 0)
        .toList()
      ..sort((a, b) => b.average.compareTo(a.average));

    return ranked.map((s) => {
      'id': s.id,
      'nameFr': s.nameFr,
      'nameAr': s.nameAr,
      'average': s.average,
      'coefficient': s.coefficient,
      'iconName': s.iconName,
    }).toList();
  }
}