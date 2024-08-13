import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart'; // Import your custom button component
import 'package:flutter/cupertino.dart';
import '../components/splashSmallText.dart';
import '../components/textField.dart';
import 'startNeighbourhood.dart';


class StartPage extends StatefulWidget {
  StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();

}

class _StartPageState extends State<StartPage> {
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  int _showWidgets = 1;
  bool _nextLogin = false;

  // username
  // password
  // password again

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
              const Text('Find your family\'s Neighbourhood', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, letterSpacing: -0.26, height: 1.2, color: CupertinoColors.systemGrey)),
              const SizedBox(height: 24),
              const SizedBox( // Image
                width: double.infinity,
                height: 200,
                child: DecoratedBox(decoration: BoxDecoration( color: Colors.red))
              ),
              const SizedBox(height: 32),
              getWidgets(),
              const Spacer(flex: 3),
              
            ],
          ),
        ),
      ),
    );
  }

  // This function determines which controls are shown on the homepage, depending on wether the user wants to login or signup.
  Widget getWidgets() {
    if (_showWidgets == 1) { // Login and Sign Up Button
      return Column(
        children: [
          Button(
            text: 'Login',
            onPressed: () {
              setState(() {
                _showWidgets = 2;
              });
            },
          ),
          const SizedBox(height: 8),
          Button(
            text: 'Sign Up',
            onPressed: () {
              setState(() {
                _showWidgets = 3;
              });
            },
          ),
        ],
      );
    }
    else if (_showWidgets == 2) { // Login buttons
      return Form(
        key: _formKey,
        child: getLoginWidgets() // This function encapsulates the check username, check password, and authenticate functionality
      );
    }
    else if (_showWidgets == 3) { // Signup details
      return Form(
        key: _formKey,
        child: Column(
            children: [
              CustomTextField(placeholder: 'Enter your email address', controller: emailController),
              const SizedBox(height: 8),
              CustomTextField(placeholder: 'Enter your password', controller: passwordController, isPassword: true),
              const SizedBox(height: 8),
              CustomTextField(placeholder: 'Confirm your password', controller: passwordConfirmController, isPassword: true),
              const SizedBox(height: 8),
              Button(
                text: 'Sign Up',
                onPressed: () async {
                  
                  //signup(emailController.text, passwordController.text); // need to get result from todo form validation

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StartNeighbourhoodPage())
                  );
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
              SplashSmallText(
                text: 'Already have an account?',
                onPressed: () {
                  setState(() {
                    _showWidgets = 1;
                  });
                }
              ),
            ],
          )
      );
    }
    else if (_showWidgets == 5) { // Might need loading variants
      return const SizedBox(height: 16);
    } else {
      return const SizedBox(height: 16);
    }
  }

  // This function encapsulates the check username, check password, and authenticate functionality
  Widget getLoginWidgets() {
    if (_nextLogin == false) {
      return Column(
        children: [
          CustomTextField(placeholder: 'Enter your email address...', controller: emailController),
          const SizedBox(height: 8),
          Button(
            text: 'Next',
            onPressed: () async {
              
              // If so:
              setState(() {
                _nextLogin = true;
              });
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
          SplashSmallText(
            text: 'Need to make an account?',
            onPressed: () {
              setState(() {
                _showWidgets = 1;
              });
            }
          ),
        ],
      );
    } else if (_nextLogin == true) {
      return Column(
          children: [
            CustomTextField(placeholder: 'Enter your password...', controller: passwordController, isPassword: true),
            const SizedBox(height: 8),
            Button(
              text: 'Login',
              onPressed: () async {
                    login(emailController.text, passwordController.text);
                  },
            ),
            const SizedBox(height: 16),
            const SizedBox(width: double.infinity, height: 0.5, child: DecoratedBox(decoration: BoxDecoration( color: Colors.grey))),
            SplashSmallText(
              text: 'Made a mistake?',
              onPressed: () {
                setState(() {
                  _nextLogin = false;
                });
              }
            ),
          ],
        );
    } else {
      return SizedBox();
    }
  }

  // This function calls FirebaseAuth to authenticate the user
  login(email, password) async {
    try {
      final credential = await FirebaseAuth.instance
      .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.'); // add bad cases
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.'); // add bad cases ALSO add loading state
      }
    } catch (e) {
      print(e);
    }
  }

  // This function calls FirebaseAuth to create a new user
  signup(email, password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

  }

  /*
  doesUserExist(currentUserName) async {
    try {
    // if the size of value is greater then 0 then that doc exist. 
      await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: currentEmail)
          .get()
          .then((value) => value.size > 0 ? true : false);
    } catch (e) {
      debugPrint(e.toString());
     
    }
  }*/
}