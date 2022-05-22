import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Colorize Colors
    const _colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Lato',
    );

    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo.png",
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250.0,
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'কিনতে চাই',
                    textStyle: colorizeTextStyle,
                    colors: _colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'বেচতে চাই',
                    textStyle: colorizeTextStyle,
                    colors: _colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'দেখতে চাই ',
                    textStyle: colorizeTextStyle,
                    colors: _colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
