import 'dart:async';
import 'dart:ui';
import 'package:_99ads/providers/product_provider.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import 'Chat/chat_conversation_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);
  static const String id = 'product-details-screen';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;
  int _index = 0;
  final FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');
  bool _isLiked = false;
  List fav = [];
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  _mapLauncher(lattitude, logitude) async {
    final avilableMaps = await launcher.MapLauncher.installedMaps;

    await avilableMaps.first.showMarker(
      coords: launcher.Coords(lattitude, logitude),
      title: "Seller Locations is here",
    );
  }

  createChatRoom(ProductProvider _provider) {
    //we need some data to store in chat room
    Map product = {
      'productId': _provider.productData.id,
      'productImage': _provider.productData['images'][0], //only first images
      'price': _provider.productData['price'],
      'title': _provider.productData['title'],
      'seller': _provider.productData['sellerUid'],
    };

    List<String> users = [
      _provider.sellerData['uid'], //seller
      _service.user!.uid //buyer
    ];

    //I think better we will use both user uid and product ID
    String chatRoomId =
        '${_provider.sellerData['uid']}.${_service.user!.uid}.${_provider.productData.id}';
    //now lerts create a total data to save in firestore

    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'read': false,
      'product': product,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch
    };

    _service.createChatRoom(
      chatData: chatData,
    );

    //after create chatroom it should create a chat room to chat
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChatConversations(chatRoomId),
      ),
    );
  }

  getFavourites(_productProvider) {
    _service.products.doc(_productProvider.productData.id).get().then((value) {
      setState(() {
        fav = value["favourites"];
      });
      if (fav.contains(_service.user?.uid)) {
        setState(() {
          _isLiked = true;
        });
      } else {
        setState(() {
          _isLiked = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var _productProvider = Provider.of<ProductProvider>(context);
    getFavourites(_productProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    var data = _productProvider.productData;
    var sellerdata = _productProvider.sellerData;
    var _price = int.parse(data['price']);
    String price = _format.format(_price);
    String km = "";
    if (data['category'] == 'Cars') {
      var _km = int.parse(data['kmDrive']);
      km = _format.format(_km);
    }

    var date = data['postedat'].toDate();
    var _formatedDate = DateFormat.yMMMd().format(date);

    _callSeller(number) {
      launch(number);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
              });
              _service.updateFavorite(context, _isLiked, data.id);
            },
            icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border_outlined),
            color: _isLiked ? Colors.red : Colors.black,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.grey.shade300,
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Loading your Ad')
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.grey.shade400),
                                imageProvider:
                                    NetworkImage(data['images'][_index]),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data['images'].length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _index = i;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          child:
                                              Image.network(data['images'][i]),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _loading
                    ? Container()
                    : Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10),
                                    child: Text(
                                      data['title'].toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  data['category'] == 'Cars'
                                      ? Text('(${data['year']})')
                                      : const Text(''),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                '\$$price',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (data['category'] == 'Cars')
                                Container(
                                  color: Colors.grey.shade300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.filter_alt_outlined,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  data['fuel'],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.av_timer_outlined,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  km,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.account_tree_outlined,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  data['transmission'],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.person_outline,
                                              size: 12,
                                            ),
                                            const SizedBox(
                                              width: 1,
                                            ),
                                            Text(
                                              data['noOfOwners'],
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {},
                                              style: const ButtonStyle(
                                                  alignment: Alignment.center),
                                              icon: const Icon(
                                                Icons.location_on_outlined,
                                                size: 12,
                                                color: Colors.black,
                                              ),
                                              label: Text(
                                                sellerdata['address'],
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('POSTED DATE'),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(_formatedDate)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (data['category'] ==
                                                  'Mobile & Laptops' ||
                                              data['category'] == 'Cars')
                                            Text('Brand: ${data['brand']}'),
                                          if (data['category'] != 'Cars')
                                            Text(
                                                "Type: ${data['subcategory']}"),
                                          if (data['category'] == 'Properties')
                                            Text('Status: ${data['status']}'),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              'Details: ${data['description']}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 40,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue.shade50,
                                  radius: 38,
                                  child: Icon(
                                    CupertinoIcons.person_alt,
                                    color: Colors.red.shade300,
                                    size: 60,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    _productProvider
                                        .sellerData['contactDetails']['name']
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    "See Profile",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.arrow_forward_ios,
                                        size: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          const Text(
                            "Ad Posted at",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                Center(
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            sellerdata["location"]["lattitude"],
                                            sellerdata["location"]["logitude"]),
                                        zoom: 15),
                                    mapType: MapType.normal,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 35,
                                  ),
                                ),
                                const Center(
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                                Positioned(
                                  right: 4.0,
                                  top: 4.0,
                                  child: Material(
                                    elevation: 4,
                                    shape:
                                        Border.all(color: Colors.grey.shade300),
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.alt_route_outlined),
                                      onPressed: () {
                                        _mapLauncher(
                                            sellerdata["location"]["lattitude"],
                                            sellerdata["location"]["logitude"]);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ad ID:${data['postedat'].seconds}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.report_problem,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    "REPORT THIS AD",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {},
                                ),
                              ]),
                          const SizedBox(
                            height: 60,
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _productProvider.productData["sellerUid"] == _service.user!.uid
              ? Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      createChatRoom(_productProvider);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.edit,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Edit Product")
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          createChatRoom(_productProvider);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              CupertinoIcons.chat_bubble,
                              size: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Chat ")
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          _callSeller(
                              "tel:${sellerdata['contactDetails']['contactMobile']}");
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              CupertinoIcons.phone,
                              size: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Call")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
