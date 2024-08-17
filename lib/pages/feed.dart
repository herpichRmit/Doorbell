import 'dart:ffi';
import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/pages/popupView.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/debug.dart';
import 'startNeighbourhood.dart';

import 'package:doorbell/pages/debug.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../components/houseButton.dart';
import '../components/post.dart';

import '../model/post.dart';


//import 'package:cloud_firestore/cloud_firestore.dart';


class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();

}

class _FeedPageState extends State<FeedPage> {

  // Define this stream before the build statement
  //final Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
  //  .collection('posts') // Choose which collection we want to read
  //  .orderBy("date", descending: true) // OPTIONAL: Set an order
  //  .snapshots(); // Get notified of any changes to the collection

  var user = FirebaseAuth.instance.currentUser;

  bool _checkUserId(String id) {
    if (user?.uid == id) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32), // 16 is apple HIGs standard, lets do 32 for onboarding screens.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                GestureDetector(
                    child: Image.asset(
                      "assets/images/icons/Chevron-Left.png",
                      width: 32,
                      height: 32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                ),
                Image.asset(
                  "assets/images/houses/house1.png",
                  height: 100,
                ),
                SizedBox(height: 120, width: 44,)
              ],),

              SizedBox(height: 32,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Melissa and Darren's House",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.23,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12,),
              
              Column(children: [
                PostCard(
                  post: Post(id: "1234", avatar: Avatar(color: CupertinoColors.systemIndigo, imagePath: "assets/images/avatars/avatar8.png", size: 44,), title: "title", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin volutpat consectetur tellus, ac congue enim tincidunt eu. Etiam non est facilisis, posuere sapien in, finibus lectus.", images: List.empty(), timestamp: DateTime.now(), readBy: List.empty(), userId: '1234'), 
                  onPressed: () => _showPostPopupSheet(context, isEditiable: _checkUserId("1234"), isNew: false), // if user id == post.userId
                ),
                SizedBox(height: 8,),
                Button(
                  icon: Image.asset("assets/images/icons/plusfill.png"),
                  text: 'Add Post',
                  onPressed: () => _showPostPopupSheet(context, isEditiable: true, isNew: true),
                ),
                SizedBox(height: 8,),
                Button(
                  text: 'debug',
                  onPressed: () async {

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DebugPage())
                    );
                  },
                ),
              ],),

            ],
          ),
        ),
      ),
    );
  }

  void _showPostPopupSheet(BuildContext context, {required bool isEditiable, required bool isNew}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostPopupSheet(
          title: 'Post Title',
          timestamp: DateTime.now(),
          description: 'This is a detailed description of the post.',
          imageUrls: [],
          isEditiable: isEditiable,
          isNew: isNew,
        );
      },
    );
  }

}