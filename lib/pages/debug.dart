import 'dart:ffi';
import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/home.dart';
import 'package:doorbell/model/user.dart' as my_user;
import 'package:doorbell/model/neigh.dart' as my_neigh;
import 'package:doorbell/model/house.dart' as my_house;
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
                    MaterialPageRoute(builder: (context) => StartPage())
                  );
                },
              ),
              const SizedBox(height: 8),
              Button(
                text: 'check user exists',
                onPressed: () async {
                  bool result = await my_user.UserService().userExists('ethanherpich@gmail.com');

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }

                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'create user in firestore (first with email)',
                onPressed: () async {
                  var user = my_user.User(id: "1234", email: 'ethanherpich@gmail.com', name: 'Ethan', avatar: 'assets/images/avatars/avatar1', avatarColor: CupertinoColors.systemPink, houseID: "house1", neighID: "neigh1", lastOnline: DateTime.now());
                  bool result = await my_user.UserService().setUser(user);

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'check neighbourhoodId exists',
                onPressed: () async {
                  bool result = await my_neigh.NeighService().doesNeighExist("0001");

                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                },
              ),
              Button(
                text: 'Login neigh: check neighbourhoodId matches password',
                onPressed: () async {
                  bool result = await my_neigh.NeighService().validateNeighCredentials("0001", "Badger01");
                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                  
                },
              ),
              Button(
                text: 'Sign up neigh: create new neigh, generate ID and save password',
                onPressed: () async {
                  String? result = await my_neigh.NeighService().createNeigh("Badger01");
                  if (result != null) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'update user',
                onPressed: () async {
                  var user = my_user.User(id: "1234", email: 'ethanherpich@gmail.com', name: 'Ethan', avatar: 'assets/images/avatars/avatar1', avatarColor: CupertinoColors.systemPink, houseID: "0001", neighID: "0001", lastOnline: DateTime.now());
                  bool result = await my_user.UserService().updateUser(user);
                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'create a house',
                onPressed: () {
                  bool result = await my_house.HouseService().setHouse(house);
                  if (result) {
                    print('Success');
                  } else {
                    print('Failure');
                  }
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'get houses with certain neigh id',
                onPressed: () {
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'Home',
                onPressed: () async {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomePage())
                  );
                },
              ),
              const Spacer(flex: 3),
              
            ],
          ),
        ),
      ),
    );
  }

}