import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_flutter/geocoder.dart';
import 'package:location/location.dart';
import 'package:phoneotp/screens/login_screen.dart';

class HomePageScreen extends StatefulWidget {
  static const String id = 'home-page-screen';

  LocationData? locationData;

  HomePageScreen({required this.locationData});
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String address = 'Bangladesh';

  Future<String?> getAddress() async {
// From coordinates
    final coordinates = new Coordinates(1.10, 45.50);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      address = first.addressLine!;
    });
    return first.addressLine;
  }

  // @override
  // void initState() {
  //   getAddress();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: InkWell(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Colors.black,
                    size: 18,
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
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
