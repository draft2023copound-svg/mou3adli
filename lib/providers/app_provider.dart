import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/term_model.dart';
import '../data/tunisian_curriculum.dart';
import '../services/storage_service.dart';

/// 🧠 Cerveau central de Mou3adli — Gère tout l'état de l'application
class AppProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  User? _user;
  List<Term> _terms = [];
  String _currentTermId = 't2';
  int _gameBestScore = 0;

  User? get user => _user;
  List<Term> get terms => _terms;
  String get currentTermId => _currentTermId;
  int get gameBestScore => _gameBestScore;

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

  /// 🔐 CRÉER UN COMPTE
  Future<void> register({
    required String fullName,
    required String email,
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

  /// 🔑 CONNEXION
  Future<bool> login(String email) async {
    final saved = _storage.getUser();
    if (saved != null && saved.email == email) {
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
    return false;
  }

  /// 🚪 DÉCONNEXION
  Future<void> logout() async {
    await _storage.clearUser();
    _user = null;
    _terms = [];
    _currentTermId = 't2';
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

  /// 📈 MOYENNE ANNUELLE (moyenne des 3 trimestres)
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

  /// 🏆 CLASSEMENT DES MATIÈRES (meilleures → pires)
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