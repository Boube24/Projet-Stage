import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCard extends StatelessWidget {

  final List<File> images;

  final Function(File file) onImageAdded;

  const ImagePickerCard({
    super.key,
    required this.images,
    required this.onImageAdded,
  });

  Future<void> _pickImage(
      ImageSource source) async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {

      onImageAdded(
        File(image.path),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Photos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Caméra"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galerie"),
                  ),
                ),
              ],
            ),

            if (images.isNotEmpty) ...[
              const SizedBox(height: 15),
              Text(
                "${images.length} photo(s) sélectionnée(s)",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}