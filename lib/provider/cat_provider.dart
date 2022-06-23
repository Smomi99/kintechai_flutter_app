import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';

class CategoryProvider with ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  DocumentSnapshot? doc;
  DocumentSnapshot? userDetails;
  String? selectedCategory;
  String? selectedSubCat;
  List<String> urlList = [];
  Map<String, dynamic> dataToFirestore = {};

  getCategory(selectedCat) {
    this.selectedCategory = selectedCat;

    notifyListeners();
  }

  getSubCategory(selectedsubCat) {
    this.selectedSubCat = selectedsubCat;

    notifyListeners();
  }

  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore = data;
    notifyListeners();
  }

  getUserDetails() {
    _service.getUserData().then((value) {
      this.userDetails = value;
      notifyListeners();
    });
  }

  clearData() {
    this.urlList = [];
    dataToFirestore = {};
    notifyListeners();
  }

  // void getImage() {
  //   this.urlList.add(url);
  //   notifyListeners();
  // }
}
