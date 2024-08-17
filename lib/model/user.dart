import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorbell/components/avatar.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final Color avatarColor;
  final String houseID;
  final String neighID;
  final DateTime lastOnline;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.avatarColor,
    required this.houseID,
    required this.neighID,
    required this.lastOnline,
  });

  // Convert a User into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'avatarColor': avatarColor.value, // Convert Color to integer
      'houseID': houseID,
      'neighID': neighID,
      'lastOnline': lastOnline,
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
      DocumentSnapshot doc = await _userCollection.doc(userId).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
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
