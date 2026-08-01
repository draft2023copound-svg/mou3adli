// Retirer: import 'package:flutter/material.dart';
// Ce fichier ne contient que des données pures, pas de widgets

import '../models/evaluation_model.dart';
import '../models/subject_model.dart';
import '../models/term_model.dart';

/// 🎓 BASE DE DONNÉES OFFICIELLE DU SYSTÈME SCOLAIRE TUNISIEN
/// Sources : Programmes officiels du Ministère de l'Éducation
/// Mise à jour : 2026-2027

class TunisianCurriculum {
  TunisianCurriculum._();

  // ───────────────────────────────────────────────
  // COEFFICIENTS MATIÈRES — COLLÈGE
  // ───────────────────────────────────────────────

  static const Map<String, double> _college7Classique = {
    'arabe': 4, 'francais': 4, 'anglais': 1.5, 'math': 3,
    'physique': 1, 'svt': 1, 'histoire': 1, 'geo': 1,
    'techno': 1, 'islamique': 1, 'civique': 1,
    'informatique': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _college7Pilote = {
    'arabe': 4, 'francais': 4, 'anglais': 2, 'math': 3,
    'physique': 1, 'svt': 1, 'histoire': 1, 'geo': 1,
    'techno': 1, 'islamique': 1, 'civique': 1,
    'informatique': 1.5, 'educ_physique': 1,
  };

  static const Map<String, double> _college8Classique = {
    'arabe': 4, 'francais': 4, 'anglais': 1.5, 'math': 3,
    'physique': 1, 'svt': 1, 'histoire': 1, 'geo': 1,
    'techno': 1, 'islamique': 1, 'civique': 1,
    'informatique': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _college8Pilote = {
    'arabe': 4, 'francais': 4, 'anglais': 2, 'math': 3,
    'physique': 1, 'svt': 1, 'histoire': 1, 'geo': 1,
    'techno': 1, 'islamique': 1, 'civique': 1,
    'informatique': 1.5, 'educ_physique': 1,
  };

  static const Map<String, double> _college9Classique = {
    'arabe': 4, 'francais': 4, 'anglais': 1.5, 'math': 3,
    'physique': 1, 'svt': 1, 'histoire': 1, 'geo': 1,
    'techno': 1, 'islamique': 1, 'civique': 1,
    'informatique': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _college9Pilote = {
    'arabe': 4, 'francais': 4, 'anglais': 2, 'math': 3,
    'physique': 1, 'svt': 1, 'histoire': 1, 'geo': 1,
    'techno': 1, 'islamique': 1, 'civique': 1,
    'informatique': 1.5, 'educ_physique': 1,
  };

  // ───────────────────────────────────────────────
  // COEFFICIENTS MATIÈRES — LYCÉE 1ÈRE (Tronc commun)
  // ───────────────────────────────────────────────

  static const Map<String, double> _lycee1ere = {
    'arabe': 3, 'francais': 2.5, 'anglais': 1.5,
    'histoire': 1.5, 'geo': 1.5, 'islamique': 1,
    'civique': 1, 'informatique': 1.5, 'math': 3,
    'physique': 2.5, 'svt': 1.5, 'techno': 1,
    'educ_physique': 1,
  };

  // ───────────────────────────────────────────────
  // COEFFICIENTS MATIÈRES — LYCÉE 2ÈME (Par filière)
  // ───────────────────────────────────────────────

  static const Map<String, double> _lycee2Sciences = {
    'arabe': 2, 'francais': 2, 'anglais': 2,
    'histoire': 1, 'geo': 1, 'islamique': 1, 'civique': 1,
    'math': 4, 'physique': 4, 'svt': 2, 'techno': 2,
    'educ_physique': 1,
  };

  static const Map<String, double> _lycee2Lettres = {
    'arabe': 4, 'francais': 4, 'anglais': 3,
    'histoire': 1.5, 'geo': 1.5, 'islamique': 1, 'civique': 1,
    'math': 1, 'svt': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee2Economie = {
    'arabe': 2, 'francais': 2, 'anglais': 2,
    'histoire': 1.5, 'geo': 1.5, 'islamique': 1, 'civique': 1,
    'economie': 3, 'gestion': 3, 'math': 2.5,
    'informatique': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee2TechInfo = {
    'arabe': 2, 'francais': 2, 'anglais': 2,
    'math': 3, 'physique': 3, 'informatique': 4,
    'techno': 4, 'histoire': 1, 'geo': 1,
    'islamique': 1, 'civique': 1, 'educ_physique': 1,
  };

  // ───────────────────────────────────────────────
  // COEFFICIENTS MATIÈRES — LYCÉE 3ÈME (Par filière)
  // ───────────────────────────────────────────────

  static const Map<String, double> _lycee3SciencesExp = {
    'arabe': 2, 'francais': 2, 'anglais': 2, 'philosophie': 2,
    'histoire': 1, 'geo': 1, 'islamique': 1,
    'math': 4, 'physique': 4, 'svt': 2,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee3Math = {
    'arabe': 2, 'francais': 2, 'anglais': 2, 'philosophie': 2,
    'histoire': 1, 'geo': 1, 'islamique': 1,
    'math': 5, 'physique': 4, 'svt': 1,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee3Lettres = {
    'arabe': 4, 'francais': 4, 'anglais': 3, 'philosophie': 3,
    'histoire': 1.5, 'geo': 1.5, 'islamique': 1,
    'math': 1, 'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee3Economie = {
    'arabe': 3, 'francais': 3, 'anglais': 3, 'philosophie': 3,
    'histoire': 1.5, 'geo': 1.5, 'islamique': 1,
    'economie': 3, 'gestion': 3, 'math': 2.5,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee3SciencesTech = {
    'arabe': 2, 'francais': 2, 'anglais': 2, 'philosophie': 2,
    'math': 4, 'physique': 4, 'techno': 5,
    'informatique': 2, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee3SciencesInfo = {
    'arabe': 2, 'francais': 2, 'anglais': 2, 'philosophie': 2,
    'math': 4, 'physique': 3, 'algorithmique': 5,
    'systemes_reseaux': 4, 'tic': 4,
    'optionnelle': 1, 'educ_physique': 1,
  };

  // ───────────────────────────────────────────────
  // COEFFICIENTS MATIÈRES — LYCÉE 4ÈME BAC (Par filière)
  // ───────────────────────────────────────────────

  static const Map<String, double> _lycee4SciencesExp = {
    'arabe': 3, 'francais': 3, 'anglais': 3, 'philosophie': 3,
    'math': 4, 'physique': 4, 'svt': 4,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee4Math = {
    'arabe': 3, 'francais': 3, 'anglais': 3, 'philosophie': 3,
    'histoire': 1, 'geo': 1, 'islamique': 1,
    'math': 5, 'physique': 5, 'svt': 1.5,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee4Lettres = {
    'arabe': 4, 'francais': 4, 'anglais': 3, 'philosophie': 3,
    'islamique': 1, 'histoire': 1.5, 'geo': 1.5,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee4Economie = {
    'arabe': 3, 'francais': 3, 'anglais': 3, 'philosophie': 3,
    'histoire': 1.5, 'geo': 1.5,
    'economie': 4, 'gestion': 4, 'math': 2.5,
    'informatique': 1, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee4SciencesTech = {
    'arabe': 2, 'francais': 2, 'anglais': 2, 'philosophie': 2,
    'math': 4, 'physique': 4, 'techno': 5,
    'informatique': 2, 'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee4SciencesInfo = {
    'arabe': 3, 'francais': 3, 'anglais': 3, 'philosophie': 3,
    'math': 4, 'physique': 3, 'algorithmique': 5,
    'systemes_reseaux': 4, 'tic': 4,
    'optionnelle': 1, 'educ_physique': 1,
  };

  static const Map<String, double> _lycee4Sport = {
    'arabe': 3, 'francais': 3, 'anglais': 3, 'philosophie': 3,
    'math': 3, 'physique': 3, 'biologie': 3,
    'informatique': 1, 'educ_physique': 4, 'specialite': 4,
  };

  // ───────────────────────────────────────────────
  // ÉVALUATIONS PAR MATIÈRE (Structure standard)
  // ───────────────────────────────────────────────

  static List<Evaluation> _evalsArabe() => [
    Evaluation(id: 'dc1_texte', nameFr: 'DC1 - Étude de texte', nameAr: 'فرض المراقبة 1 - دراسة النص', weight: 1),
    Evaluation(id: 'dc1_redac', nameFr: 'DC1 - Rédaction', nameAr: 'فرض المراقبة 1 - الإنشاء', weight: 1),
    Evaluation(id: 'oral', nameFr: 'Oral', nameAr: 'الشفوي', weight: 1),
    Evaluation(id: 'ds_redac', nameFr: 'DS - Rédaction', nameAr: 'الفرض التأليفي - الإنشاء', weight: 2),
    Evaluation(id: 'ds_texte', nameFr: 'DS - Étude de texte', nameAr: 'الفرض التأليفي - دراسة النص', weight: 2),
  ];

  static List<Evaluation> _evalsLangue() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'dc2', nameFr: 'Contrôle continu n°2', nameAr: 'فرض المراقبة عدد 2', weight: 1),
    Evaluation(id: 'oral', nameFr: 'Oral', nameAr: 'الشفوي', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsMath() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'dc2', nameFr: 'Contrôle continu n°2', nameAr: 'فرض المراقبة عدد 2', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsPhysique() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsSVT() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
    Evaluation(id: 'tp', nameFr: 'TP / Pratique', nameAr: 'الأشغال التطبيقية', weight: 1),
  ];

  static List<Evaluation> _evalsStandard3() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
    Evaluation(id: 'oral', nameFr: 'Oral / Participation', nameAr: 'الشفوي', weight: 1),
  ];

  static List<Evaluation> _evalsInfo() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsEducPhys() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu', nameAr: 'فرض المراقبة', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsArts() => [
    Evaluation(id: 'dc', nameFr: 'Contrôle continu', nameAr: 'فرض المراقبة', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsMusique() => [
    Evaluation(id: 'dc', nameFr: 'Contrôle continu', nameAr: 'فرض المراقبة', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
    Evaluation(id: 'oral', nameFr: 'Oral / Chant', nameAr: 'الشفوي', weight: 1),
  ];

  static List<Evaluation> _evalsPhilosophie() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'dc2', nameFr: 'Contrôle continu n°2', nameAr: 'فرض المراقبة عدد 2', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsEconomie() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'dc2', nameFr: 'Contrôle continu n°2', nameAr: 'فرض المراقبة عدد 2', weight: 1),
    Evaluation(id: 'ds', nameFr: 'Devoir de synthèse', nameAr: 'الفرض التأليفي', weight: 2),
  ];

  static List<Evaluation> _evalsAlgo() => [
    Evaluation(id: 'dc1', nameFr: 'Contrôle continu n°1', nameAr: 'فرض المراقبة عدد 1', weight: 1),
    Evaluation(id: 'dc2', nameFr: 'Contrôle continu n°2', nameAr: 'فرض المراقبة عدد 2', weight: 1),
    Evaluation(id: 'tp', nameFr: 'TP / Pratique', nameAr: 'الأشغال التطبيقية', weight: 2),
  ];

  // ───────────────────────────────────────────────
  // ICONS
  // ───────────────────────────────────────────────

  static const Map<String, String> _iconMap = {
    'arabe': 'menu_book',
    'francais': 'translate',
    'anglais': 'language',
    'math': 'calculate',
    'physique': 'science',
    'svt': 'eco',
    'histoire': 'history',
    'geo': 'public',
    'techno': 'settings',
    'islamique': 'mosque',
    'civique': 'account_balance',
    'informatique': 'computer',
    'educ_physique': 'sports',
    'philosophie': 'psychology',
    'economie': 'trending_up',
    'gestion': 'business',
    'algorithmique': 'code',
    'systemes_reseaux': 'router',
    'tic': 'devices',
    'optionnelle': 'school',
    'specialite': 'fitness_center',
    'biologie': 'biotech',
  };

  // ───────────────────────────────────────────────
  // BUILDERS
  // ───────────────────────────────────────────────

  static Map<String, double> _getSubjectCoeffs(String cycle, String classLevel, String? stream) {
    if (cycle == 'college') {
      final isPilote = stream == 'pilote';
      if (classLevel == '7eme') return isPilote ? _college7Pilote : _college7Classique;
      if (classLevel == '8eme') return isPilote ? _college8Pilote : _college8Classique;
      if (classLevel == '9eme') return isPilote ? _college9Pilote : _college9Classique;
    } else {
      if (classLevel == '1ere') return _lycee1ere;
      if (classLevel == '2eme') {
        return switch (stream) {
          'sciences' => _lycee2Sciences,
          'lettres' => _lycee2Lettres,
          'economie' => _lycee2Economie,
          'tech_info' => _lycee2TechInfo,
          _ => _lycee2Sciences,
        };
      }
      if (classLevel == '3eme') {
        return switch (stream) {
          'sciences_exp' => _lycee3SciencesExp,
          'math' => _lycee3Math,
          'lettres' => _lycee3Lettres,
          'economie' => _lycee3Economie,
          'sciences_tech' => _lycee3SciencesTech,
          'sciences_info' => _lycee3SciencesInfo,
          _ => _lycee3SciencesExp,
        };
      }
      if (classLevel == '4eme') {
        return switch (stream) {
          'sciences_exp' => _lycee4SciencesExp,
          'math' => _lycee4Math,
          'lettres' => _lycee4Lettres,
          'economie' => _lycee4Economie,
          'sciences_tech' => _lycee4SciencesTech,
          'sciences_info' => _lycee4SciencesInfo,
          'sport' => _lycee4Sport,
          _ => _lycee4SciencesExp,
        };
      }
    }
    return _college9Classique;
  }

  static List<Evaluation> _getEvaluations(String subjectId) {
    return switch (subjectId) {
      'arabe' => _evalsArabe(),
      'francais' || 'anglais' => _evalsLangue(),
      'math' => _evalsMath(),
      'physique' || 'biologie' => _evalsPhysique(),
      'svt' => _evalsSVT(),
      'informatique' || 'techno' => _evalsInfo(),
      'educ_physique' || 'specialite' => _evalsEducPhys(),
      'musique' => _evalsMusique(),
      'theatre' || 'arts' => _evalsArts(),
      'philosophie' => _evalsPhilosophie(),
      'economie' || 'gestion' => _evalsEconomie(),
      'algorithmique' || 'systemes_reseaux' || 'tic' => _evalsAlgo(),
      _ => _evalsStandard3(),
    };
  }

  static String _getIcon(String subjectId) => _iconMap[subjectId] ?? 'school';

  static String _getNameFr(String subjectId) {
    final map = {
      'arabe': 'Arabe', 'francais': 'Français', 'anglais': 'Anglais',
      'math': 'Mathématiques', 'physique': 'Sciences Physiques',
      'svt': 'Sciences Naturelles', 'histoire': 'Histoire',
      'geo': 'Géographie', 'techno': 'Technologie',
      'islamique': 'Éducation Islamique', 'civique': 'Éducation Civique',
      'informatique': 'Informatique', 'educ_physique': 'Éducation Physique',
      'philosophie': 'Philosophie', 'economie': 'Économie',
      'gestion': 'Gestion', 'algorithmique': 'Algorithmique',
      'systemes_reseaux': 'Systèmes & Réseaux', 'tic': 'TIC',
      'optionnelle': 'Matière optionnelle', 'specialite': 'Spécialité',
      'biologie': 'Biologie', 'theatre': 'Théâtre', 'musique': 'Musique',
      'arts': 'Arts Plastiques',
    };
    return map[subjectId] ?? subjectId;
  }

  static String _getNameAr(String subjectId) {
    final map = {
      'arabe': 'عربية', 'francais': 'فرنسية', 'anglais': 'إنجليزية',
      'math': 'رياضيات', 'physique': 'فيزياء',
      'svt': 'علوم الحياة والأرض', 'histoire': 'تاريخ',
      'geo': 'جغرافيا', 'techno': 'تكنولوجيا',
      'islamique': 'تربية إسلامية', 'civique': 'تربية مدنية',
      'informatique': 'إعلامية', 'educ_physique': 'تربية بدنية',
      'philosophie': 'فلسفة', 'economie': 'اقتصاد',
      'gestion': 'تصرف', 'algorithmique': 'خوارزميات',
      'systemes_reseaux': 'أنظمة وشبكات', 'tic': 'تقنيات الإعلام والاتصال',
      'optionnelle': 'اختيارية', 'specialite': 'تخصص',
      'biologie': 'أحياء', 'theatre': 'مسرح', 'musique': 'موسيقى',
      'arts': 'فنون تشكيلية',
    };
    return map[subjectId] ?? subjectId;
  }

  /// 🎯 GÉNÈRE LES 3 TRIMESTRES pour un élève donné
  static List<Term> generateTerms(String cycle, String classLevel, String? stream) {
    final coeffs = _getSubjectCoeffs(cycle, classLevel, stream);
    final subjects = coeffs.entries.map((e) {
      final id = e.key;
      return Subject(
        id: id,
        nameFr: _getNameFr(id),
        nameAr: _getNameAr(id),
        coefficient: e.value,
        evaluations: _getEvaluations(id),
        iconName: _getIcon(id),
      );
    }).toList();

    return [
      Term(
        id: 't1',
        nameFr: 'Trimestre 1',
        nameAr: 'الثلاثي الأول',
        subjects: subjects.map((s) => s.copyWith(evaluations: s.evaluations.map((e) => e.copyWith()).toList())).toList(),
        startDate: DateTime(2026, 9, 15),
        endDate: DateTime(2026, 12, 20),
      ),
      Term(
        id: 't2',
        nameFr: 'Trimestre 2',
        nameAr: 'الثلاثي الثاني',
        subjects: subjects.map((s) => s.copyWith(evaluations: s.evaluations.map((e) => e.copyWith()).toList())).toList(),
        startDate: DateTime(2027, 1, 8),
        endDate: DateTime(2027, 3, 20),
        isActive: true,
      ),
      Term(
        id: 't3',
        nameFr: 'Trimestre 3',
        nameAr: 'الثلاثي الثالث',
        subjects: subjects.map((s) => s.copyWith(evaluations: s.evaluations.map((e) => e.copyWith()).toList())).toList(),
        startDate: DateTime(2027, 4, 5),
        endDate: DateTime(2027, 6, 30),
      ),
    ];
  }

  /// 📋 Renvoie la liste des filières disponibles pour une année du lycée
  static List<Map<String, String>> getStreams(String classLevel) {
    if (classLevel == '2eme') {
      return [
        {'id': 'sciences', 'name': 'Sciences'},
        {'id': 'lettres', 'name': 'Lettres'},
        {'id': 'economie', 'name': 'Économie & Services'},
        {'id': 'tech_info', 'name': 'Technologie Info'},
      ];
    }
    if (classLevel == '3eme' || classLevel == '4eme') {
      return [
        {'id': 'sciences_exp', 'name': 'Sciences Expérimentales'},
        {'id': 'math', 'name': 'Mathématiques'},
        {'id': 'lettres', 'name': 'Lettres'},
        {'id': 'economie', 'name': 'Économie & Gestion'},
        {'id': 'sciences_tech', 'name': 'Sciences Techniques'},
        {'id': 'sciences_info', 'name': 'Sciences de l\'Info'},
        if (classLevel == '4eme') {'id': 'sport', 'name': 'Sport'},
      ];
    }
    return [];
  }
}