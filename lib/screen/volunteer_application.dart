import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floodaid_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class ApplicationHistoryScreen extends StatelessWidget {
  const ApplicationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity History')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: AuthService.getApplicationHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No application history.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index].data();

              return Card(
                child: ListTile(
                  title: Text(data['activityTitle'] ?? ''),
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
