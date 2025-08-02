import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:eco_living_app/models/educational_content_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class EducationalContentDetailScreen extends StatefulWidget {
  final EducationalContent content;

  const EducationalContentDetailScreen({Key? key, required this.content}) : super(key: key);

  @override
  State<EducationalContentDetailScreen> createState() => _EducationalContentDetailScreenState();
}

class _EducationalContentDetailScreenState extends State<EducationalContentDetailScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.content.type == 'video' && !kIsWeb) {
      final videoId = YoutubePlayerController.convertUrlToId(widget.content.contentUrl);
      if (videoId != null) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  Widget _buildMediaContent() {
    if (widget.content.type == 'video') {
      if (kIsWeb) {
        return SizedBox(
          height: 200,
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(widget.content.contentUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text("Watch on YouTube"),
            ),
          ),
        );
      } else if (_controller != null) {
        return YoutubePlayer(controller: _controller!);
      } else {
        return const Text("Video cannot be loaded.");
      }
    } else if (widget.content.type == 'infographic' && widget.content.thumbnail.isNotEmpty) {
      return Image.network(widget.content.thumbnail);
    } else {
      return GestureDetector(
        onTap: () async {
          final url = Uri.parse(widget.content.contentUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        child: widget.content.thumbnail.isNotEmpty
            ? Image.network(widget.content.thumbnail)
            : Container(
                height: 200,
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.description_outlined, size: 48)),
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd().format(widget.content.publishedAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMediaContent(),
            const SizedBox(height: 16),

            Text(
              widget.content.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(widget.content.type.toUpperCase()),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: Text(widget.content.category),
                  backgroundColor: Colors.blue.shade100,
                ),
                Chip(
                  label: Text(formattedDate),
                  backgroundColor: Colors.orange.shade100,
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              widget.content.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),
            if (widget.content.type != 'video')
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(widget.content.contentUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Open Content"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}