import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/components/doorbell.dart';
import 'package:doorbell/model/house.dart';
import 'package:doorbell/pages/popupView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doorbell/model/user.dart' as my_user;
import 'package:doorbell/model/house.dart' as my_house;

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
  final House house;
  final String houseImg;

  FeedPage({super.key, required this.house, required this.houseImg});

  @override
  _FeedPageState createState() => _FeedPageState();

}

class _FeedPageState extends State<FeedPage> {
  Color _avatarColour = CupertinoColors.systemGrey;
  String _avatarPath = "";
  bool _isRung = false;
  late my_user.User _user;

  var userAuth = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  
  List<String> _userIdsInHouse = []; // List to store user IDs in the house

  @override
  void initState() {
    _fetchUsersInHouse();
    super.initState();
  }

  Future<void> _fetchUsersInHouse() async {
    activateLoading();
    try {
      my_user.UserService userService = my_user.UserService();
      List<my_user.User> usersInHouse = await userService.getUsersByHouseID(widget.house.id);
      setState(() {
        _userIdsInHouse = usersInHouse.map((user) => user.id).toList();
      });
    } catch (e) {
      print('Error fetching users in house: $e');
    }
    deActivateLoading();
  }

  bool _checkUserId(String id) {
    if (userAuth?.uid == id) {
      print("is editable");
      return true;
    } else {
      print("is not editable");
      return false;
    }
  }

  Future<bool> _isUsersHouse() async {
    var result = await _getUser();
    if (result.houseID == widget.house.id) {
      return true;
    } else {
      return false;
    }
  }

  // Get current user details
  Future<my_user.User> _getUser() async {
    var userAuth = FirebaseAuth.instance.currentUser;
    var user = await my_user.UserService().getUser(userAuth!.uid);
    if (user != null) {
      return user;
    } else {
      throw Exception('no user signed in');
    }
  }

  void onPostClicked(String postId) async {
    var user = await my_user.UserService().getUser(userAuth!.uid);
    if (!user!.clickedPostIds.contains(postId)) {
      user.clickedPostIds.add(postId);
      await my_user.UserService().updateUser(user);
    }
  }

  Future<bool> _hasUserClickedPost(String postId) async {
    var userAuth = FirebaseAuth.instance.currentUser;
    var result = await my_user.UserService().hasUserClickedPost(userAuth!.uid, postId);
    print(result);
    return result;
  }

  void activateLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void deActivateLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _addDoorbellPoke() async {
    var userAuth = FirebaseAuth.instance.currentUser;
    await HouseService().addPokedUser(widget.house.id, userAuth!.uid);
  }

  String _formatFeedName(List<String> names) {
    if (names.isEmpty) return ''; // Handle empty list case

    if (names.length == 1) {
      return "${names[0]}'s feed";
    } else if (names.length == 2) {
      return "${names[0]} and ${names[1]}'s feed";
    } else {
      // Join all names except the last two with a comma
      String allButLastTwo = names.sublist(0, names.length - 2).join(', ');
      // Get the last two names
      String lastTwo = "${names[names.length - 2]} and ${names[names.length - 1]}";

      return "$allButLastTwo, $lastTwo's feed";
    }
  }

