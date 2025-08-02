import 'package:flutter/material.dart';
import 'package:eco_living_app/models/educational_content_model.dart';

class EducationalContentCard extends StatelessWidget {
  final EducationalContent content;
  final VoidCallback onTap;

  const EducationalContentCard({
    Key? key,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  // Icon Mapping for Content Types
  IconData _getIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'video':
        return Icons.play_circle_fill;
      case 'infographic':
        return Icons.image;
      case 'article':
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,  // Slightly higher elevation for a playful depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),  // More rounded corners
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.green.shade50,  // Light background color for the card
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Thumbnail with rounded corners
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                content.thumbnail,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content Info Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with ellipsis for overflow
                    Text(
                      content.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green.shade800, // Vibrant green for the title
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Description with ellipsis for overflow
                    Text(
                      content.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green.shade700,  // Darker green for description
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Category and Icon
                    Row(
                      children: [
                        Icon(
                          _getIcon(content.type),
                          size: 20,
                          color: Colors.green.shade600,  // Slightly darker icon color
                        ),
                        const SizedBox(width: 8),
                        Text(
                          content.category.isNotEmpty
                              ? content.category
                              : "Uncategorized",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade600,  // Green text for category
                                fontStyle: FontStyle.italic,  // Slightly italicized category
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
