import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  DocumentSnapshot? doc;
  DocumentSnapshot? userDetails;
  String selectedCategory = "";
  String selectedSubCategory = "";
  List<String> urlList = [];
  Map<String, dynamic> datatoDatabse = {};
  final FirebaseService _service = FirebaseService();

  addurl(String url) {
    urlList.add(url);
    notifyListeners();
  }

  getCategory(selectedCat) {
    selectedCategory = selectedCat;
    notifyListeners();
  }

  getSubCategory(selectedSubCat) {
    selectedSubCategory = selectedSubCat;
    notifyListeners();
  }

  getCatSnapShot(snapshot) {
    doc = snapshot;
    notifyListeners();
  }

  getData(data) {
    datatoDatabse = data;
    notifyListeners();
  }

  getUserDetails() {
    _service.getUserData().then((value) {
      userDetails = value;
      notifyListeners();
    });
  }

  clearData() {
    urlList = [];
    datatoDatabse = {};
    notifyListeners();
  }

  clearSelectedCat() {
    selectedCategory = "";
    selectedSubCategory = "";
    notifyListeners();
  }
}
