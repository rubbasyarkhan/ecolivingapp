import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

class ImagePickerSingle extends StatelessWidget {
  final String? base64Image;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const ImagePickerSingle({
    Key? key,
    required this.base64Image,
    required this.onPickImage,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;

    if (base64Image != null && base64Image!.isNotEmpty) {
      try {
        imageBytes = base64Decode(base64Image!);
      } catch (_) {
        imageBytes = null;
      }
    }

    return GestureDetector(
      onTap: base64Image == null ? onPickImage : null,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: imageBytes != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      imageBytes,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: onRemoveImage,
                    ),
                  ),
                ],
              )
            : const Center(
                child: Icon(Icons.add, size: 30, color: Colors.grey),
              ),
      ),
    );
  }
}
