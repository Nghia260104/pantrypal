import 'package:flutter/material.dart';
import 'package:pantrypal/core/strings/strings.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.appbarColor,
      selectedItemColor: colors.selectedNavColor,
      unselectedItemColor: colors.unselectedNavColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined, 
            size: 24,
          ),
          label: Strings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.flatware, 
            size: 24
          ),
          label: Strings.ingredients,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.fastfood, 
            size: 24
          ),
          label: Strings.meal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month, 
            size: 24
          ),
          label: Strings.plan,
        ),
      ],
    );
  }
}
