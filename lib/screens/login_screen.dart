import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/auth_ui.dart';
import 'package:phoneotp/screens/location_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }
    });
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: AuthUi(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'If you continue, you are accepting\nTerms and Conditions and Privacy Policy ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
