
import 'package:flutter/material.dart';

import 'package:phoneotp/widget/banner_widget.dart';
import 'package:phoneotp/widget/category_widget.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SafeArea(
          child: CustomAppBar(),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                            ),
                            labelText: 'Find Cars, Mobiles and many more...',
                            labelStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            )),
                      ),
                    ),
                  ),
                  Icon(Icons.notifications_none),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Column(
              children: [
                //banner
                BannerWidget(),
                //categories
                CategoryWidget(),
              ],
            ),
          )
        ],
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
