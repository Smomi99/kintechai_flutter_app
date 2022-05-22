import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:phoneotp/screens/services/phone_auth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String id = 'phone-auth-screen';

  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String dialCodeDigits = "+88";
  final TextEditingController _controller = TextEditingController();
  phoneAuthentication(number) {
    print(number);
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        SizedBox(
          width: 8,
        ),
        Text("Please wait"),
      ]),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  PhoneAuthService _service = PhoneAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Image.asset(
                'assets/kingdom-sign-in.gif',
                width: 380,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 1,
              ),
              FadeInDown(
                child: const Text(
                  'register',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              FadeInDown(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Enter your phone number to continue , we will send you OTP to verify",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ),
              FadeInDown(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          // ignore: use_full_hex_values_for_flutter_colors
                          color: Color(0xffeeeeeee),
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              prefix: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(dialCodeDigits),
                              ),
                            ),
                            maxLength: 12,
                            keyboardType: TextInputType.number,
                            controller: _controller,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              FadeInDown(
                child: MaterialButton(
                  onPressed: () {
                    ProgressDialog progressDialog = ProgressDialog(
                      context: context,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                    );

                    progressDialog.show();
                    Future.delayed(Duration(seconds: 3))
                        .then((value) => progressDialog.dismiss());

                    String number = '$dialCodeDigits${_controller.text}';
                    _service.verifyPhoneNumber(context, number);
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  minWidth: double.infinity,
                  child: const Text(
                    "Request Otp",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FadeInDown(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have a account?",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: const Text("login"),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
