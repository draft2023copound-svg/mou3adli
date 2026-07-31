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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mou3adli',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: AppTextStyles.fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.royalBlue,
          primary: AppColors.royalBlue,
          secondary: AppColors.matteGold,
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
      ),
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
  }
}