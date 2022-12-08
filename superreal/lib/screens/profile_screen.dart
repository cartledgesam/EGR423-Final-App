import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import './home_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/proifile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _pickedImage;
  NetworkImage _loadImage;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadPhoto();
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

  // called when user chooses to take picture from their camera
  Future<void> _displayCamera() async {
    final user = FirebaseAuth.instance.currentUser;
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
        .collection('users')
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'username': userData['username'],
        'email': userData['email'],
        'image_url': url,
        'userId': user.uid,
      },
    );
  }

  // called when user decides to choose image from gallery
  Future<void> _showPhotoGallery() async {
    final user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
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
        .collection('users')
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'username': userData['username'],
        'email': userData['email'],
        'image_url': url,
        'userId': user.uid,
      },
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
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose Image from Camera Roll'),
              onTap: _showPhotoGallery,
            ),
            // show delete icon if image is not null
            if (_pickedImage != null || _loadImage != null)
              ListTile(
                leading: Icon(Icons.delete),
                title: const Text('Delete Photo'),
                onTap: () => setState(() {
                  _pickedImage = null;
                  _loadImage = null;
                  // removes image from database
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(_user.uid)
                      .update(
                    {
                      'image_url': null, // FieldValue.delete(),
                    },
                  );
                  _pop(context);
                }),
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
          'Profile',
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
            height: 10,
          ),
          Center(
            child: GestureDetector(
              // make it so that we can remove pics too
              onTap: () => _showImagePrompt(context),
              child: CircleAvatar(
                backgroundImage: _loadImage ??
                    (_pickedImage != null ? FileImage(_pickedImage) : null),
                backgroundColor: Colors.grey,
                radius: 75,
                child: _pickedImage == null &&
                        _loadImage ==
                            null // use progress indicator if pic is loading
                    ? const Icon(
                        Icons.camera_alt_rounded,
                        size: 50,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
