import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:phoneotp/forms/form_class.dart';
import 'package:phoneotp/forms/user_review_screen.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:phoneotp/widget/imagePicker_widget.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);
  static const String id = 'form-screen';

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final FormClass _formClass = FormClass();

  var _brandText = TextEditingController();
  var _typeText = TextEditingController();
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FirebaseService _service = FirebaseService();

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (provider.urlList.isNotEmpty) {
        provider.dataToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCat': provider.selectedSubCat,
          'brand': _brandText.text,
          'type': _typeText.text,
          'price': _priceController.text,
          'title': _titleController.text,
          'description': _descController.text,
          'sellerUid': _service.user?.uid,
          'images': provider.urlList,
          'postedAt': DateTime.now().microsecondsSinceEpoch,
        });

        print(provider.dataToFirestore);
        Navigator.pushNamed(context, UserReviewScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image not uploaded'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete require field'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showFormDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _textController.text = list[i];
                              });
                              Navigator.pop(context);
                            },
                            title: Text(
                              list[i],
                            ),
                          );
                        }),
                  )
                ],
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
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                    '${_provider.selectedCategory} > ${_provider.selectedSubCat}'),
                if (_provider.selectedSubCat == 'Mobiles Phone')
                  InkWell(
                    onTap: () {
                      showFormDialog(_provider.doc!['brands'], _brandText);
                    },
                    child: TextFormField(
                      controller: _brandText,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Brands',
                      ),
                    ),
                  ),
                if (_provider.selectedSubCat == 'Accessories' ||
                    _provider.selectedSubCat == 'Tablets')
                  InkWell(
                    onTap: () {
                      if (_provider.selectedSubCat == 'Tablets') {
                         showFormDialog(_formClass.tabType, _typeText);
                      }
                      showFormDialog(_formClass.accessories, _typeText);
                    },
                    child: TextFormField(
                      controller: _typeText,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Types',
                      ),
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
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Minimum betting price *', prefixText: 'BDT'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please completed the required file';
                    }
                    if (value.length < 5) {
                      return 'Required minimum price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autofocus: false,
                  controller: _descController,
                  keyboardType: TextInputType.text,
                  maxLength: 4000,
                  minLines: 1,
                  maxLines: 30,
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _provider.urlList.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "no image selected",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GalleryImage(
                          imageUrls: _provider.urlList,
                          numOfShowImages: _provider.urlList.length,
                        ),
                ),
                SizedBox(
                  height: 20,
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
                    style: NeumorphicStyle(
                        border: NeumorphicBorder(
                      color: Theme.of(context).primaryColor,
                    )),
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
                onPressed: () {
                  validate(_provider);
                  print(_provider.dataToFirestore);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
