import 'dart:ffi';

import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/model/house.dart';
import 'package:doorbell/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../components/button.dart'; // Import your custom button component
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import 'package:doorbell/model/house.dart' as my_house;
import 'package:doorbell/model/user.dart' as my_user;
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
  String _name = "";

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

  String formatHouseName(List<String> names) {
    if (names.isEmpty) return ''; // Handle empty list case

    if (names.length == 1) {
      return "${names[0]}'s house";
    } else if (names.length == 2) {
      return "${names[0]} and ${names[1]}'s house";
    } else {
      // Join all names except the last two with a comma
      String allButLastTwo = names.sublist(0, names.length - 2).join(', ');
      // Get the last two names
      String lastTwo = "${names[names.length - 2]} and ${names[names.length - 1]}";

      return "$allButLastTwo, $lastTwo's house";
    }
  }

  Future<List<(String, String)>> _getHouses() async {

  var uid = auth.FirebaseAuth.instance.currentUser?.uid;
  var neighID = "0";

  // use that user ID to get the user from firestore
  if (uid != null) {
    var user = await my_user.UserService().getUser(uid);
    if (user != null) {
      neighID = user.neighID;
    }
  }
  
  // get all house IDs with neighID
  var houses = await my_house.HouseService().getHousesByNeighID(neighID);

  List<(String, String)> list = [];

  for (int i = 0; i < houses.length; i++) {
    var currentHouseId = houses[i].id;

    // get users with houseID
    var names = await my_user.UserService().getUserNamesByHouseID(currentHouseId);

    // concatenate appropriately
    var formattedName = formatHouseName(names);

    // add to list
    list.add((formattedName, houses[i].id));
  }
  list.add(("I don't live with any of these people.", "0"));

  print(list);

  return list;
}


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
            child: FutureBuilder<List<(String,String)>>(
              future: _getHouses(), // Fetch the houses
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while waiting for the data
                  return Center(child: SizedBox(child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5), width: 15,height: 15,),);
                } else if (snapshot.hasError) {
                  // Handle any errors that might occur
                  return Center(child: Text('Error loading houses'));
                } else if (snapshot.hasData) {
                  // Use the data (houses) once it's available
                  List<(String,String)> houses = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: houses.map((house) {
                      bool isSelected = _selectedHouse == house.$2;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: () => _selectHouse(house.$2),
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
                                  house.$1,
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
                  );
                } else {
                  // Handle the case when no data is returned
                  return Center(child: Text('No houses available'));
                }
              },
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
                _name = nameController.text;
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
            isLoading: _isLoading,
            onPressed: () async {
              activateLoading();

              if (_selectedColor == CupertinoColors.systemGrey) {
                showError('Please select a colour.');
              } else {
                clearError(); // TODO: big save here

                // get user ID from auth service                
                var uid = auth.FirebaseAuth.instance.currentUser?.uid;

                // use that user ID to get the user from firestore
                if (uid != null) {
                  var user = await my_user.UserService().getUser(uid);
                  if (user != null) {

                    // Logic to create a new house if the user doesn't select an exisitng house
                    if ((_selectedHouse == "0") | (_selectedHouse == "")) {
                      print('making a new house');
                      print(user.name);
                      print('');
                      var temp = await my_house.HouseService().createHouse(user.neighID);
                      if (temp != null) {
                        print('assinging user new house ID');
                        _selectedHouse = temp;
                      };
                    }

                    // Saving details to user
                    user.houseID = _selectedHouse;
                    user.name = _name;
                    user.avatar = _avatars[_currentAvatarIndex];
                    user.avatarColor = _selectedColor;
                    bool result = await my_user.UserService().updateUser(user);

                    // If the save is successful move to the final screen.
                    if (result == true) {
                      deActivateLoading();
                      setState(() {
                        _screen = 4;
                      });
                    }
                    
                  }
                }
                deActivateLoading();

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