  Future<String> _getFeedName() async {
    // get users with houseID
    var names = await my_user.UserService().getUserNamesByHouseID(widget.house.id);
    // concatenate appropriately
    var formattedName = _formatFeedName(names);
    return formattedName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                      setState(() {
                        _isRung = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  Image.asset(
                    widget.houseImg,
                    height: 150,
                  ),
                  SizedBox(height: 120, width: 44,)
                ],
              ),
              SizedBox(height: 32,),
              FutureBuilder<String>(
                future: _getFeedName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                            child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                          );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.23,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(); // Return an empty container if the user doesn't own the house
                  }
                },
              ),
              SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
                      return const SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                        ),
                        width: 15,
                        height: 15,
                      );
                    }

                    final posts = snapshot.data?.docs ?? [];

                    final filteredPosts = posts.where((postSnapshot) {
                      return _userIdsInHouse.contains(postSnapshot['userId']);
                    }).toList();

                    if (filteredPosts.isEmpty) {
                      // Use FutureBuilder to check if the user is in their house
                    return FutureBuilder<bool>(
                      future: _isUsersHouse(),
                        builder: (context, futureSnapshot) {
                          if (futureSnapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                              ),
                              width: 15,
                              height: 15,
                            );
                          } else if (futureSnapshot.hasError) {
                            return Text('Error: ${futureSnapshot.error}');
                          } else if (futureSnapshot.hasData && !futureSnapshot.data!) {
                            // User is not in their house, show the Doorbell button
                            return Center(
                              child: Column(
                                children: [
                                  Spacer(),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Doorbell(
                                      imageUrl: "assets/images/doorbell/doorbellRing-01.png",
                                      pressedImageUrl: "assets/images/doorbell/doorbellRing-02.png",
                                      onPressed: _addDoorbellPoke,
                                    ),
                                  ),
                                  Center(child: Text('No posts available.')),
                                  Center(child: _isRung ? Text('Do you want to ring their doorbell?') : Text('You rung their doorbell, wait for a response.')),
                                  Spacer(),
                                ],
                              ),
                            );
                          } else {
                            // User is in their house, show an empty container or some other widget
                            return Center(child: Text("Your feed is empty. Feel free to post."));
                          }
                        },
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        var postSnapshot = filteredPosts[index];
                        var post = Post(
                          id: postSnapshot.id,
                          userId: postSnapshot['userId'],
                          userName: postSnapshot['userName'],
                          avatarPath: postSnapshot['avatarPath'],
                          avatarColor: Color(postSnapshot['avatarColor'] ?? 0xFFFFFFFF),
                          title: postSnapshot['title'],
                          description: postSnapshot['description'],
                          images: List<String>.from(postSnapshot['images']),
                          timestamp: (postSnapshot['timestamp'] as Timestamp).toDate(),
                        );

                        return FutureBuilder<bool>(
                          future: _hasUserClickedPost(postSnapshot.id), // Call the async method
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Return a loading indicator while waiting
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Handle any errors
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              // Pass the result to PostCard
                              bool hasClicked = snapshot.data!;
                              return Column(
                                children: [
                                  PostCard(
                                    post: post,
                                    hasClicked: hasClicked,
                                    onPressed: () {
                                      onPostClicked(postSnapshot.id);
                                      _showPostPopupSheet(context, post: post,);
                                    },
                                  ),
                                  SizedBox(height: 12,),
                                ],
                              );
                            } else {
                              // Handle case where there's no data
                              return Text('No data');
                            }
                          },
                        );
                      },
                    );
                  }
                ),
              ),
              FutureBuilder<bool>(
                future: _isUsersHouse(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                        ),
                        width: 15,
                        height: 15,
                      );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data == true) {
                    return Column(
                      children: [
                        SizedBox(height: 8,),
                        Button(
                          icon: Image.asset("assets/images/icons/plusfill.png"),
                          text: 'Add Post',
                          isLoading: _isLoading,
                          onPressed: () async {
                            activateLoading();
                            var result = await my_user.UserService().getUser(userAuth!.uid);
                            if (result != null) {
                              _avatarColour = result.avatarColor;
                              _avatarPath = result.avatar;
                              _showNewPostPopupSheet(context);
                            }
                            deActivateLoading();
                          }
                        ),
                        SizedBox(height: 8,),
                      ],
                    );
                  } else {
                    return Container(); // Return an empty container if the user doesn't own the house
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showPostPopupSheet(BuildContext context, {required Post post}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostPopupSheet(
          postId: post.id ?? "",
          title: post.title,
          timestamp: post.timestamp,
          name: post.userName,
          description: post.description,
          imageUrls: post.images,
          avatarColor: post.avatarColor,
          avatarPath: post.avatarPath,
          isEditable: _checkUserId(post.userId),
          isNew: false,
        );
      },
    );
  }

  void _showNewPostPopupSheet(BuildContext context,) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostPopupSheet(
          title: "",
          timestamp: DateTime.now(),
          description: '',
          imageUrls: [],
          avatarColor: _avatarColour,
          avatarPath: _avatarPath,
          isEditable: true,
          isNew: true,
        );
      },
    );
  }

}