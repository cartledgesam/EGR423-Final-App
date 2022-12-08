import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './profile_screen.dart';
import '../widgets/auth/posts.dart';
import '../widgets/auth/real_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with ChangeNotifier {
  var _loadImage;
  var _pickedImage;

  @override
  void initState() {
    _loadPhoto();
    super.initState();
  }

// I want this to rebuild so I need notifyListeners to be called from another class
  void setImage(File pickedImage, BuildContext ctx) {
    _pickedImage = pickedImage;
    Navigator.pop(ctx);
    notifyListeners();
  }

  Future<void> _loadPhoto() async {
    // every time this class is initialized it needs to check
    // the database to see if this uer has an image...
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userData['image_url'] != null) {
      setState(() {
        _loadImage = NetworkImage(userData['image_url']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var imageStr;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'SuperReal.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
            // child: CircleAvatar(
            //   backgroundImage: _loadImage ??
            //       (_pickedImage != null ? FileImage(_pickedImage) : null),
            //   backgroundColor: Colors.white,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (ctx, snapShot) {
                final chatDocs = snapShot.data.docs;
                for (var i = 0; i < chatDocs.length; i++) {
                  if (chatDocs[i]['userId'] == user.uid) {
                    imageStr = chatDocs[i]['image_url'];
                  }
                }
                return CircleAvatar(
                  backgroundColor: imageStr == null ? Colors.white : null,
                  child: imageStr == null
                      ? Icon(
                          Icons.person,
                          color: Colors.black,
                        )
                      : null,
                  backgroundImage:
                      imageStr != null ? NetworkImage(imageStr) : null,
                );
                // return imageStr == null
                //     ? Icon(
                //         // if user image is null
                //         Icons.person,
                //         color: Colors.black,
                //       )
                //     : CircleAvatar(
                //         backgroundImage: NetworkImage(imageStr),
                //       );
              },
            ),
            // child: _loadImage == null && _pickedImage == null
            //     ? const Icon(
            //         Icons.person,
            //         color: Colors.black,
            //       )
            //     : null,
          ),
          // ),
        ],
      ),
      drawer: RealDrawer(),
      // ), // add your own drawer
      body: Container(
        //SingleChildScrollView(
        //child: Center(
        child: Column(
          children: <Widget>[
            Expanded(child: Posts()),
          ],
        ),
      ),
    );
  }
}
