import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneotp/provider/cat_provider.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:phoneotp/widget/product_card.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final bool? proScreen;
  ProductList({this.proScreen});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    final _format = NumberFormat('##,##,##0');
    String _kmFormatted(km) {
      var _km = int.parse(km);
      var _formattedKm = _format.format(_km);
      return _formattedKm;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _catProvider.selectedCategory == 'Cars'
              ? _service.products
                  .orderBy('postedAt')
                  .where('category', isEqualTo: _catProvider.selectedCategory)
                  .get()
              : _service.products
                  .orderBy('postedAt')
                  .where('subCat', isEqualTo: _catProvider.selectedSubCat)
                  .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140, right: 140),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey.shade100,
                ),
              );
            }
            if (snapshot.data?.docs.length == 0) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Text(
                  'No Productds added \n under the selected category',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proScreen == true)
                  Container(
                      height: 56,
                      child: Text(
                        'Fresh Recommendations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2.6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10),
                  itemCount: snapshot.data?.size,
                  itemBuilder: (BuildContext context, int i) {
                    var data = snapshot.data?.docs[i];
                    var _price = int.parse(data?['price']);
                    var _km = data?['category'] == 'Cars'
                        ? int.parse(data?['kmDrive'])
                        : Text('');
                    String _formattedPrice = '${_format.format(_price)} Tk';
                    String _formattedKm = '${_format.format(_km)} ';
                    return ProductCard(
                        data: data, formattedPrice: _formattedPrice);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}



// class ProductList extends StatefulWidget {
//   const ProductList({Key? key}) : super(key: key);

//   @override
//   State<ProductList> createState() => _ProductListState();
// }

// class _ProductListState extends State<ProductList> {
//   late bool proScreen;


//   @override
//   Widget build(BuildContext context) {
//     FirebaseService _service = FirebaseService();
//     final _format = NumberFormat('##,##,##0');
//     String _kmFormatted(km) {
//       var _km = int.parse(km);
//       var _formattedKm = _format.format(_km);
//       return _formattedKm;
//     }

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//         child: FutureBuilder<QuerySnapshot>(
//           future: _service.products.orderBy('postedAt').get(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Padding(
//                 padding: const EdgeInsets.only(left: 140, right: 140),
//                 child: LinearProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).primaryColor),
//                   backgroundColor: Colors.grey.shade100,
//                 ),
//               );
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     height: 56,
//                     child: Text(
//                       'Fresh Recommendations',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                       maxCrossAxisExtent: 200,
//                       childAspectRatio: 2 / 2.6,
//                       crossAxisSpacing: 8,
//                       mainAxisSpacing: 10),
//                   itemCount: snapshot.data?.size,
//                   itemBuilder: (BuildContext context, int i) {
//                     var data = snapshot.data?.docs[i];
//                     var _price = int.parse(data?['price']);
//                     var _km = data?['category'] == 'Cars'
//                         ? int.parse(data?['kmDrive'])
//                         : Text('');
//                     String _formattedPrice = '${_format.format(_price)} Tk';
//                     String _formattedKm = '${_format.format(_km)} ';
//                     return ProductCard(
//                         data: data, formattedPrice: _formattedPrice);
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
