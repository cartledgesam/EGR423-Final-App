import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/proifile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _pickedImage;

  // called when user chooses to take picture from their camera
  Future<void> _displayCamera() async {
    final picker = ImagePicker();
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImageFile == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    _pop(context);
  }

  // called when user decides to choose image from gallery
  Future<void> _showPhotoGallery() async {
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
  }

  void _pop(BuildContext context) {
    Navigator.pop(context);
  }

  void _showImagePrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
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
          if (_pickedImage != null)
            ListTile(
              leading: Icon(Icons.delete),
              title: const Text('Delete Photo'),
              onTap: () => setState(() {
                _pickedImage = null;
                _pop(context);
              }),
            ),
        ],
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
                Navigator.of(context).pop();
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
                backgroundImage:
                    _pickedImage != null ? FileImage(_pickedImage) : null,
                backgroundColor: Colors.grey,
                radius: 75,
                child: _pickedImage == null
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
