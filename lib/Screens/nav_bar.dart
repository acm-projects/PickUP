import 'package:flutter/material.dart';
import 'home_page.dart';
import 'choose_gametype.dart';
import 'profile.dart';

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
  const NavigationBar({
    super.key,
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
      decoration: const BoxDecoration(
        color: Color(0xFF88F37F), // Navigation bar color
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
                const SizedBox(height: 4),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final screens = [
    const HomePage(),
    const GameCreation(),
    const GameCreation(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF88F37F), // Background color of the scaffold
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        animationDuration:
            const Duration(milliseconds: 300), // Animation duration
        onDestinationSelected: (index) {
          setState(() {
            List<String> map = [
              '/Login/HomePage',
              '/ChooseLocation',
              '/ChooseGameType',
              '/Profile'
            ];

            //!IF INDEX IS = 3 then make sure they don't have max, if they do they must delete games

            Navigator.of(context).pushNamed(map[index]);
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, size: 30),
            selectedIcon: const Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined, size: 30),
            selectedIcon: const Icon(Icons.map, size: 30),
            label: 'Map',
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_outlined, size: 30),
            selectedIcon: const Icon(Icons.add, size: 30),
            label: 'Create Game',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined, size: 30),
            selectedIcon: const Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

enum NavigationDestinationLabelBehavior {
  alwaysShow,
  onlyShowSelected,
  alwaysHide,
}
