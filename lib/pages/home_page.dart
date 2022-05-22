import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/phoneotpreg.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/welcome.jpg"),
        Container(
          margin: const EdgeInsets.all(65),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => const PhoneOtp()));
            },
            child: const Text(
              'logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }
}
