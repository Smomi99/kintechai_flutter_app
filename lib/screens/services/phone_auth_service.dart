import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/otp_screen.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(
    context,
    String uid,
    String? phoneNumber,
  ) async {
    final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> document = result.docs;
    if (document.isNotEmpty) {
      Navigator.pushReplacementNamed(context, LocationScreen.id);
    } else {
      return users.doc(uid).set({
        'uid': uid,
        'mobile': phoneNumber,
        'email': user?.email,
      }).then((value) {
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }).catchError((error) => print("Failed to add user: $error"));
    }
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

    // ignore: prefer_function_declarations_over_variables
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
