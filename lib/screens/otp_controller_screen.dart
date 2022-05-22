import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/homescreen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpControllerScreen extends StatefulWidget {
  final String phone;
  final String codeDigits;
  // ignore: use_key_in_widget_constructors
  const OtpControllerScreen({required this.phone, required this.codeDigits});
  @override
  State<OtpControllerScreen> createState() => _OtpControllerScreenState();
}

class _OtpControllerScreenState extends State<OtpControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOtpFocus = FocusNode();
  String? varificationCode;

  final BoxDecoration pinOtpCodeDecoration = BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.grey,
    ),
  );
  @override
  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.codeDigits + widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => const HomeScreen()));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          duration: const Duration(seconds: 3),
        ));
      },
      codeSent: (String vID, int? resentToken) {
        setState(() {
          varificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          varificationCode = vID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffolkey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyPhoneNumber();
                },
                child: Text(
                  "verifying: ${widget.codeDigits}-${widget.phone}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinOtpFocus,
              controller: _pinOTPCodeController,
              submittedFieldDecoration: pinOtpCodeDecoration,
              selectedFieldDecoration: pinOtpCodeDecoration,
              followingFieldDecoration: pinOtpCodeDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: varificationCode!, smsCode: pin))
                      .then((value) {
                    if (value.user != null) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => const HomeScreen()));
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid otp"),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
