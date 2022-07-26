import 'package:flutter/material.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/product_list.dart';
import 'package:provider/provider.dart';

class ProductByCategory extends StatelessWidget {
  static const String id = 'product-by-cat';
  const ProductByCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedSubCat == null
              ? 'Cars'
              : '${_catProvider.selectedCategory} > ${_catProvider.selectedSubCat}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: ProductList(),
      ),
    );
  }
}
