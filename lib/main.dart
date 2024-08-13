import 'package:doorbell/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
	  options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Add this line to the top of the build function 
	  Stream<User?> authStream = FirebaseAuth.instance.authStateChanges();

    return MaterialApp(
      title: 'DoorBell',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Helvetica Neue',
      ),
      home: StreamBuilder<User?>(
        stream: authStream,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return StartPage();
          }
          return HomePage();
        },
      ),
      
    );
  }
}
