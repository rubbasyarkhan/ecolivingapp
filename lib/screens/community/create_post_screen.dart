import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_living_app/screens/community/widgets/image_picker_single.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class CreatePostScreen extends StatefulWidget {
  final String communityId;

  const CreatePostScreen({Key? key, required this.communityId})
      : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _base64Image;
  bool _isLoading = false;
  bool _isPickingImage = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isPickingImage = true);

    final rawBytes = await picked.readAsBytes();
    final base64 = await compute(compressAndEncode, rawBytes);

    if (base64.isNotEmpty) {
      setState(() => _base64Image = base64);
    }

    setState(() => _isPickingImage = false);
  }

  void removeImage() {
    setState(() => _base64Image = null);
  }

  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .collection('posts')
          .add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'userId': currentUser.uid,
        'images': _base64Image != null ? [_base64Image] : [],
        'createdAt': Timestamp.now(),
      });

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload post: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Image",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            _isPickingImage
                ? const CircularProgressIndicator()
                : ImagePickerSingle(
                    base64Image: _base64Image,
                    onPickImage: pickImage,
                    onRemoveImage: removeImage,
                  ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading || _isPickingImage ? null : _submitPost,
              icon: const Icon(Icons.send),
              label: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Post"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Background image compression and encoding function
Future<String> compressAndEncode(Uint8List rawBytes) async {
  final image = img.decodeImage(rawBytes);
  if (image == null) return '';
  final resized = img.copyResize(image, width: 800);
  final compressed = img.encodeJpg(resized, quality: 70);
  return base64Encode(Uint8List.fromList(compressed));
}
