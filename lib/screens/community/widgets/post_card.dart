import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/post_model.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Uint8List> decodedImages = [];

    if (post.images != null && post.images!.isNotEmpty) {
      for (var base64 in post.images!) {
        try {
          decodedImages.add(base64Decode(base64));
        } catch (_) {
          // skip broken image
        }
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6, // Slightly larger elevation for a better shadow effect
      shadowColor: Colors.black.withOpacity(0.2), // Soft shadow
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              post.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              maxLines: 3, // Limiting the description lines
              overflow: TextOverflow.ellipsis, // Add ellipsis for overflow text
            ),
            const SizedBox(height: 12),

            // Images (horizontal scroll)
            if (decodedImages.isNotEmpty)
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: decodedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        decodedImages[index],
                        width: 250,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            // Created At
            Text(
              'Posted on ${post.createdAt != null ? DateFormat.yMMMMd().format(post.createdAt!) : 'Unknown'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
