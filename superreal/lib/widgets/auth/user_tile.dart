import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  String image;
  String name;
  bool isFriend;

  UserTile({
    this.image,
    this.name,
    this.isFriend,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage:
                widget.image == null ? null : NetworkImage(widget.image),
            radius: 40,
            child: widget.image == null
                ? const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  )
                : null,
          ),
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                widget.isFriend = !widget.isFriend;
              });
            },
            icon: Icon(widget.isFriend ? Icons.check : Icons.add),
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
