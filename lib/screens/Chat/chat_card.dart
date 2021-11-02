import 'package:_99ads/screens/Chat/chat_conversation_screen.dart';
import 'package:_99ads/screens/Chat/pop_up_menu_model.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;

  const ChatCard(this.chatData, {Key? key}) : super(key: key);
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final FirebaseService _service = FirebaseService();
  DocumentSnapshot? doc;

  String _lastChatDate = "";

  @override
  void initState() {
    getChatTime();
    getProductDetail();
    super.initState();
  }

  getProductDetail() {
    _service
        .getProductDetails(widget.chatData['product']["productId"])
        .then((value) {
      setState(() {
        doc = value;
      });
    });
  }

  getChatTime() {
    var _date = DateFormat.yMMMd().format(
      DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']),
    );

    var _today = DateFormat.yMMMd().format(
      DateTime.fromMicrosecondsSinceEpoch(
          DateTime.now().microsecondsSinceEpoch),
    );

    if (_date == _today) {
      setState(() {
        _lastChatDate = 'Today';
      });
    } else {
      setState(() {
        _lastChatDate = _date.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return doc != null
        ? Container(
            child: Stack(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                    onTap: () {
                      _service.messages
                          .doc(widget.chatData['chatRoomId'])
                          .update({'read': true});
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ChatConversations(
                                    widget.chatData['chatRoomId']),
                          ));
                    },
                    leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.network(doc?['images'][0]),
                    ),
                    title: Text(
                      doc?['title'],
                      style: TextStyle(
                          fontWeight: widget.chatData['read'] == false
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc?['description'],
                          maxLines: 1,
                        ),
                        if (widget.chatData['lastChat'] != null)
                          Text(
                            widget.chatData['lastChat'],
                            maxLines: 1,
                            style: const TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                    trailing: _service.popUpMenu(context, widget.chatData)),
                Positioned(
                  right: 10.0,
                  top: 10.0,
                  child: Text(_lastChatDate),
                )
              ],
            ),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
          )
        : Container();
  }
}
