import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/categories/category_list.dart';
import 'package:phoneotp/screens/categories/subcat_screen.dart';
import 'package:phoneotp/screens/sellitems/product_by_category_screen.dart';
import 'package:phoneotp/screens/sellitems/seller_subcat.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              _service.categories.orderBy('sortId', descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 130,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('Categories')),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, CategoryListScreen.id);
                        },
                        child: Row(
                          children: const [
                            Text(
                              'See all',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var doc = snapshot.data?.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              _catProvider.getCategory(doc!['catName']);
                              _catProvider.getCatSnapshot(doc);
                              if (doc['subCat'] == null) {
                                _catProvider.getSubCategory(null);

                                Navigator.pushNamed(
                                    context, ProductByCategory.id);
                              } else {
                                Navigator.pushNamed(context, SubCatList.id,
                                    arguments: doc);
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 50,
                              child: Column(
                                children: [
                                  Image.network(
                                    doc!['image'],
                                    width: 50,
                                  ),
                                  Flexible(
                                    child: Text(
                                      doc['catName'].toUpperCase(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
