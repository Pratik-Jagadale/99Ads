import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/screens/SellItems/product_by_category_screen.dart';
import 'package:_99ads/screens/category_screen/subcat_screen.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatelessWidget {
  static const String id = 'category-list-screen';

  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _service.categories.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var doc = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    if (doc['subCat'] == null) {
                      if (doc['catName'] == 'Cars') {
                        _catProvider.getCategory(doc['catName']);
                        _catProvider.getCatSnapShot(doc);
                        Navigator.pushNamed(context, ProductByCategory.id);
                      }
                    } else {
                      Navigator.pushNamed(
                        context,
                        SubCatList.id,
                        arguments: doc,
                      );
                    }
                  },
                  leading: Image.network(
                    doc['image'],
                    width: 40,
                  ),
                  title: Text(
                    doc['catName'],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
