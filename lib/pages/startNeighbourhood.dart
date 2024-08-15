import 'dart:ffi';

import 'package:doorbell/pages/start.dart';
import 'package:doorbell/pages/startAvatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart'; // Import your custom button component
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';


class StartNeighbourhoodPage extends StatefulWidget {
  StartNeighbourhoodPage({super.key});

  @override
  _StartNeighbourhoodState createState() => _StartNeighbourhoodState();

}

class _StartNeighbourhoodState extends State<StartNeighbourhoodPage> {
  
  // Join screens
  final TextEditingController joinNeighIDController = TextEditingController();
  final TextEditingController joinNeighPasswordController = TextEditingController();

  // Host screens
  final TextEditingController hostNeighPasswordController = TextEditingController();
  final TextEditingController hostNeighPasswordConfirmController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  String _error = "";

  int _showWidgets = 1;
  bool _nextLogin = false;
  bool _isLoading = false;
  String _neighbourhoodId = "";

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
              Visibility( // Keep text, but make it invisible to keep layout consistent
                child: const SizedBox(width: 44, height: 44, child: DecoratedBox(decoration: BoxDecoration( color: Colors.red),)), // ICON
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
               ), 
              const SizedBox(height: 24),
              Visibility( // Keep text, but make it invisible to keep layout consistent
                child: const Text('Stay Connected', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, letterSpacing: -0.26)),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
               ), 
              Center(
                child: const Text('Your neighbourhood awaits', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: -0.45, height: 1.2, color: Colors.black)),
              ),
              const SizedBox(height: 24),
              const SizedBox( // Image
                width: double.infinity,
                height: 200,
                child: DecoratedBox(decoration: BoxDecoration( color: Colors.green))
              ),
              const SizedBox(height: 32),
              
              // get control widgets
              getWidgets(),

              const Spacer(flex: 3),
              
            ],
          ),
        ),
      ),
    );
  }

  // This function determines which controls are shown, depending on wether the user wants to join or host a neighbourhood.
  Widget getWidgets() {
    if (_showWidgets == 1) { // Host or Join buttons
      return Column(
        children: [
          
          Button(
              text: 'Create Neighbourhood',
              onPressed: () {
                setState(() {
                  _showWidgets = 2;
                });
              },
            ),
          const SizedBox(height: 8),
          Button(
            text: 'Join Neighbourhood',
            onPressed: () {
              setState(() {
                _showWidgets = 4;
              });
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          SplashSmallText(
            text: 'Let\'s decide if you want to host or join.',
            backOption: false,
          ),
        ],
      );
    }
    else if (_showWidgets == 2) { // Enter neighbourhood passwords to create neighbourhood
      return Form(
        key: _formKey,
        child: Column(
            children: [
              CustomTextField(placeholder: 'Enter neighbourhood password', controller: hostNeighPasswordController, isPassword: true, isError: checkError(),),
              const SizedBox(height: 8),
              CustomTextField(placeholder: 'Confirm neighbourhood password', controller: hostNeighPasswordConfirmController, isPassword: true, isError: checkError(),),
              const SizedBox(height: 8),
              Button(
                text: 'Create',
                isLoading: _isLoading,
                onPressed: () async {
                  activateLoading();
                  // check passwords are not empty
                  if ( (hostNeighPasswordController.text == "") | (hostNeighPasswordConfirmController.text == "") ) {
                    showError('Password field is empty.');
                    deActivateLoading();
                  // check if passwords match
                  } else if (hostNeighPasswordController.text != hostNeighPasswordConfirmController.text) {
                    showError('Passwords do not match.');
                    deActivateLoading();
                  } else if (!isValidPassword(hostNeighPasswordController.text)) {
                    showError('Password is too weak.');
                    deActivateLoading();
                  } else { // TODO: function to create passwords after firestore integration
                    //bool result = await signup(signupEmailController.text, signupPasswordController.text);
                    deActivateLoading();

                    // FUNCTION 1
                    //check if neighbourhood ID + password exist
                    
                    // FUNCTION 2
                    //var currentUser = FirebaseAuth.instance.currentUser;
                    //create document in firestore with neighbourhood id

                    // TODO: get neighbourhood id back from firestore and save for next screen

                    //if (result == true) {
                      clearControllers();
                      clearError();
                      setState(() {
                        _showWidgets = 3;
                      });
                    //} 
                  }
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
              getSmallText(message: 'Host a neighbourhood for your friends and family to join.', widgetNumber: 1)
            ],
          )
      );
    }
    else if (_showWidgets == 3) { // Success screen: created a neighbourhood
      return 
        Column(
        children: [
          const Text('Your neighbourhood ID', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, letterSpacing: 0, height: 1.2, color: Colors.black)),
          const SizedBox(height: 4),
          const Text('<ID HERE>', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, letterSpacing: 0, height: 1.2, color: Colors.black)),
          const SizedBox(height: 32),
          Button(
            text: 'Next',
            onPressed: () async {

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StartAvatarPage())
              );
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          SplashSmallText(
                text: 'Share your neighbourhood ID with your family.',
                backOption: false,
              ),
        ],
      );
    }
    else if (_showWidgets == 4) { // Enter neighbourhood ID
      return Form(
        key: _formKey,
        child: Column(
            children: [
              CustomTextField(placeholder: 'Enter neighbourhood ID...', controller: joinNeighIDController, isError: checkError()),
              const SizedBox(height: 8),
              Button(
                text: 'Next',
                isLoading: _isLoading,
                onPressed: () async {
                  activateLoading();

                  // check if id is empty
                  if (joinNeighIDController.text.isEmpty){
                    showError('ID cannot be empty.');
                    deActivateLoading();
                  
                  // TODO: async function call to check if neighbourhood exists
                  } else {
                    //bool result = await func()

                    //if (result == true){
                      deActivateLoading();
                      clearControllers();
                      clearError();

                      setState(() {
                        _showWidgets = 5;
                      });
                    //}
                  }
                  
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
              getSmallText(message: 'Join a neighbourhood hosted by friends or family.', widgetNumber: 1)
            ],
          )
      );
    }
    else if (_showWidgets == 5) { // Enter neighbourhood password
      return Form(
        key: _formKey,
        child: Column(
            children: [
              CustomTextField(placeholder: 'Enter neighbourhood password...', controller: joinNeighPasswordController, isPassword: true, isError: checkError()),
              const SizedBox(height: 8),
              Button(
                
                text: 'Join',
                isLoading: _isLoading,
                onPressed: () {
                  activateLoading();

                  // is password empty
                  if (joinNeighPasswordController.text.isEmpty) {
                    showError("Password cannot be empty.");
                    deActivateLoading();
                  // if not, try to login to neighbourhood
                  } else {
                    //bool result = await authNeighbourhood(_email, loginPasswordController.text);
                    deActivateLoading();
                    
                    //if (result == true) {
                      clearControllers();
                      clearError();
                      // If login is successful, navigate to the next page
                      // TODO: do checks here on user to make sure user has neighbourhood and house already
                      setState(() {
                        _showWidgets = 6;
                      });
                    //}
                  }
                }
              ),
              const SizedBox(height: 16),
              const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
              getSmallText(message: 'The person who hosted set the password.', widgetNumber: 4)
            ],
          )
      );
    }
    else if (_showWidgets == 6) { // Success screen: created a neighbourhood
      return 
        Column(
        children: [
          const Text('Joined neighbourhood', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, letterSpacing: 0, color: Colors.black)),
          const SizedBox(height: 24),
          Button(
            text: 'Next',
            onPressed: () async {

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StartAvatarPage(inputScreen: 1))
              );
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          SplashSmallText(
            text: 'Congrats you\'ve been connected.',
            backOption: false,
          ),
        ],
      );
    } else {
      return const SizedBox(height: 16);
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

  bool isValidPassword(String password) {
    // Define the regex pattern for a strong password
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$'
    );

    // Test the password against the regex pattern
    return passwordRegex.hasMatch(password);
  }

  void clearControllers() {
    joinNeighIDController.text = "";
    joinNeighPasswordController.text = "";
    hostNeighPasswordConfirmController.text = "";
    hostNeighPasswordConfirmController.text = "";
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
                _showWidgets = widgetNumber;
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