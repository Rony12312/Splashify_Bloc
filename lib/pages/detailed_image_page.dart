import 'package:flutter/material.dart';
import '../photo_model.dart'; // Make sure you have a photo model containing the image details

class DetailedImagePage extends StatelessWidget {
  final Photo photo; // This is the photo object with all the details
  final List<String>
      relatedCategories; // Related categories to show below the image

  const DetailedImagePage({
    required this.photo,
    required this.relatedCategories,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            photo.description.isNotEmpty ? photo.description : "Image Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image at the top
            Image.asset(
              photo.imageUrl, // Load the image using its path
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Show image details like description, photographer, and resolution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photographer name
                  Text(
                    "Photographer: ${photo.photographer}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    photo.description.isNotEmpty
                        ? photo.description
                        : "No Description",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // Image resolution (width x height)
                  Text(
                    "Resolution: ${photo.width} x ${photo.height}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Related Categories Section
                  const Text(
                    "Related Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Show related categories as chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: relatedCategories.map((category) {
                      return Chip(
                        label: Text(category),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
