import 'dart:ffi';
import 'package:doorbell/components/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/debug.dart';
import 'package:doorbell/pages/feed.dart';
import 'startNeighbourhood.dart';
import 'package:doorbell/pages/popupView.dart';
import 'package:doorbell/pages/doorbellNotification.dart';

import 'package:doorbell/pages/debug.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../components/houseButton.dart';
import 'package:doorbell/pages/help.dart';




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
          child: Stack(
            children: [
              Column(
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
                      },
                      avatars: [
                        Avatar(color: CupertinoColors.systemPink, imagePath: "assets/images/avatars/avatar1.png", size: 60),
                        Avatar(color: CupertinoColors.systemPink, imagePath: "assets/images/avatars/avatar1.png", size: 60),
                      ],
                      ),
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
                      },
                      avatars: [
                        Avatar(color: CupertinoColors.systemPink, imagePath: "assets/images/avatars/avatar1.png", size: 60),
                      ],
                      ),
                    ],
                  ),
              
                  Row(
                    children: [
                      HouseButton(imagePath: 'assets/images/houses/house2.png', onPressed: () {  }, avatars: [],),
                      Spacer(),
                    ],
                  ),
              
                  Row(
                    children: [
                      Spacer(),
                      HouseButton(imagePath: 'assets/images/houses/house4.png', onPressed: () {  }, avatars: [],),
                    ],
                  ),
              
                  
                  SizedBox(height: 48,),
                ],
              ),
              Row(
                children: [ 
                  Spacer(),
                  Column(
                    children: [
                      ElevatedButton(
                        child: Text('?',     
                          style: TextStyle(
                          fontSize: 20, // Text size
                          fontWeight: FontWeight.bold, // Bold text
                          color: CupertinoColors.systemGrey6, 
                          )
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => HelpPage())
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.systemGrey2, // TODO: link to notification object
                            shape: CircleBorder(), 
                            padding: EdgeInsets.all(12), 
                          )
                      ),
                  
                      SizedBox(height: 12),
                      
                      ElevatedButton(
                        child: Text('!',     
                          style: TextStyle(
                          fontSize: 20, // Text size
                          fontWeight: FontWeight.bold, // Bold text
                          color:CupertinoColors.systemGrey6, 
                          )
                        ),
                        onPressed: () => _showDoorbellPopupSheet(context, isEditiable: true, isNew: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CupertinoColors.systemGreen, // TODO: link to notification object
                          shape: CircleBorder(), 
                          padding: EdgeInsets.all(12), 
                        )
                      ),
                  ],
                ),
              ],),
            ] 
          ),
        ),
      ),
    );
  }



  void _showDoorbellPopupSheet(BuildContext context, {required bool isEditiable, required bool isNew}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DoorbellPopupSheet(
          name: 'Ethan',
          avatarPath: 'assets/images/avatars/avatar1.png',
          avatarColor: CupertinoColors.activeGreen,
        );
      },
    );
  }
}