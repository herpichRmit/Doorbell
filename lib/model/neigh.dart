import 'package:cloud_firestore/cloud_firestore.dart';

class Neigh {
  final String id;
  final String password;

  Neigh({
    required this.id,
    required this.password,
  });

  // Convert a Neigh into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'password': password,
    };
  }

  // Create a Neigh from a Map
  factory Neigh.fromMap(Map<String, dynamic> map) {
    return Neigh(
      id: map['id'] ?? '',
      password: map['password'] ?? '',
    );
  }
}

class NeighService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _neighCollection => _firestore.collection('neighs');

  // Generate a new ID for Neigh
  Future<String> _generateNeighId() async {
    try {
      QuerySnapshot querySnapshot = await _neighCollection.orderBy('id', descending: true).limit(1).get();
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

  // Create a new Neigh
  Future<String?> createNeigh(String password) async {
    try {
      String newId = await _generateNeighId();
      Neigh neigh = Neigh(id: newId, password: password);
      await _neighCollection.doc(neigh.id).set(neigh.toMap());
      return newId;
    } catch (e) {
      print('Error creating Neigh: $e');
      return null;
    }
  }

  // Check Neigh by ID
  Future<bool> doesNeighExist(String id) async {
    try {
      DocumentSnapshot doc = await _neighCollection.doc(id).get();
      if (doc.exists) {
        return true;
      } else {
        print('Neigh not found');
        return false;
      }
    } catch (e) {
      print('Error getting Neigh: $e');
      return false;
    }
  }

  // Read Neigh by ID
  Future<Neigh?> getNeigh(String id) async {
    try {
      DocumentSnapshot doc = await _neighCollection.doc(id).get();
      if (doc.exists) {
        return Neigh.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Neigh not found');
        return null;
      }
    } catch (e) {
      print('Error getting Neigh: $e');
      return null;
    }
  }

  // Update Neigh (example of updating the password)
  Future<bool> updateNeighPassword(String id, String newPassword) async {
    try {
      await _neighCollection.doc(id).update({'password': newPassword});
      return true;
    } catch (e) {
      print('Error updating Neigh: $e');
      return false;
    }
  }

  // Delete Neigh by ID
  Future<bool> deleteNeigh(String id) async {
    try {
      await _neighCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting Neigh: $e');
      return false;
    }
  }

  // Validate that the provided ID and password match the stored password
  Future<bool> validateNeighCredentials(String id, String password) async {
    try {
      DocumentSnapshot doc = await _neighCollection.doc(id).get();
      if (doc.exists) {
        String storedPassword = doc['password'];
        return storedPassword == password;
      } else {
        print('Neigh not found');
        return false;
      }
    } catch (e) {
      print('Error validating Neigh credentials: $e');
      return false;
    }
  }
}
