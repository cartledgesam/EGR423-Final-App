import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends StatelessWidget {
  Post(this.description, this.username, this.imageURL, this.userId, {this.key});

  final Key key;
  final String username;
  final String imageURL;
  final String description;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
              child: Hero(
            tag: username,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/loading.png'),
              image: NetworkImage(imageURL),
              fit: BoxFit.cover,
            ),
          )),
        ));
  }
}
