import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final myKadController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  String selectedLocation = 'Kuala Lumpur';

  bool loading = false;

  final List<String> locations = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Perak',
    'Perlis',
    'Pulau Pinang',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
    'Labuan',
  ];

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    myKadController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));

      return;
    }

    setState(() {
      loading = true;
    });

    String? error = await AuthService.signUp(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      myKadPassport: myKadController.text,
      preferredLocation: selectedLocation,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });

    if (error == null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Create Flood AID Account',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email.';
                }

                if (!value.contains('@')) {
                  return 'Invalid email.';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: myKadController,
              decoration: const InputDecoration(
                labelText: 'MyKad / Passport Number',
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Minimum 6 characters.';
                }

                return null;
              },
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              validator: requiredField,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: selectedLocation,
              decoration: const InputDecoration(
                labelText: 'Preferred Location',
                border: OutlineInputBorder(),
              ),
              items: locations.map((location) {
                return DropdownMenuItem(value: location, child: Text(location));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLocation = value;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : signUp,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
