import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:phoneotp/provider/product_provider.dart';
import 'package:phoneotp/screens/product_details_screen.dart';
import 'package:phoneotp/screens/services/firebase_services.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
    required String formattedPrice,
  })  : _formattedPrice = formattedPrice,
        super(key: key);

  final QueryDocumentSnapshot<Object?>? data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');
  String address = '';

  DocumentSnapshot? sellerDetails;

  String _kmFormatted(km) {
    var _km = int.parse(km);
    var _formattedKm = _format.format(_km);
    return _formattedKm;
  }

  @override
  void initState() {
    _service.getSellerData(widget.data?['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return InkWell(
      onTap: () {
        _provider.getProductDetails(widget.data);
        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Center(
                      child: Image.network(widget.data?['images'][0]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'biding start : ${widget._formattedPrice}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.data?['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widget.data?['category'] == 'Cars'
                      ? Text(
                          '${widget.data?['year']} - ${_kmFormatted(widget.data?['kmDrive'])} km',
                        )
                      : Text(''),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 14,
                        color: Colors.black38,
                      ),
                      Flexible(
                          child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 0.0,
                child: LikeButton(
                  size: 22,
                  circleColor: CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
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
              ),
              Positioned(
                left: 0.0,
                child: Icon(
                  Icons.online_prediction_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
