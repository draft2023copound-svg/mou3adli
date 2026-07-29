import 'package:flutter/material.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';
import 'package:mou3adli/screens/subject_list_screen.dart';
import 'package:mou3adli/screens/term_selection_screen.dart';
import 'package:mou3adli/screens/profile_screen.dart'; // <-- Import ajouté

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    index: 0,
                    icon: Icons.home_rounded,
                    label: "Accueil",
                    targetScreen: const TermSelectionScreen(),
                  ),
                  
                  _buildNavItem(
                    context,
                    index: 1,
                    icon: Icons.menu_book_rounded,
                    label: "Matières",
                    targetScreen: const SubjectListScreen(),
                  ),
                  
                  const SizedBox(width: 40),
                  
                  _buildNavItem(
                    context,
                    index: 3,
                    icon: Icons.bar_chart_rounded,
                    label: "Statistiques",
                    targetScreen: const TermSelectionScreen(),
                  ),
                  
                  // --- MODIFICATION ICI : Redirection vers l'écran Profil ---
                  _buildNavItem(
                    context,
                    index: 4,
                    icon: Icons.person_outline_rounded,
                    label: "Profil",
                    targetScreen: const ProfileScreen(), // <-- C'est ici
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubjectListScreen()),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: kRoyalBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kRoyalBlue.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required Widget targetScreen,
  }) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        onTap(index);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? kRoyalBlue : Colors.grey.shade400,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? kRoyalBlue : Colors.grey.shade400,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}