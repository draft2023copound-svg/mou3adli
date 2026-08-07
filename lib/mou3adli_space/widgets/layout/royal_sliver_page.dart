import 'package:flutter/material.dart';
import '../../foundation/colors.dart';

class RoyalSliverPage extends StatelessWidget {
  final Widget header;
  final List<Widget> slivers;
  final Widget? bottomNavigation;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  const RoyalSliverPage({
    super.key,
    required this.header,
    required this.slivers,
    this.bottomNavigation,
    this.floatingActionButton,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: header),
        ...slivers,
        const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
      ],
    );

    if (onRefresh != null) {
      body = RefreshIndicator(
        onRefresh: onRefresh!,
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: RoyalColors.background,
      extendBody: true,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNavigation,
      body: SafeArea(child: body),
    );
  }
}