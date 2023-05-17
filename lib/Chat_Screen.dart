

import 'package:chat/Models.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {

  final String email;

  ChatScreen({required this.email});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages =
  FirebaseFirestore.instance.collection('messages');
  final controller = ScrollController();



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('Time', descending: true).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Model> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Model.fromJson(snapshot.data!.docs[i]));
            }
            return body(messagesList);
          } else {
            return Text('Loading');
          }
        });
  }

  Widget body(List<Model> messagesList) => Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF2B475E),
      title: Text('Chat App'),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            controller: controller,
            itemCount: messagesList.length,
            itemBuilder: (BuildContext context, int index) {
              return messagesList[index].id == email ?
                ChatBublefromme(messagesList , index) :ChatBublefromfriend(messagesList , index) ;

            },
          ),
        ),
      MessageBar(
              onSend: (message) {
              messages.add({
              'message': message,
              'Time': DateTime.now(),
                'id' : email,
              });
              controller.animateTo(
              0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              );},

  actions: [
            InkWell(
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
              onTap: () {},
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: InkWell(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.green,
                  size: 24,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    ),
  );


  Widget ChatBublefromme(List<Model> messagesList , int index) => Padding(
    padding: const EdgeInsets.all(15.0),
    child: BubbleSpecialThree(
      text: messagesList[index].message,
      color: Color(0xFF2B475E),
      tail: true,
      isSender: false,
      textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16
      ),
    ),
  );



  Widget ChatBublefromfriend(List<Model> messagesList , int index) => Padding(
    padding: const EdgeInsets.all(15.0),
    child: BubbleSpecialThree(
      text: messagesList[index].message,
      color: Color(0xff006D84),
      tail: true,

      textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16
      ),
    ),
  );

}



