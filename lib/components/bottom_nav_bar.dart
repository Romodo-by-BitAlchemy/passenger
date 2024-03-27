import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    // Accessing the theme's color scheme to use the secondary color
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Romodo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      currentIndex: widget.selectedIndex,
      // Using colorScheme.secondary for selected item color
      selectedItemColor: colorScheme.secondary,
      // Customizing the unselected item color for better visibility
      unselectedItemColor: colorScheme.secondary.withOpacity(0.6),
      // Customizing the label color to match the icon color
      selectedLabelStyle: TextStyle(color: colorScheme.secondary),
      unselectedLabelStyle:
          TextStyle(color: colorScheme.secondary.withOpacity(0.6)),
      onTap: widget.onItemSelected,
    );
  }
}
