import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'post.dart';

class Posts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint(user.toString());

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final postDocs = postSnapshot.data.docs;
          return ListView.builder(
            reverse: true,
            itemCount: postDocs.length,
            itemBuilder: (ctx, index) => Post(
              postDocs[index]['description'],
              postDocs[index]['userId'],
              postDocs[index].documentID,
              //chatDocs[index]['userId'] == futureSnapshot.data.uid,
              key: ValueKey(postDocs[index].documentID),
            ),
          );
        });
  }
}
