import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/games_provider.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/subject_list_screen.dart';
import 'screens/term_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INITIALISER LES NOTIFICATIONS
  final notificationService = NotificationService();
  await notificationService.initialize();

  final appProvider = AppProvider();
  final gamesProvider = GamesProvider();
  await appProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
        ChangeNotifierProvider.value(value: gamesProvider),
      ],
      child: const Mou3adliApp(),
    ),
  );
}

class Mou3adliApp extends StatelessWidget {
  const Mou3adliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isDark = provider.isDarkMode;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mou3adli',
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => Consumer<AppProvider>(
                  builder: (context, provider, _) {
                    return provider.isLoggedIn
                        ? const HomeScreen()
                        : const LoginScreen();
                  },
                ),
            '/home': (context) => const HomeScreen(),
            '/subjects': (context) => const SubjectListScreen(),
            '/terms': (context) => const TermSelectionScreen(),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1C3F7A),
        brightness: Brightness.light,
        primary: const Color(0xFF1C3F7A),
        secondary: const Color(0xFFC5A059),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1E293B)),
      ),
      // ✅ CORRIGÉ : CardTheme → CardThemeData
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1C3F7A);
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1C3F7A).withValues(alpha: 0.5);
          }
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1C3F7A),
        brightness: Brightness.dark,
        primary: const Color(0xFF3B82F6),
        secondary: const Color(0xFFC5A059),
        surface: const Color(0xFF1A1A1A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // ✅ CORRIGÉ : CardTheme → CardThemeData
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A1A),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF3B82F6);
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF3B82F6).withValues(alpha: 0.5);
          }
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),
    );
  }
}