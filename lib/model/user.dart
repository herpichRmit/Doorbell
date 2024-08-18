import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorbell/components/avatar.dart';

class User {
  final String id;
  final String email;
  String name;
  String avatar;
  Color avatarColor;
  String houseID;
  String neighID;
  DateTime lastOnline;
  final List<String> clickedPostIds; 

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.avatarColor,
    required this.houseID,
    required this.neighID,
    required this.lastOnline,
    this.clickedPostIds = const [], 
  });

  // Convert a User into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'avatarColor': avatarColor.value, 
      'houseID': houseID,
      'neighID': neighID,
      'lastOnline': lastOnline,
      'clickedPostIds': clickedPostIds,
    };
  }

  // Create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      avatarColor: Color(map['avatarColor'] ?? 0xFFFFFFFF), // Convert integer back to Color
      houseID: map['houseID'] ?? '',
      neighID: map['neighID'] ?? '',
      lastOnline: (map['lastOnline'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      clickedPostIds: List<String>.from(map['clickedPostIds'] ?? []),
    );
  }
}

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _userCollection =>
      _firestore.collection('users');

  // Create or Update User
  Future<bool> setUser(User user) async {
    try {
      await _userCollection.doc(user.id).set(user.toMap());
      return true;
    } catch (e) {
      print('Error setting user: $e');
      return false;
    }
  }

  // Read User
  Future<User?> getUser(String userId) async {
    try {
      // Debugging: Print the userId to ensure it's correct
      print('Fetching user with ID: $userId');
      
      DocumentSnapshot doc = await _userCollection.doc(userId).get();
      
      if (doc.exists) {
        print('User document found: ${doc.data()}');
        
        // Ensure all expected fields are present in the document
        if (doc.data() != null) {
          return User.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          print('Document exists but data is null.');
          return null;
        }
      } else {
        print('User document with ID $userId not found.');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Function to get all user names by houseID
  Future<List<String>> getUserNamesByHouseID(String houseID) async {
    try {
      // Query the users collection where houseID matches the provided value
      QuerySnapshot querySnapshot = await _userCollection
          .where('houseID', isEqualTo: houseID)
          .get();

      // Map the query results to a list of usernames
      List<String> names = querySnapshot.docs.map((doc) {
        return doc['name'] as String; // Extracting the name field
      }).toList();

      return names;
    } catch (e) {
      print('Error getting usernames by houseID: $e');
      return [];
    }
  }

  // Function to get all users by houseID
  Future<List<User>> getUsersByHouseID(String houseID) async {
    try {
      // Query the users collection where houseID matches the provided value
      QuerySnapshot querySnapshot = await _userCollection
          .where('houseID', isEqualTo: houseID)
          .get();

      // Map the query results to a list of User objects
      List<User> users = querySnapshot.docs.map((doc) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return users;
    } catch (e) {
      print('Error getting users by houseID: $e');
      return [];
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _userCollection.get();
      
      // Map each document to a User object
      List<User> users = querySnapshot.docs.map((doc) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return users;
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Update User (example of updating specific fields)
  Future<bool> updateUser(User user) async {
    try {
      await _userCollection.doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete User
  Future<void> deleteUser(String userId) async {
    try {
      await _userCollection.doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Check if user exists
  Future<bool> userExists(String email) async {
    try {
      // Query Firestore for documents where the email field matches the provided email
      QuerySnapshot querySnapshot = await _userCollection
          .where('email', isEqualTo: email)
          .limit(1) // Limiting to 1 document for efficiency
          .get();

      // Check if any documents were found
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }
  
}
