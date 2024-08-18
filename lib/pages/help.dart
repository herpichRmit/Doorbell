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
import 'package:doorbell/pages/help.dart';


class HelpPage extends StatelessWidget {
  final String neighId;

  HelpPage({super.key, required this.neighId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(
        backgroundColor: CupertinoColors.white,
        title: Text('Help Me!'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('Your Neightbourhood ID is: ${neighId}',                 
                    style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                    ),
                  ),
                ),


                Center(
                  child: HouseButton(imagePath: 'assets/images/graphics/start_graphic.png', onPressed:(){},
                    avatars: [],
                  ),
                ),

                SizedBox(height: 20),

                Text('Doorbell helps you stay up to date with loved ones living in different households. Your home page is your digital neighbourhood, and shows all the households in your neighbourhood with individual houses. The coloured doorbell icon next to the door is the same colour as the houses avatars.',
                  style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: CupertinoColors.black,
                  ),
                ),
            
                SizedBox(height: 20),

                Text('Ring the doorbell',                 
                  style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                  ),
                ),
                Text('You can ‘ring the doorbell’ of a house and prompt the people in the household to remember to update you. To do this, click into a house, and press the ‘doorbell’ button. This will update all the members of the household that you would love to hear from them!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: CupertinoColors.black,
                  ),
                ),

                SizedBox(height: 20),

                Text('View other\'s updates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                  ),
                ),              
                Text('When someone has posted an update that you haven’t seen, their avatar will appear out the front of their house. Click on their house to view their feed, and scroll down to find the updates tagged with ‘New’. You can click into these updates to view the full version, and any pictures included.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: CupertinoColors.black,
                  ),
                ),



                SizedBox(height: 20),

                Text('Make your own post',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                  ),
                ),  
                Text('To post your own updates, click on your own house to view your feed. Start typing your update in the text field, and tap ‘add photos’ to include accompanying images.', 
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: CupertinoColors.black,
                  ),
                ),  

              ],
            ),
          )
        )
      )
    );
  }
}

/*
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
              
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HelpPage())
                  );
                },
                child: Text('Help'),
              ),
              
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
*/