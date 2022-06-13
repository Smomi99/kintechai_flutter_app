import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:phoneotp/widget/imagePicker_widget.dart';
import 'package:provider/provider.dart';

class SellerCarForm extends StatefulWidget {
  const SellerCarForm({Key? key}) : super(key: key);
  static const String id = 'car-form';

  @override
  State<SellerCarForm> createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final _formKey = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _kmController = TextEditingController();
  var _noOfOwnerController = TextEditingController();
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _addressController = TextEditingController();
  validate() {
    if (_formKey.currentState!.validate()) {
      print('validated');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete require field'),
        ),
      );
    }
  }

  final List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  final List<String> _transmission = ['Menually', 'Automatic'];
  final List<String> _noOfOwner = ['1', '2', '3', '4+'];

  @override
  void initState() {
    _service.getUserData().then((value) {
      setState(() {
        _addressController.text = value['address'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldValue) {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        title: Text(
          ' $title > $fieldValue',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _appBar(_catProvider.selectedCategory, 'brands'),
          Expanded(
            child: ListView.builder(
                // shrinkWrap: true,
                itemCount: _catProvider.doc['models'].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _brandController.text =
                            _catProvider.doc['models'][index];
                      });
                      Navigator.pop(context);
                    },
                    title: Text(_catProvider.doc['models'][index]),
                  );
                }),
          ),
        ]),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                })
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CAR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      controller: _brandController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Brand / Model / Variant',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please completed the required file';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Year*',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please completed the required file';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Minimum betting price *',
                        prefixText: 'BDT'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please completed the required file';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Fuel',
                                list: _fuelList,
                                textController: _fuelController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _fuelController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Fuel*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please completed the required file';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Transmission',
                                list: _transmission,
                                textController: _transmissionController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Transmission*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please completed the required file';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'KM Driven*',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please completed the required file';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'No. of owners',
                                list: _noOfOwner,
                                textController: _noOfOwnerController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'No. Of Owner*',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please completed the required file';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Add title*',
                      counterText: 'Mention the key features (e.g brand,model)',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please completed the required file';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    maxLength: 4000,
                    decoration: InputDecoration(
                      labelText: 'Add description*',
                      counterText:
                          'Include condition, features and reason for selling',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please completed the required file';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextFormField(
                    enabled: false,
                    minLines: 2,
                    maxLines: 4,
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address*',
                      counterText: 'Seller Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please completed the required file';
                      }
                      return null;
                    },
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImagePickerWidget();
                          });
                    },
                    child: Neumorphic(
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text('Upload image'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text(
                  'Save',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}