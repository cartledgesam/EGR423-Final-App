import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends StatelessWidget {
  Post(this.description, this.username, this.imageURL, this.userId, {this.key});
//this.documentId

  final Key key;
  final String username;
  final String imageURL;
  final String description;
  final String userId;
  // final String documentId;
  //final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(0),
              ),
            ),
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // FutureBuilder(
                //   future: FirebaseFirestore.instance
                //       .collection('posts')
                //       .doc(userId)
                //       .get(),
                //   builder: (context, snapshot) {
                //     print(snapshot.data['userId']);
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       print("waiting");
                //       return const Text('Loading...');
                //     }
                //     return Text(
                //       snapshot.data['description'],
                //       //description,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, color: Colors.white),
                //     );
                //   },
                // ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  //textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      )
    ]);
  }
}
