import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/model/post.dart';
import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/home.dart';
import 'package:doorbell/model/user.dart' as my_user;
import 'package:doorbell/model/neigh.dart' as my_neigh;
import 'package:doorbell/model/house.dart' as my_house;
import 'package:doorbell/model/post.dart' as my_post;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import 'startNeighbourhood.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';


class DebugPage extends StatefulWidget {
  DebugPage({super.key});

  @override
  _DebugPageState createState() => _DebugPageState();

}

class _DebugPageState extends State<DebugPage> {

  // Define this stream before the build statement
  final Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
    .collection('posts')
    .orderBy("timestamp", descending: true)
    .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32), // 16 is apple HIGs standard, lets do 32 for onboarding screens.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              const Text('Test', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, letterSpacing: -0.26)),
              const SizedBox(height: 32),
              Button(
                text: 'restart onboarding',
                onPressed: () {
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StartPage()),
                  );
                },
              ),
              const SizedBox(height: 8),
              Button(
                text: 'create post', // TODO
                onPressed: () async {
                  Post post = Post(
                    userId: "VUHsjbEUo4RuI2bsSkOXeEkvaQA3", 
                    userName: 'test',
                    avatarPath: 'assets/images/avatars/avatar1.png',
                    avatarColor:CupertinoColors.systemBlue,
                    title: "Test post", 
                    description: "test post test post test post test post", 
                    images: [""], 
                    timestamp: DateTime.now(), 
                  );
                  bool result = await my_post.PostService().createPost(post);

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }

                },
              ),
              Button(
                text: 'update post', // TODO
                onPressed: () async {
                  var post = await my_post.PostService().getPost("C38zdFEnDlThYrB0T1BQ");
                  if (post != null) {
                    post.title = 'edited';
                    post.description = 'testsvdfds';
                    bool result = await my_post.PostService().updatePost(post);
                    if (result) {
                      print('Success');
                    } else {
                      print('Failure');
                    }
                  }

                },
              ),
              Button(
                text: 'delete post', // TODO
                onPressed: () async {
                  /*bool result = await my_user.UserService().userExists('ethanherpich@gmail.com');

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                  */
                },
              ),
              Button(
                text: 'read posts by houesID', // TODO
                onPressed: () async {
                  bool result = await my_user.UserService().userExists('ethanherpich@gmail.com');

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }

                },
              ),
              Button(
                text: 'get all new posts (has user seen it)', // TODO
                onPressed: () async {
                  bool result = await my_user.UserService().userExists('ethanherpich@gmail.com');

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }

                },
              ),
              Button(
                text: 'get all new posts (has user seen it)', // TODO
                onPressed: () async {
                  bool result = await my_user.UserService().userExists('ethanherpich@gmail.com');

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }

                },
              ),

              Button(
                text: 'Homepage', 
                onPressed: () async {
                  
                  Navigator.of(context).pop();

                },
              ),
              
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final posts = snapshot.data?.docs ?? [];

                    if (posts.isEmpty) {
                      return Center(child: Text('No posts available'));
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //if (post['imageUrl'] != null)
                                //  Image.network(post['imageUrl']),
                                SizedBox(height: 10),
                                Text(
                                  post['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(post['description']),
                                SizedBox(height: 10),
                                Text(
                                  post['timestamp'].toDate().toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              ),

              const Spacer(flex: 3),
              
            ],
          ),
        ),
      ),
    );
  }

}