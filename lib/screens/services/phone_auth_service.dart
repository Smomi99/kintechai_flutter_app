import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/otp_screen.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(context) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'uid': user?.uid, 
          'mobile': user?.phoneNumber, 
          'email': user?.email,
        })
        .then((value){
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        })
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provider phone numbr is not valid');
      }
      print('The error is ${e.code}');
    };

    final PhoneCodeSent codeSent = (String verId, int? resendToken) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => OTPScreen(
            number: number,
            verId: verId,
          ),
        ),
      );
    };

    try {
      auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verificationID) {
            print(verificationID);
          });
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }
}
