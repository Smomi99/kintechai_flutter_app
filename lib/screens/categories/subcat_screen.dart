import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/sellitems/product_by_category_screen.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:provider/provider.dart';

class SubCatList extends StatelessWidget {
  const SubCatList({Key? key}) : super(key: key);
  static const String id = 'subCat-screen';
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    DocumentSnapshot args =
        ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          args['catName'],
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            var data = snapshot.data!['subCat'];
            return Container(
              child: ListView.builder(
                itemCount: data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: ListTile(
                      onTap: () {
                        _catProvider.getSubCategory(data[index]);

                        Navigator.pushNamed(context, ProductByCategory.id);
                      },
                      title: Text(data[index],
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
