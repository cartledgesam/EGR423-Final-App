import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './home_screen.dart';

class PostScreen extends StatefulWidget {
  static const routeName = '/post-screen';

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var _pickedImage;
  NetworkImage _loadImage;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  // called when user chooses to take picture from their camera
  Future<void> _displayCamera() async {
    final user = await FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedImageFile == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    _pop(context);
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(user.uid + '.jpg');

    await ref.putFile(_pickedImage);

    final url = await ref.getDownloadURL();

    final userData = await FirebaseFirestore.instance
        .collection('posts')
        .doc(user.uid)
        .get();

    var myData = {
      'imageURL': url,
      'username': "test",
      'userId': user.uid,
      'description': "test"
    };
    await FirebaseFirestore.instance.collection('posts').add(myData);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _pop(BuildContext context) {
    Navigator.pop(context);
  }

  void _showImagePrompt(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Take Picture with Camera'),
              onTap: _displayCamera,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          DropdownButton(
            underline: const SizedBox(),
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 270,
          ),
          const Text(
            'Post a picture to see what your friends posted!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: GestureDetector(
              onTap: () => _showImagePrompt(context),
              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 75,
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 50,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
