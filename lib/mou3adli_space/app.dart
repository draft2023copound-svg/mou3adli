import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/light_theme.dart';
import 'theme/dark_theme.dart';
import 'modules/home/views/home_view.dart';

class Mou3adliSpaceApp extends StatelessWidget {
  const Mou3adliSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mou3adli Space',
      debugShowCheckedModeBanner: false,
      
      // ✅ Royal Design System Themes
      theme: buildRoyalLightTheme(),
      darkTheme: buildRoyalDarkTheme(),
      themeMode: ThemeMode.system, // Auto light/dark
      
      // ✅ GetX configuration
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      
      home: const HomeView(),
    );
  }
}