import 'package:_99ads/screens/product_details_screen.dart';
import 'package:_99ads/screens/product_list.dart';
import 'package:_99ads/services/firebase_service.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';

class Products {
  final String title, description, subCat, price, category;
  final Timestamp postedDate;
  final DocumentSnapshot document;
  Products(
    this.document,
    this.description,
    this.price,
    this.subCat,
    this.title,
    this.category,
    this.postedDate,
  );
}

class SearchService {
  final FirebaseService _service = FirebaseService();
  search(context, productList, address, provider) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
        items: productList,
        searchLabel: 'Search products',
        suggestion: const SingleChildScrollView(
          child: ProductList(true),
        ),
        failure: const Center(
          child: Text('No product found :)'),
        ),
        filter: (product) => [
          product.title,
          product.description,
          product.subCat,
          product.category
        ],
        builder: (product) {
          final _format = NumberFormat('##,##,##0');
          var _price = int.parse(product.price);
          String _formattedPrice = '\$ ${_format.format(_price)}';

          var date = product.postedDate.toDate();
          var _date = DateFormat.yMMMd().format(date);

          return InkWell(
            onTap: () {
              provider.getProductDetails(product.document);
              _service
                  .getSellerData(product.document["sellerUid"].toString())
                  .then((details) {
                provider.getSellerDetails(details);
              });

              Navigator.pushNamed(context, ProductDetailsScreen.id);
            },
            child: SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 120,
                        child: Image.network(product.document['images'][0]),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formattedPrice,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(product.title)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Posted at : $_date'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.black38,
                                  ),
                                  Flexible(
                                      child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 148,
                                    child: Text(
                                      address,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
