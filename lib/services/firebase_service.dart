import 'package:_99ads/screens/Chat/pop_up_menu_model.dart';
import 'package:_99ads/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> updateUser(Map<String, dynamic> data, context) {
    return users
        .doc(user!.uid)
        .update(data)
        .then(
          (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false),
        )
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getSellerData(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot> getProductDetails(id) async {
    DocumentSnapshot doc = await products.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}) {
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {});
  }

  createChat(String chatRoomId, message) {
    messages
        .doc(chatRoomId)
        .collection("chats")
        .add(message)
        .catchError((e) {});

    messages.doc(chatRoomId).update({
      'lastChat': message["message"],
      'lastChatTime': message["time"],
      'read': false
    });
  }

  getChat(id) async {
    return messages.doc(id).collection("chats").orderBy('time').snapshots();
  }

  deleteChat(id) async {
    return messages.doc(id).delete();
  }

  updateFavorite(context, _isLiked, productId) {
    if (_isLiked) {
      products.doc(productId).update({
        "favourites": FieldValue.arrayUnion([user?.uid])
      });
    } else {
      products.doc(productId).update({
        "favourites": FieldValue.arrayRemove([user?.uid])
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isLiked ? 'Added to my favourite ' : "Removed from my favourite"),
      ),
    );
  }

  popUpMenu(context, chatData) {
    List<PopUpMenuModel> menuItems = [
      PopUpMenuModel('Delete Chat', Icons.delete),
      PopUpMenuModel('Mark as Sold', Icons.done),
    ];
    CustomPopupMenuController _controller = CustomPopupMenuController();
    return CustomPopupMenu(
      child: Container(
        child: const Icon(Icons.more_vert_sharp, color: Colors.black),
        padding: const EdgeInsets.all(20),
      ),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (item.title == 'Delete Chat') {
                          deleteChat(chatData["chatRoomId"]);
                          _controller.hideMenu();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chat Deleted'),
                            ),
                          );
                        } else {}
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              item.icon,
                              size: 15,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: _controller,
    );
  }
}
