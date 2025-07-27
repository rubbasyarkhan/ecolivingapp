import 'package:flutter/material.dart';
import '../../models/community_model.dart';
import '../../models/post_model.dart';
import '../../services/post_service.dart';
import 'widgets/post_card.dart';
import 'create_post_screen.dart';

class CommunityFeedScreen extends StatefulWidget {
  final Community community;
  final bool userSubscribed;

  const CommunityFeedScreen({
    Key? key,
    required this.community,
    required this.userSubscribed,
  }) : super(key: key);

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final PostService _postService = PostService();
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final posts = await _postService.fetchPosts(widget.community.id);
    if (!mounted) return; // Prevent setState if widget is disposed
    setState(() {
      _posts = posts;
    });
  }

  void _goToCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(
          communityId: widget.community.id,
        ),
      ),
    );

    if (result == true && mounted) {
      _loadPosts(); // Refresh posts after post creation
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscribed = widget.userSubscribed;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        actions: [
          if (subscribed)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _goToCreatePost,
              tooltip: 'Create Post',
            ),
        ],
      ),
      body: subscribed
          ? (_posts.isEmpty
              ? const Center(child: Text("No posts yet. Be the first!"))
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: _posts[index]);
                  },
                ))
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Subscribe to view posts in this community.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
    );
  }
}
