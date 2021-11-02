import 'package:_99ads/screens/Chat/chat_card.dart';
import 'package:_99ads/screens/SellItems/seller_category_list.dart';
import 'package:_99ads/screens/category_screen/category_list.dart';
import 'package:_99ads/screens/main_screen.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  static const String id = "chat-screen";
  ChatScreen({Key? key}) : super(key: key);
  final FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            title: Text(
              "Chats",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            bottom: TabBar(
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              labelColor: Theme.of(context).primaryColor,
              indicatorWeight: 4,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(
                  text: 'ALL',
                ),
                Tab(
                  text: 'BUYING',
                ),
                Tab(
                  text: 'SELLING',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }

                  if (snapshot.data?.docs.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("No Chats started yet"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            child: const Text('Contact Seller'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                    );
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user?.uid)
                    .where("product.seller", isNotEqualTo: _service.user?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }
                  if (snapshot.data?.docs.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("No Ads buying yet"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            child: const Text('Buy products'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user?.uid)
                    .where("product.seller", isEqualTo: _service.user?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
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
                              Navigator.pushNamed(context, SellerCategory.id);
                            },
                            child: const Text('Add products'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ],
          )),
    );
  }
}
