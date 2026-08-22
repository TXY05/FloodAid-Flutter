import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:floodaid_flutter/composable/bottom_nav_bar.dart';
import 'package:floodaid_flutter/screen/dashboard.dart';
import 'package:floodaid_flutter/screen/login.dart';
import 'package:floodaid_flutter/screen/map.dart';
import 'package:floodaid_flutter/screen/profile.dart';
import 'package:floodaid_flutter/screen/sos.dart';
import 'package:floodaid_flutter/screen/status.dart';
import 'package:floodaid_flutter/screen/volunteer.dart';
import 'package:floodaid_flutter/services/data_services.dart';
import 'package:floodaid_flutter/theme/theme.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


// ============================================================
// MAIN APP
// ============================================================

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
      debugShowCheckedModeBanner: false,

      title: 'Floodaid',

      theme: lightTheme,

      darkTheme: darkTheme,

      themeMode:
      isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Check login before entering the application
      home: AuthGate(
        onToggleTheme: toggleTheme,
      ),
    );
  }
}


// ============================================================
// AUTHENTICATION GATE
// ============================================================

class AuthGate extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const AuthGate({
    super.key,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        // Firebase is still checking login status
        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User NOT logged in
        if (snapshot.data == null) {
          return const LoginScreen();
        }

        // User logged in
        return MyHomePage(
          title: 'Floodaid',
          onToggleTheme: onToggleTheme,
        );
      },
    );
  }
}


// ============================================================
// HOME PAGE
// ============================================================

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,
  });

  final String title;

  final VoidCallback onToggleTheme;

  @override
  State<MyHomePage> createState() =>
      _MyHomePageState();
}


class _MyHomePageState
    extends State<MyHomePage> {

  int currentPageIndex = 0;


  // ============================================================
  // LOAD FLOOD DATA AFTER LOGIN
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadFloodData();
  }


  Future<void> loadFloodData() async {
    try {

      await FloodDataService.fetchAndSave();

      debugPrint(
        'Flood data loaded successfully.',
      );

    } catch (e) {

      debugPrint(
        'Flood data error: $e',
      );
    }
  }


  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  void onNavigateToTab(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }


  // Keep your friend's existing navigation structure
  late final List<Widget> pages = [

    Dashboard(
      onNavigateToTab: onNavigateToTab,
    ),

    const SosScreen(),

    const StatusScreen(),

    const MapScreen(),

    const VolunteerScreen(),
  ];


  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor:
        Theme.of(context).colorScheme.primary,

        foregroundColor:
        Theme.of(context).colorScheme.onPrimary,

        title: Text(widget.title),

        actions: [

          // USER PROFILE
          IconButton(
            icon: const Icon(
              Icons.person,
            ),

            tooltip: 'User Profile',

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                  const ProfileScreen(),
                ),
              );
            },
          ),


          // DARK MODE
          IconButton(
            icon: const Icon(
              Icons.dark_mode,
            ),

            onPressed:
            widget.onToggleTheme,
          ),
        ],
      ),


      body:
      pages[currentPageIndex],


      // Keep your friend's BottomMenu
      bottomNavigationBar: BottomMenu(

        currentPageIndex:
        currentPageIndex,

        onClicked:
        onNavigateToTab,
      ),
    );
  }
}
