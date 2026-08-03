import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int> onClicked;

  const BottomMenu({
    super.key,
    required this.currentPageIndex,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      indicatorColor: Colors.amber,
      selectedIndex: currentPageIndex,
      onDestinationSelected: onClicked,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'MyHomePage',
        ),
        NavigationDestination(icon: Icon(Icons.sos_outlined), label: 'SOS'),
        NavigationDestination(
          icon: Icon(Icons.details_outlined),
          label: 'Status',
        ),
        NavigationDestination(
          icon: Icon(Icons.location_on_outlined),
          label: 'Maps',
        ),
        NavigationDestination(
          icon: Icon(Icons.health_and_safety_outlined),
          label: 'Volunteer',
        ),
      ],
    );
  }
}
