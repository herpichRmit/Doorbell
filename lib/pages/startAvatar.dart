import 'dart:ffi';

import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart'; // Import your custom button component
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
//final FirebaseFirestore _firestore = FirebaseFirestore.instance;



class StartAvatarPage extends StatefulWidget {
  final int inputScreen;
  
  StartAvatarPage({Key? key, this.inputScreen = 2}) : super(key: key);

  @override
  _StartAvatarPageState createState() => _StartAvatarPageState();

}

class _StartAvatarPageState extends State<StartAvatarPage> {
  final TextEditingController nameController = TextEditingController();
  late int _screen;

  void initState() {
    super.initState();
    _screen = widget.inputScreen;
  }

  
  int _currentAvatarIndex = 0;
  Color _selectedColor = CupertinoColors.systemGrey;
  String _selectedHouse = "";
  String _error = "";
  bool _isLoading = false;

  void _selectHouse(String house) {
    setState(() {
      _selectedHouse = house;
    });
  }

  final List<String> _avatars = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
    'assets/images/avatars/avatar5.png',
    'assets/images/avatars/avatar6.png',
    'assets/images/avatars/avatar7.png',
    'assets/images/avatars/avatar8.png',
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

    // Do you live with anyone already connected, screen (doesn't appear for people who are hosting)

    if (_screen == 1) {
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
            isLoading: _isLoading,
            onPressed: () async {
            
              if (_selectedHouse == "") {
                showError('Please select one of the options above.');
              } else {
                clearError();
                setState(() {
                  _screen = 2;
                });
              }
              
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          getSmallText(message: 'So we can find out which house you belong in.')
        ],
      );

    // Name screen

    } else if (_screen == 2) {
      return Column(
        children: [
          const Center(
            child: Text('What do we call you?', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          const SizedBox(height: 24),
          Center(
            child: Image.asset("assets/images/graphics/name_graphic.png", height: 220,),
          ),
          const SizedBox(height: 12),
          CustomTextField(placeholder: 'Enter name...', controller: nameController, isError: checkError(),),
          const SizedBox(height: 8),
          Button(
            text: 'Next',
            onPressed: () async {
            
              // is password empty
              if (nameController.text.isEmpty) {
                showError("Name cannot be empty.");
              // if not, try to login to neighbourhood
              } else {
                clearControllers();
                clearError();
                setState(() {
                  _screen = 3;
                });
              }

              
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          getSmallText(message: 'This will be so other users can identify you.', widgetNumber: 0)
        ],
      );

    // Avatar picker screen

    } else if (_screen == 3) {
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
                child: Image.asset("assets/images/icons/Chevron-Left.png", height: 32, width: 32,) //left chevron
              ),
              const SizedBox(width: 24),
              Container(
                child: Avatar(color: _selectedColor, imagePath: _avatars[_currentAvatarIndex], size: 120,)
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _changeAvatar(1),
                child: Image.asset("assets/images/icons/chevron-right.png", height: 32, width: 32,) //right chevron
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

              if (_selectedColor == CupertinoColors.systemGrey) {
                showError('Please select a colour.');
              } else {
                clearError(); // TODO: big save here
                setState(() {
                  _screen = 4;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          getSmallText(message: 'This is your avatar, it represents you in the app.')
        ],
      );

    // Confirmation screen

    } else if (_screen == 4) {
      return Column(
        children: [
          const Center(
            child: Text('You are ready to go', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Center(
                heightFactor: 1.8,
                child: Avatar(color: _selectedColor, imagePath: _avatars[_currentAvatarIndex]),
              ),
              Center(
                child: Image.asset("assets/images/graphics/celebration_graphic.png", height: 200,),
              ),
            ],
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
  void showError(String message) {
    // Show an error message to the user
    setState(() {
      _error = message;
    });
  }

  void clearError() {
    setState(() {
      _error = "";
    });
  }

  void activateLoading(){
    setState(() { 
      _isLoading = true;
    });
  }

  void deActivateLoading(){
    setState(() { 
      _isLoading = false;
    });
  }

  bool checkError(){
    if (_error == "") {
      return false;
    } else {
      return true;
    }
  }

  void clearControllers() {
    nameController.text = "";
  }

  /*
  Future<void> createUserProfile(String email, String name, String avatarRef, Color avatarCol, String houseId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'name': name,
        'avatarRef': avatarRef,
        'avatarCol' : avatarCol,
        'houseId' : houseId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }*/

  Widget getSmallText({required String message, int widgetNumber = 0}) {
    return Column(
      children: [
        if (_error != "") // Error message
          SplashSmallText(
            text: _error,
            backOption: false,
            isError: true,
          ),
        if (widgetNumber != 0)
          SplashSmallText( // Text at the bottom
            text: message,
            onPressed: () {
              clearControllers();
              clearError();
              setState(() {
                _screen = widgetNumber;
              });
            }
          )
          else if (widgetNumber == 0)
            SplashSmallText( // Text at the bottom
              text: message,
              backOption: false,
            )
      ],
    );
  }

}