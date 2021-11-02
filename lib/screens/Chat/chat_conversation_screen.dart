import 'package:_99ads/screens/Chat/chat_stream.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:flutter/material.dart';

class ChatConversations extends StatefulWidget {
  final String chatRoomId;
  // ignore: use_key_in_widget_constructors
  const ChatConversations(this.chatRoomId);

  @override
  _ChatConversations createState() => _ChatConversations();
}

class _ChatConversations extends State<ChatConversations> {
  final FirebaseService _service = FirebaseService();

  var chatMessageController = TextEditingController();
  bool _send = false;

  sendMessage() {
    if (chatMessageController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message': chatMessageController.text,
        'sentBy': _service.user?.uid,
        'time': DateTime.now().microsecondsSinceEpoch
      };

      _service.createChat(widget.chatRoomId, message);
      chatMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          _service.popUpMenu(context, widget.chatRoomId)
        ],
        shape: const Border(bottom: BorderSide(color: Colors.white)),
      ),
      body: Stack(
        children: [
          ChatStream(widget.chatRoomId),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade50)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatMessageController,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                          hintText: 'Type Message',
                          hintStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          border: InputBorder.none),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _send = true;
                          });
                        } else {
                          setState(() {
                            _send = false;
                          });
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          sendMessage();
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: _send,
                    child: IconButton(
                      icon: Icon(Icons.send,
                          color: Theme.of(context).primaryColor),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ), //Container
    ); //Scaffold
  }
}
