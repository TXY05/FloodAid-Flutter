import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floodaid_flutter/model/status.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FloodDataService {
  static const String _storageKey = 'flood_status_data';

  static Future<void> fetchAndSave() async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('stateWaterLevels')
        .get();

    final List<FloodStatus> floodData = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();

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