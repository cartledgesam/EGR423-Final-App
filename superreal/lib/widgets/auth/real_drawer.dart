import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './user_tile.dart';

class RealDrawer extends StatefulWidget {
  const RealDrawer({Key key}) : super(key: key);

  @override
  State<RealDrawer> createState() => _RealDrawerState();
}

class _RealDrawerState extends State<RealDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: const Text('Add Friends'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
                onTap: (() => Navigator.pop(context)),
                child: Icon(Icons.arrow_forward))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .snapshots(), // need to get them at top of page
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.docs;
            return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => UserTile(
                image: chatDocs[index]['image_url'],
                name: chatDocs[index]['username'],
                isFriend: false,
              ),
            );
          },
        ), //listview of the users
      ),
      // next in the drawer put the list of users (avatar, name, add button)
    );
  }
}
