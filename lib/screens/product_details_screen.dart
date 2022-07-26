import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:phoneotp/provider/product_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = "product-details-screen";
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;
  int _index = 0;
  final _format = NumberFormat('##,##,##0');

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    var data = _productProvider.productData;
    var _price = int.parse(data['price']);
    String price = _format.format(_price);
    var _km = int.parse(data['kmDrive']);
    String km = _format.format(_km);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
          ),
          LikeButton(
            size: 22,
            circleColor:
                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
                size: 22,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              color: Colors.grey.shade300,
              child: _loading
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Loading your ads"),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        Center(
                          child: PhotoView(
                            backgroundDecoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            imageProvider: NetworkImage(data['images'][_index]),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data['images'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index = i;
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Colors.white,
                                        child: Image.network(data['images'][i]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            _loading
                ? Container()
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['title'].toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (data['category'] == 'Cars')
                                  Text("(${(data['year'])})"),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              '\$ $price',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (data['category'] == 'Cars')
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Container(
                                  color: Colors.grey.shade300,
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.filter_alt_outlined,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data['fuel'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.av_timer_outlined,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              km,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.account_tree_outlined,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              data['transmission'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 12,
                                      thickness: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              CupertinoIcons.person,
                                              size: 16,
                                            ),
                                            Text(
                                              data['noOfOwners'],
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        TextButton.icon(
                                          onPressed: () {},
                                          icon:
                                              Icon(Icons.location_on_outlined),
                                          label: Text('bangladesh'),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              )
                          ]),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
