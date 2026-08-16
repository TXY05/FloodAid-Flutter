import 'package:floodaid_flutter/model/status.dart';
import 'package:flutter/material.dart';

import '../services/data_services.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onNavigateToTab;

  const Dashboard({super.key, required this.onNavigateToTab});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FloodStatus? currentFloodStatus;
  String selectedLocation = '';
  final List<String> locations = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Perlis',
    'Pulau Pinang',
    'Perak',
    'Sabah',
    'Selangor',
    'Sarawak',
    'Terengganu',
    'Kuala Lumpur',
    'Labuan',
  ];

  Future<void> loadFloodStatus(String location) async {
    final data = await FloodDataService.getStatus(location);

    if(!mounted){
      return;

    }

    setState(() {
      currentFloodStatus = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FloodAid")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              FloodStatusHeader(
                status: currentFloodStatus?.status ?? 'unknown',
                locations: locations,
                selectedLocation: selectedLocation,
                onNavigateToTab: widget.onNavigateToTab,
                onLocationChanged: (location){
                  if(location != null){

                    setState(() {
                      selectedLocation = location;
                    });
                    loadFloodStatus(location);
                  }
                },
              )
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

  final Function(int) onNavigateToTab;

  const FloodStatusHeader({
    super.key,
    this.status = 'danger',
    required this.locations,
    required this.selectedLocation,
    this.onLocationChanged,
    required this.onNavigateToTab,
  });

  @override
  State<FloodStatusHeader> createState() => _FloodStatusHeaderState();
}

class _FloodStatusHeaderState extends State<FloodStatusHeader> {
  late String? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation.isEmpty
        ? null
        : widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    late Color iconColor;
    late Color textColor;
    late String message;
    late IconData icon;

    switch (widget.status) {
      case 'normal':
        iconColor = Colors.green;
        textColor = Colors.green;
        message = 'Normal';
        icon = Icons.check_circle;
        break;

      case 'alert':
        iconColor = const Color(0xFFDFDF3F);
        textColor = const Color(0xFFDFDF3F);
        message = 'Alert';
        icon = Icons.crisis_alert_outlined;
        break;

      case 'warning':
        iconColor = Colors.orange;
        textColor = Colors.orange;
        message = 'Warning';
        icon = Icons.warning;
        break;

      case 'danger':
        iconColor = Colors.red;
        textColor = Colors.red;
        message = 'Danger';
        icon = Icons.dangerous;
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

        SizedBox(
          width: 150,
          child: DropdownButton<String>(
            isExpanded: true,
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
              if (location == null) {
                return;
              }

              setState(() {
                selectedLocation = location;
              });

              widget.onLocationChanged?.call(location);
            },
          ),
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

            const Icon(Icons.dangerous, color: Colors.red, size: 20),
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
        const SizedBox(height: 16),
        Container(
          color: Color(0xFFFFF9C4),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 32,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FeatureCard(
                    title: 'SOS',
                    icon: Icons.sos_outlined,
                    color: Color(0xFF624CC7),
                    size: 60,
                    onClick: () {
                      widget.onNavigateToTab(1);
                    },
                  ),
                  FeatureCard(
                    title: 'Flood Status',
                    icon: Icons.warning,
                    color: Color(0xFFEF5350),
                    size: 60,
                    onClick: () {
                      widget.onNavigateToTab(2);
                    },
                  ),
                  FeatureCard(
                    title: 'Shelter Map',
                    icon: Icons.place,
                    color: Color(0xFF42A5F5),
                    size: 60,
                    onClick: () {
                      widget.onNavigateToTab(3);
                    },
                  ),
                  FeatureCard(
                    title: 'Volunteer',
                    icon: Icons.health_and_safety,
                    color: Color(0xFF58BD85),
                    size: 60,
                    onClick: () {
                      widget.onNavigateToTab(4);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Logout', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onClick;

  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.size,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: size,
          height: size,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
