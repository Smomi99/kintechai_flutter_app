import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneOtpRegistration extends StatelessWidget {
  const PhoneOtpRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Enter your phone number to continue , we will send you OTP to verify",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ),
              FadeInDown(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                  child: Stack(
                    children: [
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          // ignore: avoid_print
                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          // ignore: avoid_print
                          print(value);
                        },
                        cursorColor: Colors.black,
                        formatInput: false,
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        inputDecoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
                          border: InputBorder.none,
                          hintText: 'phone number',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 90,
                        top: 8,
                        bottom: 8,
                        child: Container(
                          height: 40,
                          width: 1,
                          color: Colors.black.withOpacity(0.13),
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
                  onPressed: () {},
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
// [
//                   //     CountryCodePicker(
//                   //       onChanged: (country) {
//                   //         setState(() {
//                   //           dialCodeDigits = country.dialCode!;
//                   //         });
//                   //       },
//                   //       initialSelection: "BD",
//                   //       showCountryOnly: false,
//                   //       showOnlyCountryWhenClosed: false,
//                   //       favorite: ["+1", "US", "+92", "PAK"],
//                   //     ),
//                   //     Container(
//                   //       margin: EdgeInsets.only(top: 10, right: 10, left: 10),
//                   //       child: TextField(
//                   //         decoration: InputDecoration(
//                   //           hintText: "Phone Number",
//                   //           prefix: Padding(
//                   //             padding: EdgeInsets.all(4),
//                   //             child: Text(dialCodeDigits),
//                   //           ),
//                   //         ),
//                   //         maxLength: 12,
//                   //         keyboardType: TextInputType.number,
//                   //         controller: _controller,
//                   //       ),
//                   //     ),
//                   //   ],