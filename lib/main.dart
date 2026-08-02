import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/games_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/subject_list_screen.dart';
import 'screens/term_selection_screen.dart';
import 'calendar_new/calendar_main_screen.dart';
import 'game/screens/games_hub_screen.dart';
import 'game/screens/memory_screen.dart';
import 'game/screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            '/calendar': (context) => const CalendarMainScreen(),
            '/games': (context) => const GamesHubScreen(),
            '/memory': (context) => const MemoryScreen(),
            '/quiz': (context) => const QuizScreen(),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.royalBlue,
        brightness: Brightness.light,
        primary: AppColors.royalBlue,
        secondary: AppColors.matteGold,
        surface: Colors.white,
        background: AppColors.background,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.royalBlue;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.royalBlue.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.royalBlue,
        brightness: Brightness.dark,
        primary: AppColors.royalBlueLight,
        secondary: AppColors.matteGold,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        onSurface: Colors.white,
        onBackground: Colors.white,
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
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.royalBlueLight;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.royalBlueLight.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }
}