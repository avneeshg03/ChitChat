import 'package:chitchat/screens/splash_screen.dart';
import 'package:chitchat/widgets/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatsnapshot) {
              if (chatsnapshot.connectionState == ConnectionState.waiting)
                return SplashScreen();
              final chatDocs = chatsnapshot.data?.docs;
              return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs?.length,
                  itemBuilder: (ctx, index) => MessageBubble(
                      chatDocs![index]['text'],
                      chatDocs[index]['userId'] == futureSnapshot.data.uid));
            });
      },
    );
  }
}
