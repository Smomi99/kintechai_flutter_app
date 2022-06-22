import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  bool _uploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    // ignore: prefer_typing_uninitialized_variables
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
    });
    // if (type == "camera") {
    //   image = await ImagePicker()
    //       .pickImage(source: ImageSource.camera, imageQuality: 10);
    // } else {
    //   image = await ImagePicker()
    //       .pickImage(source: ImageSource.gallery, imageQuality: 25);
    // }
    // if (image != null) {
    //   setState(() {
    //     _image = File(image.path);
    //     base64Image = base64Encode(_image!.readAsBytesSync());
    //     // won't have any error now
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    Future<String?> uploadFile() async {
      File file = File(_image!.path);
      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String? downloadUrl;
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);

        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        // ignore: unnecessary_null_comparison
        if (downloadUrl != null) {
          setState(() {
            _image = null;
            _provider.getImages(downloadUrl);
          });
        }
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cancelled'),
          ),
        );
      }
      return downloadUrl;
    }

    // List<String> listOfUrls = [
    //   "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
    //   "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
    //   "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
    //   "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
    //   "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
    //   "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg",
    // ];

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Upload images',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            icon: const Icon(Icons.clear)),
                      ),
                    SizedBox(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image == null
                            ? const Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.grey,
                              )
                            : Image.file(_image!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_provider.urlList.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GalleryImage(
                      imageUrls: _provider.urlList,
                      numOfShowImages: _provider.urlList.length,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(color: Colors.green),
                          onPressed: () {
                            setState(() {
                              _uploading = true;

                              uploadFile().then((url) {
                                if (url != null) {
                                  setState(() {
                                    _uploading = false;
                                  });
                                }
                              });
                            });
                          },
                          child: const Text(
                            'Save',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: NeumorphicButton(
                          style: const NeumorphicStyle(color: Colors.red),
                          onPressed: () {},
                          child: const Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: NeumorphicButton(
                      onPressed: getImage,
                      style: NeumorphicStyle(
                          color: Theme.of(context).primaryColor),
                      child: Text(
                        _provider.urlList.isNotEmpty
                            ? 'Upload more images'
                            : 'Upload image',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_uploading)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
