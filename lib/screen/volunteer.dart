import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/auth_service.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Volunteer'),
        actions: [
          IconButton(
            icon:
            const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ApplicationHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child:
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const VolunteerRegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register as Volunteer',
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: SizedBox(
              width: double.infinity,
              child:
              OutlinedButton(
                onPressed: () async {
                  try {
                    await AuthService
                        .addDemoActivities();

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Demo activities added.',
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      SnackBar(
                        content:
                        Text('$e'),
                      ),
                    );
                  }
                },
                child:
                const Text(
                  'Add Demo Activities',
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<
                QuerySnapshot<
                    Map<String, dynamic>>>(
              stream:
              AuthService
                  .getActivities(),
              builder:
                  (context, snapshot) {
                if (snapshot
                    .connectionState ==
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
                    snapshot
                        .data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No volunteer activities.',
                    ),
                  );
                }

                final documents =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount:
                  documents.length,
                  itemBuilder:
                      (context, index) {
                    final document =
                    documents[index];

                    final activity =
                    document.data();

                    return Card(
                      margin:
                      const EdgeInsets
                          .all(10),
                      child: ListTile(
                        title: Text(
                          activity[
                          'title'] ??
                              '',
                        ),
                        subtitle: Text(
                          '${activity['location']}\n'
                              '${formatDate(activity['date'])}\n'
                              'Available slots: ${activity['availableSlots']}',
                        ),
                        trailing:
                        const Icon(
                          Icons
                              .arrow_forward_ios,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ActivityDetailScreen(
                                    activityId:
                                    document.id,
                                    activity:
                                    activity,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String formatDate(
      dynamic value) {
    if (value is Timestamp) {
      return DateFormat(
        'dd/MM/yyyy',
      ).format(
        value.toDate(),
      );
    }

    return '';
  }
}

class VolunteerRegisterScreen
    extends StatefulWidget {
  const VolunteerRegisterScreen({
    super.key,
  });

  @override
  State<VolunteerRegisterScreen>
  createState() =>
      _VolunteerRegisterScreenState();
}

class _VolunteerRegisterScreenState
    extends State<VolunteerRegisterScreen> {
  final formKey =
  GlobalKey<FormState>();

  final fullNameController =
  TextEditingController();

  final myKadController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final addressController =
  TextEditingController();

  final emergencyNameController =
  TextEditingController();

  final emergencyPhoneController =
  TextEditingController();

  bool loading = false;

  String? requiredField(
      String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Required.';
    }

    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await AuthService
          .registerVolunteer(
        fullName:
        fullNameController.text,
        myKadPassport:
        myKadController.text,
        phone:
        phoneController.text,
        address:
        addressController.text,
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
          content: Text('$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Volunteer Register',
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding:
          const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller:
              fullNameController,
              decoration:
              const InputDecoration(
                labelText: 'Full Name',
                border:
                OutlineInputBorder(),
              ),
              validator:
              requiredField,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              myKadController,
              decoration:
              const InputDecoration(
                labelText:
                'MyKad / Passport Number',
                border:
                OutlineInputBorder(),
              ),
              validator:
              requiredField,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              phoneController,
              decoration:
              const InputDecoration(
                labelText:
                'Phone Number',
                border:
                OutlineInputBorder(),
              ),
              validator:
              requiredField,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              addressController,
              maxLines: 3,
              decoration:
              const InputDecoration(
                labelText: 'Address',
                border:
                OutlineInputBorder(),
              ),
              validator:
              requiredField,
            ),

            const SizedBox(height: 20),

            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              emergencyNameController,
              decoration:
              const InputDecoration(
                labelText: 'Name',
                border:
                OutlineInputBorder(),
              ),
              validator:
              requiredField,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller:
              emergencyPhoneController,
              decoration:
              const InputDecoration(
                labelText:
                'Phone Number',
                border:
                OutlineInputBorder(),
              ),
              validator:
              requiredField,
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed:
              loading
                  ? null
                  : register,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text(
                'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityDetailScreen
    extends StatefulWidget {
  final String activityId;
  final Map<String, dynamic>
  activity;

  const ActivityDetailScreen({
    super.key,
    required this.activityId,
    required this.activity,
  });

  @override
  State<ActivityDetailScreen>
  createState() =>
      _ActivityDetailScreenState();
}

class _ActivityDetailScreenState
    extends State<ActivityDetailScreen> {
  bool loading = false;

  Future<void> apply() async {
    setState(() {
      loading = true;
    });

    String? error =
    await AuthService
        .applyActivity(
      activityId:
      widget.activityId,
    );

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
          error ??
              'Application successful.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activity =
        widget.activity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity Detail',
        ),
      ),
      body: ListView(
        padding:
        const EdgeInsets.all(20),
        children: [
          Text(
            activity['title'] ?? '',
            style: const TextStyle(
              fontSize: 26,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Location: ${activity['location']}',
          ),

          const SizedBox(height: 10),

          Text(
            'Time: ${activity['time']}',
          ),

          const SizedBox(height: 10),

          Text(
            'Available Slots: ${activity['availableSlots']}',
          ),

          const SizedBox(height: 20),

          Text(
            activity['description'] ??
                '',
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed:
            loading
                ? null
                : apply,
            child: loading
                ? const CircularProgressIndicator()
                : const Text(
              'Apply Activity',
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationHistoryScreen
    extends StatelessWidget {
  const ApplicationHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Activity History'),
      ),
      body: StreamBuilder<
          QuerySnapshot<
              Map<String, dynamic>>>(
        stream:
        AuthService
            .getApplicationHistory(),
        builder:
            (context, snapshot) {
          if (snapshot
              .connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot
                  .data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No application history.',
              ),
            );
          }

          return ListView.builder(
            itemCount:
            snapshot.data!.docs.length,
            itemBuilder:
                (context, index) {
              final data = snapshot
                  .data!.docs[index]
                  .data();

              return Card(
                child: ListTile(
                  title: Text(
                    data[
                    'activityTitle'] ??
                        '',
                  ),
                  subtitle: Text(
                    '${data['activityLocation']}\n'
                        'Status: ${data['status']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

