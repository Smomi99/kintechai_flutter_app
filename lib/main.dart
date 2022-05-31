import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/home_page_screen.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/login_screen.dart';
import 'package:phoneotp/screens/phone_auth_screen.dart';
import 'package:phoneotp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get locationData => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.cyan.shade900,
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        HomePageScreen.id: (context) => HomePageScreen(),
      },
    );
  }
}

// FutureBuilder(
//       future: Future.delayed(const Duration(seconds: 10)),
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: SplashScreen(),
//           );
//         } else {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               primaryColor: Colors.cyan.shade900,
//               fontFamily: 'Lato',
//             ),
//             home: LoginScreen(),
//             routes: {
//               LoginScreen.id: (context) => LoginScreen(),
//               PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
//               LocationScreen.id: (context) => LocationScreen(),
//             },
//           );
//         }
//       },
//     );