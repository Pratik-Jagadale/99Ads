import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/screens/SellItems/product_by_category_screen.dart';
import 'package:_99ads/screens/category_screen/category_list.dart';
import 'package:_99ads/screens/category_screen/subcat_screen.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<QuerySnapshot>(
        future: _service.categories
            .orderBy(
              'sortId',
              descending: true,
            )
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SizedBox(
            height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Categories')),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CategoryListScreen.id);
                      },
                      child: Row(
                        children: const [
                          Text(
                            'See all',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (doc['subCat'] == null) {
                              if (doc['catName'] == 'Cars') {
                                _catProvider.getCategory(doc['catName']);
                                _catProvider.getCatSnapShot(doc);
                                Navigator.pushNamed(
                                    context, ProductByCategory.id);
                              }
                            } else {
                              Navigator.pushNamed(
                                context,
                                SubCatList.id,
                                arguments: doc,
                              );
                            }
                          },
                          child: SizedBox(
                            width: 60,
                            height: 50,
                            child: Column(
                              children: [
                                Image.network(doc['image']),
                                Flexible(
                                  child: Text(
                                    doc['catName'].toUpperCase(),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
