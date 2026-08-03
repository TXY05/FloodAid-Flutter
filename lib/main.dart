import 'package:floodaid_flutter/composable/bottom_nav_bar.dart';
import 'package:floodaid_flutter/screen/dashboard.dart';
import 'package:floodaid_flutter/screen/map.dart';
import 'package:floodaid_flutter/screen/sos.dart';
import 'package:floodaid_flutter/screen/status.dart';
import 'package:floodaid_flutter/screen/volunteer.dart';
import 'package:floodaid_flutter/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floodaid',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(title: 'Floodaid', onToggleTheme: toggleTheme),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,
  });

  final String title;
  final VoidCallback onToggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  void onClicked(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  final List<Widget> pages = [
    Dashboard(),
    SosScreen(),
    StatusScreen(),
    MapScreen(),
    VolunteerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomMenu(
        currentPageIndex: currentPageIndex,
        onClicked: onClicked,
      ),
    );
  }
}
