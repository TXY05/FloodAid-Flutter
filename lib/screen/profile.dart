import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('User Profile'),
      ),
      body: StreamBuilder<
          DocumentSnapshot<
              Map<String, dynamic>>>(
        stream:
        AuthService.getUserProfile(),
        builder:
            (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Profile not found.',
              ),
            );
          }

          final data =
          snapshot.data!.data()!;

          return ListView(
            padding:
            const EdgeInsets.all(20),
            children: [
              const CircleAvatar(
                radius: 65,
                child: Icon(
                  Icons.person,
                  size: 90,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              info(
                'Username',
                display(
                    data['username']),
              ),

              info(
                'Email',
                display(data['email']),
              ),

              info(
                'MyKad / Passport',
                display(
                  data['myKadPassport'],
                ),
              ),

              info(
                'Phone',
                display(data['phone']),
              ),

              info(
                'Preferred Location',
                display(
                  data[
                  'preferredLocation'],
                ),
              ),

              info(
                'Emergency Contact',
                '${display(data['emergencyName'])} '
                    '${display(data['emergencyPhone'])}',
              ),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditProfileScreen(
                            data: data,
                          ),
                    ),
                  );
                },
                child: const Text(
                  'Update Profile',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String display(
      dynamic value) {
    if (value == null ||
        value.toString().trim().isEmpty) {
      return 'Not provided';
    }

    return value.toString();
  }

  static Widget info(
      String title,
      String value,
      ) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style:
          const TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }
}

class EditProfileScreen
    extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditProfileScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditProfileScreen>
  createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  late TextEditingController
  usernameController;

  late TextEditingController
  phoneController;

  late TextEditingController
  locationController;

  late TextEditingController
  emergencyNameController;

  late TextEditingController
  emergencyPhoneController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    usernameController =
        TextEditingController(
          text:
          widget.data['username'] ?? '',
        );

    phoneController =
        TextEditingController(
          text:
          widget.data['phone'] ?? '',
        );

    locationController =
        TextEditingController(
          text: widget.data[
          'preferredLocation'] ??
              '',
        );

    emergencyNameController =
        TextEditingController(
          text: widget.data[
          'emergencyName'] ??
              '',
        );

    emergencyPhoneController =
        TextEditingController(
          text: widget.data[
          'emergencyPhone'] ??
              '',
        );
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    setState(() {
      loading = true;
    });

    try {
      await AuthService.updateProfile(
        username:
        usernameController.text,
        phone:
        phoneController.text,
        preferredLocation:
        locationController.text,
        emergencyName:
        emergencyNameController
            .text,
        emergencyPhone:
        emergencyPhoneController
            .text,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Update failed: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Update Profile'),
      ),
      body: ListView(
        padding:
        const EdgeInsets.all(20),
        children: [
          TextField(
            controller:
            usernameController,
            decoration:
            const InputDecoration(
              labelText: 'Username',
              border:
              OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller:
            phoneController,
            decoration:
            const InputDecoration(
              labelText:
              'Phone Number',
              border:
              OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller:
            locationController,
            decoration:
            const InputDecoration(
              labelText:
              'Preferred Location',
              border:
              OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller:
            emergencyNameController,
            decoration:
            const InputDecoration(
              labelText:
              'Emergency Contact Name',
              border:
              OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller:
            emergencyPhoneController,
            decoration:
            const InputDecoration(
              labelText:
              'Emergency Contact Phone',
              border:
              OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed:
            loading
                ? null
                : saveProfile,
            child: loading
                ? const CircularProgressIndicator()
                : const Text(
              'Save Changes',
            ),
          ),
        ],
      ),
    );
  }
}

