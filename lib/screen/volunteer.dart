import 'package:flutter/material.dart';

class volunteer extends StatefulWidget {
  const volunteer({super.key});

  @override
  State<volunteer> createState() => _volunteerState();
}

class _volunteerState extends State<volunteer> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Volunteer"),
    );
  }
}
