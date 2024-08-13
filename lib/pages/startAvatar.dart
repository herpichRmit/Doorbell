import 'dart:ffi';

import 'package:doorbell/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart'; // Import your custom button component
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';


class StartAvatarPage extends StatefulWidget {
  StartAvatarPage({super.key});

  @override
  _StartAvatarPageState createState() => _StartAvatarPageState();

}

class _StartAvatarPageState extends State<StartAvatarPage> {
  
  // Join screens
  final TextEditingController nameController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  int _screen = 1;
  bool _nextLogin = false;

  int _currentAvatarIndex = 0;
  Color _selectedColor = Colors.orange;
  String _selectedHouse = "";

  void _selectHouse(String house) {
    setState(() {
      _selectedHouse = house;
    });
  }

  final List<Image> _avatars = [
    Image.asset('assets/avatar1.png'),
    Image.asset('assets/avatar2.png'),
    Image.asset('assets/avatar3.png'),
  ];

  final List<String> _houses = [
    "John and Jane", 
    "Catherine",  
    "I don't live with any of these people",  
  ];

  final List<Color> _colors = [
    CupertinoColors.systemPink, 
    CupertinoColors.systemRed, 
    CupertinoColors.activeOrange, 
    CupertinoColors.systemYellow, 
    CupertinoColors.systemGreen,
    CupertinoColors.systemTeal, 
    CupertinoColors.systemCyan,
    CupertinoColors.systemBlue, 
    CupertinoColors.systemIndigo, 
    CupertinoColors.systemPurple,
  ];

  void _changeAvatar(int direction) {
    setState(() {
      _currentAvatarIndex = (_currentAvatarIndex + direction) % _avatars.length;
    });
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

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
              const SizedBox(height: 40),
              const Visibility( // Keep text, but make it invisible to keep layout consistent
                child: SizedBox(width: 44, height: 44, child: DecoratedBox(decoration: BoxDecoration( color: Colors.red),)), // ICON
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
               ), 
              const SizedBox(height: 24),
              const Visibility( // Keep text, but make it invisible to keep layout consistent
                child: Text('Stay Connected', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, letterSpacing: -0.26)),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
               ), 
              
              // HERE ONWARDS

              getPageFunctionality(),
              
              // HERE UPWARDS
              const Spacer(flex: 3),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget getPageFunctionality() {

    // Page 1

    if (_screen == 1) {
      return Column(
        children: [
          const Center(
            child: Text('What do we call you?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          const SizedBox(height: 24),
          const SizedBox( // Image
            width: double.infinity,
            height: 200,
            child: DecoratedBox(decoration: BoxDecoration( color: Colors.orange))
          ),
          const SizedBox(height: 32),
          CustomTextField(placeholder: 'Enter name...', controller: nameController),
          const SizedBox(height: 8),
          Button(
            text: 'Next',
            onPressed: () async {
            
              // functionality

              setState(() {
                _screen = 2;
              });
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          SplashSmallText(
            text: 'This will be so other users can identify you.',
            backOption: false,
          ),
        ],
      );

    // Page 2

    } else if (_screen == 2) {
      return Column(
        children: [
          const Center(
            child: Text('What best represents you?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 28),

          // Avatar picker below
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // height
              GestureDetector(
                onTap: () => _changeAvatar(-1),
                child: const SizedBox(width: 32, height: 32, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))), // left chevron
              ),
              const SizedBox(width: 24),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _avatars[_currentAvatarIndex],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _changeAvatar(1),
                child: const SizedBox(width: 32, height: 32, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))), // right chevron
              ),
            ],
          ),
          // Avatar picker above

          // Colour picker below
          const SizedBox(height: 32),
          Wrap(
            spacing: 12.0,
            children: _colors.map((color) {
              return GestureDetector(
                onTap: () => _selectColor(color),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == color
                          ? CupertinoColors.systemBlue
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // Colour picker above

          // Next button below
          const SizedBox(height: 34),
          Button(
            text: 'Next',
            onPressed: () async {
              setState(() {
                _screen = 3;
              });
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          const SplashSmallText(
            text: 'This is your avatar, it represents you in the app.',
            backOption: false,
          ),
        ],
      );

    // Page 3

    } else if (_screen == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Center(
            child: Text('Do you live with any of these people?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          const SizedBox(height: 32),

          Container(
            height: 286,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _houses.map((house) {
                bool isSelected = _selectedHouse == house;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () => _selectHouse(house),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.5),
                        border: Border.all(
                          color: Colors.grey, // Original inner border
                          width: 1,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.8), // Outer border color
                              spreadRadius: 2, 
                              blurRadius: 0.2,
                            ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: Center(
                          child: Text(
                            house,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),
          Button(
            text: 'Next',
            onPressed: () async {
            
              // functionality

              setState(() {
                _screen = 4;
              });
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          SplashSmallText(
            text: 'This will be so other users can identify you.',
            backOption: false,
          ),
        ],
      );
    } else if (_screen == 4) {
      return Column(
        children: [
          const Center(
            child: Text('You are ready to go', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          const SizedBox(height: 24),
          const SizedBox( // Image
            width: double.infinity,
            height: 200,
            child: DecoratedBox(decoration: BoxDecoration( color: Colors.purple))
          ),
          const SizedBox(height: 32),
          const Text('Welcome to your neighbourhood', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, letterSpacing: 0, color: Colors.black)),
          const SizedBox(height: 32),

          Button(
            text: 'Next',
            onPressed: () {
              
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage())
              );
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          const SplashSmallText(
            text: 'All sorted.',
            backOption: false,
          ),
        ],
      );

    // In case of a bug

    } else {
      return const Column(
        children: [
          Center(
            child: Text('Your neighbourhood awaits', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          SizedBox(height: 24),
          SizedBox( // Image
            width: double.infinity,
            height: 200,
            child: DecoratedBox(decoration: BoxDecoration( color: Colors.green))
          ),
          SizedBox(height: 32),
        ],
      );
    }
    
  }

}