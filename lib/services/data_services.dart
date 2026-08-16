import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/status.dart';

class FloodDataService {
  static const String _storageKey = 'flood_status_data';

  // Firebase Realtime Database → Local storage
  static Future<void> fetchAndSave() async {

    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      'https://floodaid-flutter-default-rtdb.asia-southeast1.firebasedatabase.app',
    );

    final snapshot = await database
        .ref('stateWaterLevels')
        .get();


    final List<FloodStatus> floodData = [];

    for (final child in snapshot.children) {

      final data = Map<String, dynamic>.from(
        child.value as Map,
      );

      final floodStatus = FloodStatus.fromMap(data);

      floodData.add(floodStatus);
    }

    final prefs = await SharedPreferences.getInstance();

    final jsonData = floodData
        .map((item) => item.toMap())
        .toList();

    await prefs.setString(
      _storageKey,
      jsonEncode(jsonData),
    );

  }

  // Get all data from local storage
  static Future<List<FloodStatus>> getAll() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (item) => FloodStatus.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // Get one state's status
  static Future<FloodStatus?> getStatus(String state) async {
    final data = await getAll();

    try {
      return data.firstWhere(
            (item) => item.state == state,
      );
    } catch (_) {
      return null;
    }
  }
}