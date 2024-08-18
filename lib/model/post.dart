import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doorbell/components/avatar.dart';

class Post {
  final String? id;
  final String userId;
  final String userName;
  final String avatarPath;
  final Color avatarColor;
  String title;
  String description;
  List<String> images;
  final DateTime timestamp;

  Post({
    this.id,
    required this.userId,
    required this.userName,
    required this.avatarPath,
    required this.avatarColor,
    required this.title,
    required this.description,
    required this.images,
    required this.timestamp,
  });

  // Factory method to create a Post from a Firestore document snapshot
  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      userName: data['userName'],
      userId: data['userId'],
      avatarPath: data['avatarPath'],
      avatarColor: Color(data['avatarColor'] ?? 0xFFFFFFFF), // Convert integer back to Color
      title: data['title'],
      description: data['description'],
      images: List<String>.from(data['images']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Method to convert a Post to a Firestore document
  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'userName': userName,
      'avatarPath': avatarPath,
      'avatarColor': avatarColor.value,
      'title': title,
      'description': description,
      'images': images,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

// Post functions

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _postCollection => _firestore.collection('posts');

  Future<bool> createPost(Post post) async {
    try {
      // Generate a unique document ID
      DocumentReference docRef = _postCollection.doc();
      // Set the generated ID in the Post object
      Post postWithId = Post(
        id: docRef.id,
        userId: post.userId,
        userName: post.userName,
        avatarPath: post.avatarPath,
        avatarColor: post.avatarColor,
        title: post.title,
        description: post.description,
        images: post.images,
        timestamp: post.timestamp,
      );
      // Add the post to Firestore
      await docRef.set(postWithId.toDocument());
      return true;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  Future<Post?> getPost(String postId) async {
    try {
      DocumentSnapshot doc = await _postCollection.doc(postId).get();
      return Post.fromDocument(doc);
    } catch (e) {
      print('Error fetching post: $e');
      return null;
    }
  }

  Future<bool> updatePost(Post post) async {
    try {
      if (post.id != null) {
        await _postCollection.doc(post.id).update(post.toDocument());
        return true;
      } else {
        print('Error updating post: Post ID is null');
        return false;
      }
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      await _postCollection.doc(postId).delete();
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }
}
