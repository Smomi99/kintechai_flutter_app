import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/login_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);
  static const String id = 'location-screen';
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('sign out'),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            });
          },
        ),
      ),
    );
  }
}
