import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/screens/SellItems/product_by_category_screen.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCatList extends StatelessWidget {
  static const String id = 'subCat-screen';

  const SubCatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? args = ModalRoute.of(context)!.settings.arguments
        as DocumentSnapshot<Object?>?;
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
        title: Text(
          args!['catName'],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _service.categories.doc(args.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = snapshot.data!['subCat'];

          _catProvider.getCategory(snapshot.data!["catName"]);
          _catProvider.getCatSnapShot(snapshot.data);
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ListTile(
                  onTap: () {
                    _catProvider.getSubCategory(data[index]);
                    // if (_catProvider.selectedCategory == "Mobile & Laptops") {
                    //   if (data[index] == "Mobile Phone") {}
                    // }
                    Navigator.pushNamed(context, ProductByCategory.id);
                  },
                  title: Text(
                    data[index],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
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
