import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart'; // Import your custom button component

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 238, 219, 255),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32), // 16 is apple HIGs standard, lets do 32 for onboarding screens.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              const Text('Stay Connected!', style: TextStyle(fontSize: 22.0)),
              const Text('Find your family Neighbourhood!', style: TextStyle(fontSize: 22.0)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username box
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(76, 255, 255, 255),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 52, 63, 70)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: '  Enter your email ',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ),
          
                    // Password box
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 152, 3, 251),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 122, 125, 128)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: '  Password ',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              
              CustomButton(
                text: 'Login',
                onPressed: () async {
                  /*
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  } catch (e) {
                    print(e);
                  }
                  */
                },
                backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                textColor: Colors.black,
                borderRadius: 5.5,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? '),
                  TextButton(
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage()),
                      );*/
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
