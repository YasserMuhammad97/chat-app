import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data.documents;
        final curUserId = FirebaseAuth.instance.currentUser.uid;

        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['username'],
            chatDocs[index]['userImage'],
            chatDocs[index]['userId'] == curUserId,
            key: ValueKey(chatDocs[index].documentID),
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
