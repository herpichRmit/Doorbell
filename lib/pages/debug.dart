import 'dart:ffi';
import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/home.dart';
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
                onPressed: () {
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'create user in firestore (first with email)',
                onPressed: () {
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'check neighbourhoodId exists',
                onPressed: () {
                  
                },
              ),
              Button(
                text: 'Login neigh: check neighbourhoodId matches password',
                onPressed: () {
                  
                },
              ),
              Button(
                text: 'Sign up neigh: create new neigh, generate ID and save password',
                onPressed: () {
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'update user in firestore (with neighbourhood id,)',
                onPressed: () {
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'get houses',
                onPressed: () {
                  
                },
              ),
              const SizedBox(height: 32),
              Button(
                text: 'update user in firestore (with avatar, avatar colour, houseId,)',
                onPressed: () {
                  
                },
              ),
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