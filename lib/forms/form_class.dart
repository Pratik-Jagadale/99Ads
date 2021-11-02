import '/providers/cat_provider.dart';
import 'package:flutter/material.dart';

class FormClass {
  List accessories = ['Mobile', 'Tablets', 'Laptop', 'Computers'];

  List tabType = ['Ipads', 'samsung', 'Other Tablets'];

  List furnishing = ['Furnished', 'Semi-Furnished', 'Unfurnished'];

  List consStatus = ['New Launch', 'Ready to Move', 'Under Construction'];

  List apartmentType = ['Apartments', 'Farm Houses', 'Houses & Villas'];

  Widget appBar(CategoryProvider _provider) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(
        _provider.selectedSubCategory,
        style: const TextStyle(color: Colors.black),
      ), //Text
    ); //AppBar
  }
}
