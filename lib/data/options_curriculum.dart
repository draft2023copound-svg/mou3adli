import '../models/evaluation_model.dart';

/// 🎨 OPTIONS SCOLAIRES TUNISIENNES
/// Langues vivantes (2ème, 3ème, Bac) + Arts (2ème, 3ème, Bac)

class OptionCurriculum {
  OptionCurriculum._();

  static const List<Map<String, dynamic>> _languageOptions = [
    {'id': 'allemand', 'nameFr': 'Allemand', 'nameAr': 'ألمانية', 'icon': 'language'},
    {'id': 'espagnol', 'nameFr': 'Espagnol', 'nameAr': 'إسبانية', 'icon': 'language'},
    {'id': 'italien', 'nameFr': 'Italien', 'nameAr': 'إيطالية', 'icon': 'language'},
  ];

  static const List<Map<String, dynamic>> _artOptions = [
    {'id': 'musique', 'nameFr': 'Musique', 'nameAr': 'موسيقى', 'icon': 'music_note'},
    {'id': 'arts_plastiques', 'nameFr': 'Arts Plastiques', 'nameAr': 'فنون تشكيلية', 'icon': 'palette'},
  ];

  /// Toutes les options disponibles
  static List<Map<String, dynamic>> getAllOptions() => [
        ..._languageOptions,
        ..._artOptions,
      ];

  /// Vérifie si un ID est une option valide
  static bool isValidOption(String? id) {
    if (id == null) return false;
    return getAllOptions().any((o) => o['id'] == id);
  }

  /// Récupère les infos d'une option par son ID
  static Map<String, dynamic>? getOptionById(String? id) {
    if (id == null) return null;
    try {
      return getAllOptions().firstWhere((o) => o['id'] == id);
    } catch (_) {
      return null;
    }
  }

  /// Évaluations standard pour toutes les options (DC + Oral + DS)
  static List<Evaluation> getOptionEvaluations() => [
        Evaluation(
          id: 'dc',
          nameFr: 'Contrôle continu',
          nameAr: 'فرض المراقبة',
          weight: 1,
        ),
        Evaluation(
          id: 'oral',
          nameFr: 'Oral',
          nameAr: 'الشفوي',
          weight: 1,
        ),
        Evaluation(
          id: 'ds',
          nameFr: 'Devoir de synthèse',
          nameAr: 'الفرض التأليفي',
          weight: 2,
        ),
      ];

  /// Vérifie si un niveau/section a des options
  /// Les options existent à partir de la 2ème année du lycée
  static bool hasOptions(String classLevel, String? stream) {
    if (classLevel == '1ere') return false;
    if (classLevel == '7eme' || classLevel == '8eme' || classLevel == '9eme') return false;
    // 2ème, 3ème, Bac
    return true;
  }
}