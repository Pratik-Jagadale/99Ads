import 'package:_99ads/providers/product_provider.dart';
import 'package:_99ads/screens/location_screen.dart';
import 'package:_99ads/screens/login_screen.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:_99ads/services/search_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final FirebaseService _service = FirebaseService();
  // ignore: non_constant_identifier_names
  final SearchService _search_service = SearchService();
  static List<Products> products = [];

  String sellerAddress = "";
  DocumentSnapshot? sellerDetails;
  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docs.forEach((doc) {
        setState(() {
          try {
            products.add(
              Products(
                doc,
                doc['description'],
                doc["price"],
                doc["subcategory"],
                doc["title"],
                doc["category"],
                doc['postedat'],
              ),
            );
            // getSellerAddress(doc["sellerUid"]);
          // ignore: empty_catches
          } catch (e) {
        
          }
        });
      });
    });
    super.initState();
  }

  // getSellerAddress(Uid) {
  //   _service.getSellerData(Uid).then((address) {
  //     print(address.data());
  //     print("\n");
  //     sellerAddress = address["address"];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return appBar("Something went wrong", context, false, _provider);
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return appBar("", context, true, _provider);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return appBar(data["address"], context, false, _provider);
        }

        return appBar('loading', context, false, _provider);
      },
    );
  }

  Widget appBar(address, context, guest, _provider) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      title: InkWell(
        onTap: () {
          guest
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('First Login you are guest now'),
                  ),
                )
              : Navigator.pushNamed(context, Location_screen.id);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Text(
                  address,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 18,
                ),
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  child: guest ? const Text("Login") : const Text("sign out"),
                )
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onTap: () {
                          _search_service.search(context, products,
                              sellerAddress, _provider);
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          labelText: "Find Cars, Mobiles and many more",
                          labelStyle: const TextStyle(
                            fontSize: 12,
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.notifications_none),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
