import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String currentStatus = 'Safe';
  String selectedLocation = '';
  final List<String> locations = [
    'Gombak',
    'Hulu Langat',
    'Hulu Selangor',
    'Klang',
    'Kuala Selangor',
    'Petaling',
    'Sabak Bernam',
    'Sepang',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FloodAid")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloodStatusHeader(
              locations: locations,
              selectedLocation: selectedLocation,
            ),
          ],
        ),
      ),
    );
  }
}

class FloodStatusHeader extends StatefulWidget {
  final String status;
  final List<String> locations;
  final String selectedLocation;
  final ValueChanged<String?>? onLocationChanged;

  const FloodStatusHeader({
    super.key,
    this.status = 'Safe',
    required this.locations,
    required this.selectedLocation,
    this.onLocationChanged,
  });

  @override
  State<FloodStatusHeader> createState() => _FloodStatusHeaderState();
}

class _FloodStatusHeaderState extends State<FloodStatusHeader> {
  late String? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation =
    widget.selectedLocation.isEmpty ? null : widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    late Color iconColor;
    late Color textColor;
    late String message;
    late IconData icon;

    switch (widget.status) {
      case 'Flooded':
        iconColor = Colors.red;
        textColor = Colors.red;
        message = 'Flooded Area Detected';
        icon = Icons.warning;
        break;

      case 'Safe':
        iconColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
        message = 'Safe';
        icon = Icons.check_circle;
        break;

      default:
        iconColor = Colors.grey;
        textColor = Colors.grey;
        message = 'Unknown Status';
        icon = Icons.help;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: iconColor),

        const SizedBox(height: 16),

        Text(
          message,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        DropdownButton<String>(
          focusColor: Colors.transparent,
          value: selectedLocation,
          hint: const Text('Select a location'),
          items: widget.locations.map((location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (location) {
            setState(() {
              selectedLocation = location!;
            });
          },
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'Safe',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 24),

            const Icon(Icons.warning, color: Colors.red, size: 20),
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'Flooded',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Press the button above to change districts.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
