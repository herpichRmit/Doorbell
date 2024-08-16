import 'dart:ffi';
import 'package:doorbell/components/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/debug.dart';
import 'package:doorbell/pages/feed.dart';
import 'startNeighbourhood.dart';

import 'package:doorbell/pages/debug.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../components/houseButton.dart';



//import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  // Define this stream before the build statement
  //final Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
  //  .collection('posts') // Choose which collection we want to read
  //  .orderBy("date", descending: true) // OPTIONAL: Set an order
  //  .snapshots(); // Get notified of any changes to the collection


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32), // 16 is apple HIGs standard, lets do 32 for onboarding screens.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              
              Row(
                children: [
                  HouseButton(imagePath: 'assets/images/houses/house1.png', onPressed: () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DebugPage())
                    );
                   },),
                  Spacer(),
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  HouseButton(imagePath: 'assets/images/houses/house3.png', onPressed: () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FeedPage())
                    );
                   },),
                ],
              ),

              Row(
                children: [
                  HouseButton(imagePath: 'assets/images/houses/house2.png', onPressed: () {  },),
                  Spacer(),
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  HouseButton(imagePath: 'assets/images/houses/house4.png', onPressed: () {  },),
                ],
              ),

              
              SizedBox(height: 48,)

              
              /*
              Button(
                text: 'debug',
                onPressed: () async {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DebugPage())
                  );
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }

}