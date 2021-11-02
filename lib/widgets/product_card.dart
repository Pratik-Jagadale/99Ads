import 'package:_99ads/providers/product_provider.dart';
import 'package:_99ads/screens/product_details_screen.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
    required String formattedPrice,
  })  : _formattedPrice = formattedPrice,
        super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _format = NumberFormat('##,##,##0');
  final FirebaseService _service = FirebaseService();
  late DocumentSnapshot sellerDetails;
  String address = "";
  bool _isLiked = false;
  List fav = [];
  String _kmFormatted(km) {
    var _km = int.parse(km);
    var _formattedkm = _format.format(_km);
    return _formattedkm;
  }

  @override
  void initState() {
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
    getFavourites();
    super.initState();
  }

  getFavourites() {
    _service.products.doc(widget.data.id).get().then((value) {
      setState(() {
        fav = value["favourites"];
      });
      if (fav.contains(_service.user?.uid)) {
        setState(() {
          _isLiked = true;
        });
      } else {
        setState(() {
          _isLiked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return InkWell(
      onTap: () {
        _provider.getProductDetails(widget.data);
        _provider.getSellerDetails(sellerDetails);
        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Image.network(
                          widget.data['images'][0],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget._formattedPrice,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      widget.data['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    widget.data['category'] == 'Cars'
                        ? Text(
                            '${widget.data['year']}-${_kmFormatted(widget.data['kmDrive'])} km')
                        : const Text(''),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Row(children: [
                  const Icon(
                    Icons.location_pin,
                    color: Colors.black38,
                  ),
                  Flexible(
                    child: Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ]),
              ],
            ),
            Positioned(
              right: 0.0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                  _service.updateFavorite(context, _isLiked, widget.data.id);
                },
                icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border_outlined),
                color: _isLiked ? Colors.red : Colors.black,
              ),
            )
          ]),
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
