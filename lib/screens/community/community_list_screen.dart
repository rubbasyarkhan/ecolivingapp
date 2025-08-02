import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/community_service.dart';
import '../../models/community_model.dart';
import 'widgets/community_card.dart';
import 'community_feed_screen.dart';

class CommunityListScreen extends StatefulWidget {
  const CommunityListScreen({Key? key}) : super(key: key);

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  final CommunityService _communityService = CommunityService();
  List<Community> _communities = [];
  List<String> _subscriptions = [];
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    final communities = await _communityService.fetchCommunities();
    final subs = await _communityService.getUserSubscriptions(userId);

    setState(() {
      _communities = communities;
      _subscriptions = subs;
    });
  }

  Future<void> _toggleSubscription(String communityId) async {
    final isSubscribed = _subscriptions.contains(communityId);

    if (isSubscribed) {
      await _communityService.unsubscribeFromCommunity(userId, communityId);
      _subscriptions.remove(communityId);
    } else {
      await _communityService.subscribeToCommunity(userId, communityId);
      _subscriptions.add(communityId);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: const Text(
          'Communities',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
      ),
      body: _communities.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _communities.length,
              itemBuilder: (context, index) {
                final community = _communities[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommunityFeedScreen(
                          community: community,
                          userSubscribed: _subscriptions.contains(community.id),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: CommunityCard(
                      community: community,
                      isSubscribed: _subscriptions.contains(community.id),
                      onSubscribeToggle: () => _toggleSubscription(community.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
