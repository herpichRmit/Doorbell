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
  late Stream<my_user.User?> _lastPokedUserStream;

  @override
  void initState() {
    super.initState();
    _futureHouses = _getHouses(); // Initialize the future
    _lastPokedUserStream = _getLastPokedUserStream(); // Initialize the stream
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

  // Create a stream that emits updates when the last poked user changes
  Stream<my_user.User?> _getLastPokedUserStream() async* {
    _user = await _getUser();
    yield* my_house.HouseService().getLastPokedUserIdStream(_user.houseID).asyncMap((result) async {
      return result == null ? null : await my_user.UserService().getUser(result);
    });
  }

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
                future: _futureHouses,
                builder: (BuildContext context, AsyncSnapshot<List<House>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                            ),
                            width: 15,
                            height: 15,
                          );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No houses found.'));
                  } else {
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
                            if (index % 2 != 0) Spacer(),
                            HouseButton(
                              imagePath: imagePath,
                              onPressed: () { 
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => FeedPage(house: house, houseImg: imagePath,))
                                );
                              },
                              avatars: [],
                            ),
                            if (index % 2 == 0) Spacer(),
                          ],
                        );
                      }).toList(),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemGrey6,
                          )
                        ),
                        onPressed: () async {
                          _user = await _getUser();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => HelpPage(neighId: _user.neighID))
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
                        child: Icon(
                          Icons.logout,
                          color: CupertinoColors.systemGrey6, 
                          size: 28,
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StartPage()), (Route route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CupertinoColors.systemGrey2,
                            shape: CircleBorder(), 
                            padding: EdgeInsets.all(12), 
                          )
                      ),
                  
                      SizedBox(height: 12),
                      
                      StreamBuilder<my_user.User?>(
                        stream: _lastPokedUserStream,
                        builder: (BuildContext context, AsyncSnapshot<my_user.User?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox.shrink();
                          } else if (snapshot.hasData && snapshot.data != null) {
                            return ElevatedButton(
                              child: Text('!',     
                                style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.systemGrey6,
                                )
                              ),
                              onPressed: () {
                                my_house.HouseService().clearPokedUsers(_user.houseID);
                                _showDoorbellPopupSheet(context, color: snapshot.data!.avatarColor, path: snapshot.data!.avatar, name: snapshot.data!.name, );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: snapshot.data?.avatarColor,
                                shape: CircleBorder(), 
                                padding: EdgeInsets.all(12), 
                              )
                            );
                          } else {
                            return SizedBox.shrink();
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

  void _showDoorbellPopupSheet(BuildContext context, {required Color color, required String path, required String name}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DoorbellPopupSheet(
          name: name,
          avatarPath: path,
          avatarColor: color,
        );
      },
    );
  }
}
