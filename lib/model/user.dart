//import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String avatarColor;
  final String houseID;
  final String neighID;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.avatarColor,
    required this.houseID,
    required this.neighID,
  });

  // Convert a User into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'avatar_color': avatarColor,
      'houseID': houseID,
      'neighID': neighID,
    };
  }

  // Create a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      avatarColor: map['avatar_color'] ?? '',
      houseID: map['houseID'] ?? '',
      neighID: map['neighID'] ?? '',
    );
  }
}

/*

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _userCollection =>
      _firestore.collection('users');

  // Create or Update User
  Future<void> setUser(User user) async {
    try {
      await _userCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      print('Error setting user: $e');
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
  Future<void> updateUser(User user) async {
    try {
      await _userCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
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
  Future<bool> userExists(String userId) async {
    try {
      DocumentSnapshot doc = await _userCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }
  
}
*/