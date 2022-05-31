import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_flutter/geocoder.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/login_screen.dart';
import 'package:phoneotp/widget/custom_appbar.dart';

class HomePageScreen extends StatefulWidget {
  static const String id = 'home-page-screen';

  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
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


// class HomePageScreen extends StatefulWidget {
//   static const String id = 'home-page-screen';
//   final LocationData locationData;

//   // ignore: use_key_in_widget_constructors
//   const HomePageScreen({required this.locationData});

//   @override
//   State<HomePageScreen> createState() => _HomePageScreenState();
// }

// class _HomePageScreenState extends State<HomePageScreen> {
//   String address = 'Bangladesh';

//   Future<String> getAddress() async {
// // From coordinates
//     final coordinates = new Coordinates(1.10, 45.50);
//     var addresses =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     setState(() {
//       address = first.addressLine;
//     });
//     return first.addressLine;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(address),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('sign out'),
//           onPressed: () {
//             FirebaseAuth.instance.signOut().then((value) {
//               Navigator.pushReplacementNamed(context, LoginScreen.id);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
