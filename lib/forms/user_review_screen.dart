import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/home_page_screen.dart';
import 'package:phoneotp/screens/location_screen.dart';
import 'package:phoneotp/screens/main_screen.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
  const UserReviewScreen({Key? key}) : super(key: key);

  static const String id = 'user-review-screen';

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formkey = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();
  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+88');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();

  // @override
  // void didChangeDependencies() {
  //   var _provider = Provider.of<CategoryProvider>(context);

  //   _provider.getUserDetails();

  //   setState(() {
  //     final args = ModalRoute.of(context)!.settings.arguments;
  //     if (args != null) {
  //       _nameController.text = _provider.userDetails?['name'];
  //       _phoneController.text = _provider.userDetails?['mobile'];
  //       _emailController.text = _provider.userDetails?['email'];
  //       _addressController.text = _provider.userDetails?['address'];
  //     }
  //   });
  //   super.didChangeDependencies();
  // }

  Future<void> updateUser(provider, Map<String, dynamic> data, context) {
    return _service.users.doc(_service.user?.uid).update(data).then(
      (value) {
        saveProductToDb(provider, context);
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update location '),
        ),
      );
    });
  }

  Future<void> saveProductToDb(CategoryProvider provider, context) {
    return _service.products.add(provider.dataToFirestore).then(
      (value) {
        provider.clearData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'We have recieve your products and will be notified you once get approve'),
          ),
        );
        Navigator.pushReplacementNamed(context, MainScreen.id);
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update location '),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    bool _loading = false;

    showConfirmDialog() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Are you sure . you want to save below the products'),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading:
                          Image.network(_provider.dataToFirestore['images'][0]),
                      title: Text(
                        _provider.dataToFirestore['title'],
                        maxLines: 1,
                      ),
                      subtitle: Text(_provider.dataToFirestore['price']),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeumorphicButton(
                          onPressed: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          style: NeumorphicStyle(
                            border: NeumorphicBorder(
                                color: Theme.of(context).primaryColor),
                            color: Colors.transparent,
                          ),
                          child: Text('Cancel'),
                        ),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            updateUser(
                                    _provider,
                                    {
                                      'contactDetails': {
                                        'contactMobile': _phoneController.text,
                                        'contactEmail': _emailController.text,
                                      },
                                      'name': _nameController.text,
                                    },
                                    context)
                                .whenComplete(() {
                              setState(() {
                                _loading = false;
                              });
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_loading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Review your details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Form(
          key: _formkey,
          child: FutureBuilder<DocumentSnapshot>(
            future: _service.getUserData(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document doesn't exist");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                );
              }
              final args = ModalRoute.of(context)!.settings.arguments;
              if (args != null) {
                _nameController.text = snapshot.data?['name'];
                _phoneController.text = snapshot.data?['mobile'].subString(3);
                _emailController.text = snapshot.data?['email'];
                _addressController.text = snapshot.data?['address'];
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 40,
                            child: Icon(
                              CupertinoIcons.person_alt,
                              color: Colors.red,
                              size: 60,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Your Name',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Contact details',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _countryCodeController,
                              enabled: false,
                              decoration: InputDecoration(labelText: 'country'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  helperText: 'Enter your contact number'),
                              maxLength: 11,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter mobile number';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            helperText: 'Enter contact email'),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              controller: _addressController,
                              maxLines: 1,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                helperText: 'contact address',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LocationScreen(
                                            popScreen: UserReviewScreen.id,
                                          )));
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text(
                  'confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                      showConfirmDialog();
                    });

                    // updateUser(
                    //     _provider,
                    //     {
                    //       'contactDetails': {
                    //         'name': _nameController.text,
                    //         'contactMobile': _phoneController.text,
                    //         'contactEmail': _emailController.text,
                    //       }
                    //     },
                    //     context);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter required Field')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
