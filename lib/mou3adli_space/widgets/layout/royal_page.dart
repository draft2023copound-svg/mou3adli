import 'package:flutter/material.dart';

class RoyalPage extends StatelessWidget {
  final Widget body;
  final Widget? header;
  final Widget? floatingActionButton;
  final Widget? bottomNavigation;
  final Color? backgroundColor;
  final bool safeArea;
  final bool extendBody;

  const RoyalPage({
    super.key,
    required this.body,
    this.header,
    this.floatingActionButton,
    this.bottomNavigation,
    this.backgroundColor,
    this.safeArea = true,
    this.extendBody = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget page = Scaffold(
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigation,
      body: Column(
        children: [
          if (header != null) header!,
          Expanded(child: body),
        ],
      ),
    );

    if (!safeArea) return page;
    return SafeArea(child: page);
  }
}