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
      backgroundColor: Theme.of(context).colorScheme.surface,
      indicatorColor: Theme.of(context).colorScheme.tertiary,
      selectedIndex: currentPageIndex,
      onDestinationSelected: onClicked,
      destinations: <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onSurface),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.sos_outlined, color: Theme.of(context).colorScheme.onSurface),
          label: 'SOS',
        ),
        NavigationDestination(
          icon: Icon(Icons.details_outlined, color: Theme.of(context).colorScheme.onSurface),
          label: 'Status',
        ),
        NavigationDestination(
          icon: Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.onSurface),
          label: 'Maps',
        ),
        NavigationDestination(
          icon: Icon(Icons.health_and_safety_outlined, color: Theme.of(context).colorScheme.onSurface),
          label: 'Volunteer',
        ),
      ],
    );
  }
}
