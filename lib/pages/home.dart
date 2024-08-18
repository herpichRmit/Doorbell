import 'dart:ffi';
import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/model/house.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/debug.dart';
import 'package:doorbell/pages/feed.dart';
import 'package:doorbell/model/user.dart' as my_user;
import 'package:doorbell/model/house.dart' as my_house;
import 'startNeighbourhood.dart';
import 'package:doorbell/pages/popupView.dart';
import 'package:doorbell/pages/doorbellNotification.dart';

import 'package:doorbell/pages/debug.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../components/houseButton.dart';
import 'package:doorbell/pages/help.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  // Setup user var
  my_user.User _user = my_user.User(id: "id", email: "email", name: "name", avatar: "avatar", avatarColor: Colors.black, houseID: "houseID", neighID: "neighID", lastOnline: DateTime.now());
  late Future<List<House>> _futureHouses;
  late Future<String?> _lastPokedUserId;

  @override
  void initState() {
    super.initState();
    _futureHouses = _getHouses(); // Initialize the future
    _lastPokedUserId = _getLastPokedUserIdForUserHouse();
  }

  // Get current user details
  Future<my_user.User> _getUser() async {
    var userAuth = FirebaseAuth.instance.currentUser;
    var user = await my_user.UserService().getUser(userAuth!.uid);
    return user!;
  }

  // Get houses in user's neighbourhood
  Future<List<House>> _getHouses() async {
    _user = await _getUser();
    return my_house.HouseService().getHousesByNeighID(_user.neighID);
  }

  Future<String?> _getLastPokedUserIdForUserHouse() async {
    _user = await _getUser(); 
    return my_house.HouseService().getLastPokedUserId(_user.houseID);
  }

  // pass in a house object into a feed, then they get their users from that house object
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              FutureBuilder<List<House>>(
                future: _futureHouses, // The future that you want to resolve
                builder: (BuildContext context, AsyncSnapshot<List<House>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the future to resolve
                    return SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                            ),
                            width: 15,
                            height: 15,
                          );
                  } else if (snapshot.hasError) {
                    // If the future resolves with an error
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // If the future resolves but with no data
                    return Center(child: Text('No houses found.'));
                  } else {
                    // When the future resolves successfully
                    List<House> houses = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: houses.asMap().entries.map((entry) {
                        int index = entry.key;
                        House house = entry.value;
                        String imagePath;

                        // Manually set image paths
                        switch (index) {
                          case 0:
                            imagePath = 'assets/images/houses/house1.png';
                            break;
                          case 1:
                            imagePath = 'assets/images/houses/house2.png';
                            break;
                          case 2:
                            imagePath = 'assets/images/houses/house3.png';
                            break;
                          case 3:
                            imagePath = 'assets/images/houses/house4.png';
                            break;
                          default:
                            imagePath = 'assets/images/houses/default.png'; // Fallback image
                            break;
                        }

                        return Row(
                          children: [
                            if (index % 2 != 0) Spacer(), // Spacer to the left of even-indexed buttons
                            HouseButton(
                              imagePath: imagePath,
                              onPressed: () { 
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => FeedPage(house: house, houseImg: imagePath,))
                                );
                              },
                              avatars: [],
                            ),
                            if (index % 2 == 0) Spacer(), // Spacer to the right of odd-indexed buttons
                          ],
                        );
                      }).toList(), // Convert the Iterable to a List
                    );
                  }
                },
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
                            backgroundColor: CupertinoColors.systemGrey2,
                            shape: CircleBorder(), 
                            padding: EdgeInsets.all(12), 
                          )
                      ),
                  
                      SizedBox(height: 12),

                      ElevatedButton(
                        child: Text('Logout', //change to icon     
                          style: TextStyle(
                          fontSize: 20, // Text size
                          fontWeight: FontWeight.bold, // Bold text
                          color: CupertinoColors.systemGrey6, 
                          )
                        ),
                        onPressed: () {
                          var userAuth = FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StartPage()), (Route route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.systemGrey2,
                            shape: CircleBorder(), 
                            padding: EdgeInsets.all(12), 
                          )
                      ),
                  
                      SizedBox(height: 12),
                      
                      // Only show if there is a last poked user ID
                      FutureBuilder<String?>(
                        future: _lastPokedUserId,
                        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox.shrink(); // Don't show anything while loading
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return ElevatedButton(
                              child: Text('!',     
                                style: TextStyle(
                                fontSize: 20, // Text size
                                fontWeight: FontWeight.bold, // Bold text
                                color:CupertinoColors.systemGrey6, 
                                )
                              ),
                              onPressed: () => _showDoorbellPopupSheet(context, isEditiable: true, isNew: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CupertinoColors.systemGreen,
                                shape: CircleBorder(), 
                                padding: EdgeInsets.all(12), 
                              )
                            );
                          } else {
                            return SizedBox.shrink(); // Don't show anything if no poked users
                          }
                        },
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