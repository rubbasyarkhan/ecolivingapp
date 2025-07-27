import 'package:flutter/material.dart';
import '../../../models/community_model.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final bool isSubscribed;
  final VoidCallback onSubscribeToggle;

  const CommunityCard({
    Key? key,
    required this.community,
    required this.isSubscribed,
    required this.onSubscribeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(community.name),
        subtitle: Text(community.description),
        trailing: ElevatedButton(
          onPressed: onSubscribeToggle,
          child: Text(isSubscribed ? 'Unsubscribe' : 'Subscribe'),
        ),
      ),
    );
  }
}
  