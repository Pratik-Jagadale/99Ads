import 'package:_99ads/providers/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product_list.dart';

class ProductByCategory extends StatelessWidget {
  static const String id = 'product-by-cat';

  const ProductByCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
   
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedCategory == 'Cars'
              ? 'Cars'
              : '${_catProvider.selectedCategory} > ${_catProvider.selectedSubCategory}',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: const SingleChildScrollView(child: ProductList(true)),
    );
  }
}
