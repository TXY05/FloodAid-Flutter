import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // ==========================================
  // SIGN UP
  // ==========================================

  static Future<String?> signUp({
    required String username,
    required String email,
    required String password,
    required String myKadPassport,
    required String preferredLocation,
  }) async {
    try {
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      String uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'username': username.trim(),
        'email': email.trim(),
        'myKadPassport': myKadPassport.trim(),
        'phone': '',
        'preferredLocation': preferredLocation,
        'emergencyName': '',
        'emergencyPhone': '',
        'isVolunteer': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already registered.';
      }

      if (e.code == 'weak-password') {
        return 'Password must contain at least 6 characters.';
      }

      if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      }

      return e.message ?? 'Sign up failed.';
    } catch (e) {
      return e.toString();
    }
  }

  // ==========================================
  // LOGIN
  // ==========================================

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return 'Incorrect email or password.';
      }

      if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      }

      return e.message ?? 'Login failed.';
    } catch (e) {
      return e.toString();
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  static Future<void> logout() async {
    await _auth.signOut();
  }

  // ==========================================
  // GET USER PROFILE
  // ==========================================

  static Stream<DocumentSnapshot<Map<String, dynamic>>>
  getUserProfile() {
    String uid = _auth.currentUser!.uid;

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots();
  }

  // ==========================================
  // UPDATE PROFILE
  // ==========================================

  static Future<void> updateProfile({
    required String username,
    required String phone,
    required String preferredLocation,
    required String emergencyName,
    required String emergencyPhone,
  }) async {
    String uid = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).update({
      'username': username.trim(),
      'phone': phone.trim(),
      'preferredLocation': preferredLocation.trim(),
      'emergencyName': emergencyName.trim(),
      'emergencyPhone': emergencyPhone.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==========================================
  // VOLUNTEER REGISTRATION
  // ==========================================

  static Future<void> registerVolunteer({
    required String fullName,
    required String myKadPassport,
    required String phone,
    required String address,
    required String emergencyName,
    required String emergencyPhone,
  }) async {
    String uid = _auth.currentUser!.uid;

    await _firestore.collection('volunteers').doc(uid).set({
      'userId': uid,
      'fullName': fullName.trim(),
      'myKadPassport': myKadPassport.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
      'emergencyName': emergencyName.trim(),
      'emergencyPhone': emergencyPhone.trim(),
      'registeredAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('users').doc(uid).update({
      'isVolunteer': true,
    });
  }

  // ==========================================
  // VOLUNTEER ACTIVITIES
  // ==========================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
  getActivities() {
    return _firestore
        .collection('volunteer_activities')
        .snapshots();
  }

  // ==========================================
  // ADD DEMO ACTIVITIES
  // ==========================================

  static Future<void> addDemoActivities() async {
    final activities = [
      {
        'title': 'Food Distribution',
        'location': 'Kuala Lumpur',
        'date': Timestamp.fromDate(
          DateTime(2026, 8, 30),
        ),
        'time': '10:00 AM - 6:00 PM',
        'description':
        'Help distribute food and drinking water to flood victims.',
        'availableSlots': 20,
      },
      {
        'title': 'Cleanup and Recovery',
        'location': 'Gombak',
        'date': Timestamp.fromDate(
          DateTime(2026, 8, 31),
        ),
        'time': '8:00 AM - 6:00 PM',
        'description':
        'Help residents clean houses and public areas after floods.',
        'availableSlots': 15,
      },
      {
        'title': 'Medical Assistance',
        'location': 'Petaling',
        'date': Timestamp.fromDate(
          DateTime(2026, 9, 1),
        ),
        'time': '11:00 AM - 7:00 PM',
        'description':
        'Assist the medical team and organise medical supplies.',
        'availableSlots': 10,
      },
      {
        'title': 'Donation Sorting',
        'location': 'Klang',
        'date': Timestamp.fromDate(
          DateTime(2026, 9, 2),
        ),
        'time': '10:00 AM - 6:00 PM',
        'description':
        'Sort donated items and prepare supplies for flood victims.',
        'availableSlots': 25,
      },
    ];

    WriteBatch batch = _firestore.batch();

    for (int i = 0; i < activities.length; i++) {
      var reference = _firestore
          .collection('volunteer_activities')
          .doc('activity_${i + 1}');

      batch.set(reference, activities[i]);
    }

    await batch.commit();
  }

  // ==========================================
  // APPLY ACTIVITY
  // ==========================================

  static Future<String?> applyActivity({
    required String activityId,
  }) async {
    String uid = _auth.currentUser!.uid;

    var activityRef = _firestore
        .collection('volunteer_activities')
        .doc(activityId);

    String applicationId = '${uid}_$activityId';

    var applicationRef = _firestore
        .collection('applications')
        .doc(applicationId);

    try {
      await _firestore.runTransaction(
            (transaction) async {
          var activitySnapshot =
          await transaction.get(activityRef);

          var applicationSnapshot =
          await transaction.get(applicationRef);

          if (applicationSnapshot.exists) {
            throw Exception(
              'You already applied for this activity.',
            );
          }

          if (!activitySnapshot.exists) {
            throw Exception(
              'Activity not found.',
            );
          }

          Map<String, dynamic> activity =
          activitySnapshot.data()!;

          int slots =
              activity['availableSlots'] ?? 0;

          if (slots <= 0) {
            throw Exception(
              'No available slots.',
            );
          }

          transaction.update(
            activityRef,
            {
              'availableSlots': slots - 1,
            },
          );

          transaction.set(
            applicationRef,
            {
              'userId': uid,
              'activityId': activityId,
              'activityTitle':
              activity['title'],
              'activityLocation':
              activity['location'],
              'activityDate':
              activity['date'],
              'status': 'Pending',
              'appliedAt':
              FieldValue.serverTimestamp(),
            },
          );
        },
      );

      return null;
    } catch (e) {
      return e
          .toString()
          .replaceFirst(
        'Exception: ',
        '',
      );
    }
  }

  // ==========================================
  // APPLICATION HISTORY
  // ==========================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
  getApplicationHistory() {
    String uid = _auth.currentUser!.uid;

    return _firestore
        .collection('applications')
        .where(
      'userId',
      isEqualTo: uid,
    )
        .snapshots();
  }
}