import 'package:flutter/material.dart';
import 'package:phoneotp/provider/cat_provider.dart';

class FormClass {
  List accessories = [
    'Mobile',
    'Tablets',
    
  ];
  List tabType = [
    'Ipads',
    'Samsung',
    'Other Tablets',
    
  ];


  Widget appBar(CategoryProvider _provider) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(
        '${_provider.selectedSubCat}',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
