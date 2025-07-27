import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a post under a community
  Future<void> createPost(Post post) async {
    final postRef = _firestore
        .collection('communities')
        .doc(post.communityId)
        .collection('posts')
        .doc();

    await postRef.set(post.toJson());
  }

  // Fetch posts from a specific community
  Future<List<Post>> fetchPosts(String communityId) async {
    final snapshot = await _firestore
        .collection('communities')
        .doc(communityId)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Post.fromJson(doc.data(), doc.id))
        .toList();
  }

  // Fetch all posts from communities a user is subscribed to
  Future<List<Post>> fetchSubscribedPosts(List<String> communityIds) async {
    List<Post> allPosts = [];

    for (String communityId in communityIds) {
      final posts = await fetchPosts(communityId);
      allPosts.addAll(posts);
    }

    // Sort posts by createdAt (newest first)
    allPosts.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return allPosts;
  }
}
