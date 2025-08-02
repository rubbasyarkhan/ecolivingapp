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
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          community.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        subtitle: Text(
          community.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onSubscribeToggle,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16), backgroundColor: isSubscribed ? const Color.fromARGB(255, 235, 235, 235) : Colors.green.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isSubscribed ? 'Unsubscribe' : 'Subscribe',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
