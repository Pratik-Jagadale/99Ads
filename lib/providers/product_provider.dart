import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  late DocumentSnapshot productData;
  late DocumentSnapshot sellerData;

  getProductDetails(details) {
    productData = details;
    notifyListeners();
  }

  getSellerDetails(details) {
    sellerData = details;
    notifyListeners();
  }
}
