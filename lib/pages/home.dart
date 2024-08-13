import 'dart:ffi';
import 'package:doorbell/pages/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import 'startNeighbourhood.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {


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
              const SizedBox(width: 44, height: 44, child: DecoratedBox(decoration: BoxDecoration( color: Colors.red),)), // ICON
              const SizedBox(height: 24),
              const Text('Stay Connected', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, letterSpacing: -0.26)),
              const SizedBox(height: 24),
              const SizedBox(height: 32),
              Button(
                text: 'restart',
                onPressed: () {
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StartPage())
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