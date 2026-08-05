import 'package:intl/intl.dart';

class Utility {
  Utility._();

  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'maintenant';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}min';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}j';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}sem';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  static String getRoleLabel(String? role) {
    switch (role) {
      case 'prof':
        return 'Professeur';
      case 'eleve':
        return 'Élève';
      default:
        return 'Utilisateur';
    }
  }

  static String getRoleEmoji(String? role) {
    switch (role) {
      case 'prof':
        return '👨‍🏫';
      case 'eleve':
        return '🎓';
      default:
        return '👤';
    }
  }
}
