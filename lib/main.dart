import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'game/screens/blast_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = AppProvider();
  await provider.initialize();

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mou3adli',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            fontFamily: 'Inter',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1C3F7A),
              primary: const Color(0xFF1C3F7A),
              secondary: const Color(0xFFC5A059),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          home: provider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
          routes: {
            '/game': (context) => const BlastScreen(),
          },
        );
      },
    );
  }
}