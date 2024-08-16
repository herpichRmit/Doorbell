//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doorbell/components/avatar.dart';

class Post {
  final String id;
  final Avatar avatar;
  final String title;
  final String description;
  final List<String> images;
  final DateTime timestamp;
  final List<String> readBy;

  Post({
    required this.id,
    required this.avatar,
    required this.title,
    required this.description,
    required this.images,
    required this.timestamp,
    required this.readBy,
  });

  /*
  // Factory method to create a Post from a Firestore document snapshot
  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      avatarUrl: data['avatarUrl'],
      title: data['title'],
      description: data['description'],
      images: List<String>.from(data['images']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(data['readBy']),
    );
  }

  // Method to convert a Post to a Firestore document
  Map<String, dynamic> toDocument() {
    return {
      'avatarUrl': avatarUrl,
      'title': title,
      'description': description,
      'images': images,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
    };
  }
  */
}

// Post functions

/*

CREATE
Future<void> createPost(Post post) async {
  try {
    await FirebaseFirestore.instance.collection('posts').add(post.toDocument());
  } catch (e) {
    print('Error creating post: $e');
  }
}

READ SINGLE
Future<Post?> getPost(String postId) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
    return Post.fromDocument(doc);
  } catch (e) {
    print('Error fetching post: $e');
    return null;
  }
}

UPDATE
Future<void> updatePost(Post post) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(post.id).update(post.toDocument());
  } catch (e) {
    print('Error updating post: $e');
  }
}

DELETE
Future<void> deletePost(String postId) async {
  try {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  } catch (e) {
    print('Error deleting post: $e');
  }
}



*/