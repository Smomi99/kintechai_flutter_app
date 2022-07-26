import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:phoneotp/widget/product_card.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,##0');
    String _kmFormatted(km) {
      var _km = int.parse(km);
      var _formattedKm = _format.format(_km);
      return _formattedKm;
    }

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'My Add',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicatorWeight: 6,
              tabs: [
                Tab(
                  child: Text(
                    'ADS',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'Favourite',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.products
                      .where('sellerUid', isEqualTo: _service.user?.uid)
                      .orderBy('postedAt')
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 140, right: 140),
                        child: Center(
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 56,
                            child: Text(
                              'Fresh Recommendations',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
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
                              String _formattedPrice =
                                  '${_format.format(_price)} Tk';
                              String _formattedKm = '${_format.format(_km)} ';
                              return ProductCard(
                                  data: data, formattedPrice: _formattedPrice);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Text(
                'My Ads Screen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
