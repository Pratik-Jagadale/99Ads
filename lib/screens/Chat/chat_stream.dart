import 'package:_99ads/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:intl/intl.dart';

class ChatStream extends StatefulWidget {
  final String chatRoomId;
  const ChatStream(this.chatRoomId, {Key? key}) : super(key: key);
  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  final FirebaseService _service = FirebaseService();
  Stream<QuerySnapshot>? chatMessageStream;
  DocumentSnapshot? chatDoc;
  final _format = NumberFormat('##,##,##0');
  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    _service.messages.doc(widget.chatRoomId).get().then((value) {
      setState(() {
        chatDoc = value;
      });
    });
    super.initState();
  }

  String _priceFormatted(price) {
    var _price = int.parse(price);
    var _formattedprice = _format.format(_price);
    return _formattedprice;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return snapshot.hasData
            ? Column(
                children: [
                  if (chatDoc != null)
                    ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        child:
                            Image.network(chatDoc?['product']['productImage']),
                      ),
                      title: Text(chatDoc?['product']['title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "\$ ${_priceFormatted(chatDoc?['product']['price'])}"),
                          const SizedBox(
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade300,
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            String sentBy =
                                snapshot.data?.docs[index]['sentBy'];
                            String me = _service.user!.uid;
                            String lastChatDate;
                            var _date = DateFormat.yMMMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    snapshot.data?.docs[index]['time']));
                            var _today = DateFormat.yMMMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    DateTime.now().microsecondsSinceEpoch));

                            if (_date == _today) {
                              lastChatDate = DateFormat('hh:mm').format(
                                  DateTime.fromMicrosecondsSinceEpoch(
                                      snapshot.data?.docs[index]['time']));
                            } else {
                              lastChatDate = _date.toString();
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ChatBubble(
                                    alignment: sentBy == me
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    backGroundColor: sentBy == me
                                        ? Theme.of(context).primaryColor
                                        : Colors.black45,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                      ),
                                      child: Text(
                                        snapshot.data?.docs[index]['message'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    clipper: ChatBubbleClipper2(
                                        type: sentBy == me
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Align(
                                    alignment: sentBy == me
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      lastChatDate,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }
}
