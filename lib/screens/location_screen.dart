import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder_flutter/geocoder.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';
import 'package:phoneotp/screens/login_screen.dart';
import 'package:phoneotp/screens/main_screen.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';
  final bool locationChanging;
  LocationScreen({required this.locationChanging});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final FirebaseService _service = FirebaseService();

  bool _loading = false;

  final Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  String? _address;

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? manualAddress;

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    // From coordinates
    // ignore: unnecessary_new
    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      _address = first.addressLine;
      countryValue = first.countryName;
    });
    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    //fetching location from firestore
    // ignore: unnecessary_null_comparison
    if (widget.locationChanging == null) {
      _service.users
          .doc(_service.user?.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          if (document['address'] != null) {
            if (mounted) {
              setState(() {
                _loading = true;
              });
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
          } else {
            setState(() {
              _loading = false;
            });
          }
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.black,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Colors.white,
    );

    showBottomScreen(context) {
      getLocation().then((location) {
        if (location != null) {
          progressDialog.dismiss();
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 28,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(color: Colors.black),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.clear),
                          ),
                          SizedBox(
                            width: 26,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search City, area or nearest area',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        progressDialog.show();
                        getLocation().then((value) {
                          if (value != null) {
                            _service.updateUser({
                              'location':
                                  GeoPoint(value.latitude!, value.longitude!),
                              'address': _address
                            }, context).then((value) {
                              progressDialog.dismiss();
                              Navigator.pushNamed(context, MainScreen.id);
                            });
                          }
                        });
                      },
                      leading: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: Text('Use current location',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text(
                        // ignore: unnecessary_null_comparison
                        location == null ? 'Enable location' : _address!,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 4, top: 4),
                        child: Text(
                          'Choose City',
                          style: TextStyle(
                              color: Colors.blueGrey.shade900, fontSize: 12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        dropdownDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        defaultCountry: DefaultCountry.Bangladesh,
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                            manualAddress =
                                '$cityValue,$stateValue,$countryValue';
                          });

                          if (value != null) {
                            _service.updateUser({
                              'address': manualAddress,
                              'state': stateValue,
                              'city': cityValue,
                              'country': countryValue
                            }, context);
                          }
                        },
                      ),
                    ),
                  ],
                );
              });
        } else {
          progressDialog.dismiss();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.asset('assets/images/location.jpg'),
          SizedBox(
            height: 20,
          ),
          Text(
            'Where do want \n to buy/sell products',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'To enjoy all that we have to offer you\nwe need to know where to look for them',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(
            height: 30,
          ),
          _loading
              ? Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Finding Location...')
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: _loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  ))
                                : ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    icon: Icon(CupertinoIcons.location_fill),
                                    label: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      child: Text(
                                        'Around Me',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () {
                                      progressDialog.show();
                                      getLocation().then((value) {
                                        if (value != null) {
                                          _service.updateUser({
                                            'address': _address,
                                            'location': GeoPoint(
                                                value.latitude!,
                                                value.longitude!)
                                          }, context);
                                        }
                                      });
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        progressDialog.show();
                        showBottomScreen(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2)),
                          ),
                          child: Text(
                            'Set location manually',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        child: Text('sign out'),
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          });
                        }),
                  ],
                )
        ],
      ),
    );
  }
}

// body: Center(
//         child: ElevatedButton(
//           child: Text('sign out'),
//           onPressed: () {
//             FirebaseAuth.instance.signOut().then((value) {
//               Navigator.pushReplacementNamed(context, LoginScreen.id);
//             });
//           },
//         ),
//       ),
