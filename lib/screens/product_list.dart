import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:_99ads/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final bool proScreen;
  // ignore: use_key_in_widget_constructors
  const ProductList(this.proScreen);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    final _format = NumberFormat('##,##,##0');

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: !proScreen
              ? _service.products.orderBy('postedat').get()
              : _catProvider.selectedCategory == 'Cars'
                  ? _service.products
                      .orderBy('postedat')
                      .where('category',
                          isEqualTo: _catProvider.selectedCategory)
                      .get()
                  : _service.products
                      .orderBy('postedat')
                      .where('subcategory',
                          isEqualTo: _catProvider.selectedSubCategory)
                      .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140.0, right: 140.0),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.grey.shade100,
                ),
              );
            }

            // ignore: prefer_is_empty
            if (snapshot.data?.docs.length == 0) {
              return const Center(
                child: Text("No Products added under selected category"),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proScreen == false)
                  const SizedBox(
                    height: 56,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Fresh Recommendations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                GridView.builder(
                  itemCount: snapshot.data!.size,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int i) {
                    var data = snapshot.data!.docs[i];
                    var _price = int.parse(data['price']);
                    String _formattedPrice = '\$${_format.format(_price)}';

                    return ProductCard(
                        data: data, formattedPrice: _formattedPrice);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
