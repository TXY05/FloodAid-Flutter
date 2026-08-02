import 'package:floodaid_flutter/screen/dashboard.dart';
import 'package:floodaid_flutter/screen/map.dart';
import 'package:floodaid_flutter/screen/sos.dart';
import 'package:floodaid_flutter/screen/status.dart';
import 'package:floodaid_flutter/screen/volunteer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floodaid',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Floodaid'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    dashboard(),
    sos(),
    status(),
    map(),
    volunteer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
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
      ),
    );
  }
}

