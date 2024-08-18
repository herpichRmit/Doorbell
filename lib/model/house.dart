import 'package:cloud_firestore/cloud_firestore.dart';

class House {
  final String id;
  final String neighID;
  final List<String> pokedUserIds; // List of user IDs who have poked this house

  House({
    required this.id,
    required this.neighID,
    this.pokedUserIds = const [],
  });

  // Convert a House into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'neighID': neighID,
      'pokedUserIds': pokedUserIds, // Add pokedUserIds to the map
    };
  }

  // Create a House from a Map
  factory House.fromMap(String id, Map<String, dynamic> map) {
    return House(
      id: map['id'] ?? '',
      neighID: map['neighID'] ?? '',
      pokedUserIds: List<String>.from(map['pokedUserIds'] ?? []), // Initialize pokedUserIds
    );
  }
}



class HouseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _houseCollection => _firestore.collection('houses');

  // Stream to get real-time updates of the last poked user ID
  Stream<String?> getLastPokedUserIdStream(String houseId) {
    return _houseCollection.doc(houseId).snapshots().map((docSnapshot) {
      if (docSnapshot.exists) {
        List<String> pokedUserIds = List<String>.from(docSnapshot['pokedUserIds'] ?? []);
        if (pokedUserIds.isNotEmpty) {
          return pokedUserIds.last; // Return the last entry in the list
        }
      }
      return null;
    });
  }

  // Method to add a user to the pokedUserIds list
  Future<void> addPokedUser(String houseId, String userId) async {
    try {
      DocumentReference houseDoc = _houseCollection.doc(houseId);
      await houseDoc.update({
        'pokedUserIds': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print('Error adding poked user: $e');
    }
  }

  // Method to remove a user from the pokedUserIds list
  Future<void> removePokedUser(String houseId, String userId) async {
    try {
      DocumentReference houseDoc = _houseCollection.doc(houseId);
      await houseDoc.update({
        'pokedUserIds': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      print('Error removing poked user: $e');
    }
  }
  
  // Method to clear the pokedUserIds list
  Future<void> clearPokedUsers(String houseId) async {
    try {
      DocumentReference houseDoc = _houseCollection.doc(houseId);
      await houseDoc.update({
        'pokedUserIds': [], // Set the pokedUserIds list to an empty list
      });
    } catch (e) {
      print('Error clearing poked users: $e');
    }
  }

  // Method to get the last poked user ID from the list
  Future<String?> getLastPokedUserId(String houseId) async {
    try {
      DocumentSnapshot doc = await _houseCollection.doc(houseId).get();
      if (doc.exists) {
        List<String> pokedUserIds = List<String>.from(doc['pokedUserIds'] ?? []);
        if (pokedUserIds.isNotEmpty) {
          return pokedUserIds.last; // Return the last entry in the list
        }
      }
      return null;
    } catch (e) {
      print('Error getting last poked user ID: $e');
      return null;
    }
  }

  // Create or Update House
  Future<bool> setHouse(House house) async {
    try {
      await _houseCollection.doc(house.id).set(house.toMap());
      return true;
    } catch (e) {
      print('Error setting house: $e');
      return false;
    }
  }

  // Generate a new ID for house
  Future<String> _generateHouseId() async {
    try {
      QuerySnapshot querySnapshot = await _houseCollection.orderBy('id', descending: true).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Get the last ID and increment it
        String lastId = querySnapshot.docs.first['id'];
        int newId = int.parse(lastId) + 1;

        // Ensure the ID is 4 digits long
        return newId.toString().padLeft(4, '0');
      } else {
        // Return "0001" if no records exist
        return '0001';
      }
    } catch (e) {
      print('Error generating Neigh ID: $e');
      return '0001'; // Fallback ID
    }
  }

  // Create a new house
  Future<String?> createHouse(String neighId) async {
    try {
      String newId = await _generateHouseId();
      House house = House(id: newId, neighID: neighId);
      await _houseCollection.doc(house.id).set(house.toMap());
      return newId;
    } catch (e) {
      print('Error creating Neigh: $e');
      return null;
    }
  }

  // Read House
  Future<House?> getHouse(String houseId) async {
    try {
      DocumentSnapshot doc = await _houseCollection.doc(houseId).get();
      if (doc.exists) {
        return House.fromMap(houseId, doc.data() as Map<String, dynamic>);
      } else {
        print('House not found');
        return null;
      }
    } catch (e) {
      print('Error getting house: $e');
      return null;
    }
  }

  // Function to get all houses for a given neighID
  Future<List<House>> getHousesByNeighID(String neighID) async {
    try {
      // Query the houses collection where neighID matches the provided value
      QuerySnapshot querySnapshot = await _houseCollection
          .where('neighID', isEqualTo: neighID)
          .get();

      // Map the query results to a list of House objects
      List<House> houses = querySnapshot.docs.map((doc) {
        return House.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      print(houses);
      return houses;
    } catch (e) {
      print('Error getting houses by neighID: $e');
      return [];
    }
  }

  // Update House (example of updating specific fields)
  Future<void> updateHouse(House house) async {
    try {
      await _houseCollection.doc(house.id).update(house.toMap());
    } catch (e) {
      print('Error updating house: $e');
    }
  }

  // Delete House
  Future<void> deleteHouse(String houseId) async {
    try {
      await _houseCollection.doc(houseId).delete();
    } catch (e) {
      print('Error deleting house: $e');
    }
  }

  // Check if house exists
  Future<bool> houseExists(String houseId) async {
    try {
      DocumentSnapshot doc = await _houseCollection.doc(houseId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if house exists: $e');
      return false;
    }
  }
}
