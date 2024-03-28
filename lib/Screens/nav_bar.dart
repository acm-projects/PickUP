import 'package:flutter/material.dart';
import 'home_page.dart';
import 'map.dart';
import 'game_creation.dart';
import 'profile.dart';

void main() {
  runApp(MainPage());
}

class NavigationDestination {
  final Icon icon;
  final Icon selectedIcon;
  final String label;

  NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class NavigationBar extends StatefulWidget {
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Duration animationDuration;
  final NavigationDestinationLabelBehavior labelBehavior;

  NavigationBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.animationDuration,
    required this.labelBehavior,
  });

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      height: 64, // Increased height
      decoration: BoxDecoration(
        color: Color(0xFF72CD52), // Navigation bar color
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)), // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.destinations.map((destination) {
          var index = widget.destinations.indexOf(destination);
          return GestureDetector(
            onTap: () => widget.onDestinationSelected(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: widget.animationDuration,
                  transform: Matrix4.translationValues(
                    0.0,
                    widget.selectedIndex == index
                        ? -1.5
                        : 0.0, // Move up when selected
                    0.0,
                  ),
                  child: widget.selectedIndex == index
                      ? destination.selectedIcon
                      : destination.icon,
                ),
                SizedBox(height: 4),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final screens = [
    HomePage(),
    MapPage(),
    GameCreationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF72CD52), // Background color of the scaffold
        extendBody: true,
        body: screens[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: Duration(milliseconds: 300), // Animation duration
          onDestinationSelected: (index) {
            setState(() {
              this.index = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 30),
              selectedIcon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined, size: 30),
              selectedIcon: Icon(Icons.map, size: 30),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_outlined, size: 30),
              selectedIcon: Icon(Icons.add, size: 30),
              label: 'Create Game',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined, size: 30),
              selectedIcon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

enum NavigationDestinationLabelBehavior {
  alwaysShow,
  onlyShowSelected,
  alwaysHide,
}
