import 'package:_99ads/screens/SellItems/seller_category_list.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:_99ads/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,##0');
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: const Text(
              'My Ads',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              indicatorWeight: 5,
              tabs: [
                Tab(
                  child: Text(
                    "My Ads",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                Tab(
                  child: Text(
                    "Favorite",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: FutureBuilder<QuerySnapshot>(
                      future: _service.products
                          .where('sellerUid', isEqualTo: _service.user!.uid)
                          .orderBy('postedat')
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 140.0, right: 140.0),
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              backgroundColor: Colors.grey.shade100,
                            ),
                          );
                        }

                        if (snapshot.data?.docs.length == 0) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("No Ads given yet"),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SellerCategory.id);
                                  },
                                  child: const Text('Add products'),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor)),
                                )
                              ],
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              itemCount: snapshot.data!.size,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 2 / 2.6,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 10),
                              itemBuilder: (BuildContext context, int i) {
                                var data = snapshot.data!.docs[i];
                                var _price = int.parse(data['price']);
                                String _formattedPrice =
                                    '\$${_format.format(_price)}';

                                return ProductCard(
                                    data: data,
                                    formattedPrice: _formattedPrice);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _service.products
                          .where('favourites',
                              arrayContains: _service.user?.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 140.0, right: 140.0),
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                              backgroundColor: Colors.grey.shade100,
                            ),
                          );
                        }

                        if (snapshot.data?.docs.length == 0) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("No Ads given yet"),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SellerCategory.id);
                                  },
                                  child: const Text('Add products'),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor)),
                                )
                              ],
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              itemCount: snapshot.data!.size,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 2 / 2.6,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 10),
                              itemBuilder: (BuildContext context, int i) {
                                var data = snapshot.data!.docs[i];
                                var _price = int.parse(data['price']);
                                String _formattedPrice =
                                    '\$${_format.format(_price)}';

                                return ProductCard(
                                    data: data,
                                    formattedPrice: _formattedPrice);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
