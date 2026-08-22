import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floodaid_flutter/model/shelter_model.dart';
import 'package:floodaid_flutter/model/status_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FloodDataService {
  static const String _storageKey = 'flood_status_data';
  static const String _shelterStorageKey = 'shelter_data';

  static Future<void> fetchAndSave() async {
    final firestore = FirebaseFirestore.instance;

    final floodSnapshot = await firestore
        .collection('stateWaterLevels')
        .get();

    final List<FloodStatus> floodData = [];

    for (final doc in floodSnapshot.docs) {
      final data = doc.data();

      final floodStatus = FloodStatus.fromMap(data);

      floodData.add(floodStatus);
    }

    final shelterSnapshot = await firestore
        .collection('stateWaterLevels')
        .get();

    final List<Shelter> shelterData = [];

    for (final doc in shelterSnapshot.docs) {
      final data = doc.data();

      final shelter = Shelter.fromMap(data);

      shelterData.add(shelter);
    }

    final prefs = await SharedPreferences.getInstance();

    final jsonData = floodData
        .map((item) => item.toMap())
        .toList();

    await prefs.setString(
      _storageKey,
      jsonEncode(jsonData),
    );

    final shelterJsonData = floodData
        .map((item) => item.toMap())
        .toList();

    await prefs.setString(
      _shelterStorageKey,
      jsonEncode(shelterJsonData),
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

  static Future<List<Shelter>> getAllShelters() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_shelterStorageKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (item) => Shelter.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}