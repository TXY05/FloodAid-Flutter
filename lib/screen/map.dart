import 'package:floodaid_flutter/model/shelter_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/data_services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  List<Shelter> shelters = [];
  Set<Marker> markers = {};

  static const LatLng _center = LatLng(3.187308, 101.703697);

  bool _locationPermissionGranted = false;

  Future<void> loadShelters() async {
    final data = await FloodDataService.getAllShelters();

    setState(() {
      shelters = data;
    });
  }

  Set<Marker> _createMarkers() {
    return shelters.map((shelter) {
      return Marker(
        markerId: MarkerId(shelter.id.toString()),
        position: LatLng(
          shelter.lat,
          shelter.lng,
        ),
        infoWindow: InfoWindow(
          title: shelter.name,
          snippet: shelter.address,
          onTap: () {
            openGoogleMaps(
              shelter.lat,
              shelter.lng,
            );
          },
        ),
      );
    }).toSet();
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    // Check if GPS is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _locationPermissionGranted = true;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> openGoogleMaps(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shelter Map'), elevation: 2),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        myLocationEnabled: _locationPermissionGranted,
        myLocationButtonEnabled: true,
        markers: _createMarkers(),
      ),
    );
  }
}
