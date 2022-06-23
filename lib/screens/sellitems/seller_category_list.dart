import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/forms/seller_car_form.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/sellitems/seller_subcat.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:provider/provider.dart';

class SellerCategory extends StatelessWidget {
  static const String id = 'seller-category';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Choose Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
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
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data?.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        _catProvider.getCategory(doc!['catName']);
                        _catProvider.getCatSnapshot(doc);
                        if (doc['subCat'] == null) {
                          Navigator.pushNamed(context, SellerCarForm.id);
                        } else {
                          Navigator.pushNamed(context, SellerSubCatList.id,
                              arguments: doc);
                        }
                      },
                      leading: Image.network(
                        doc!['image'],
                        width: 40,
                      ),
                      title: Text(doc['catName'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      trailing: doc['subCat'] == null
                          ? null
                          : Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
