import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../photo_model.dart'; // Import your Photo model
import 'full_image_page.dart'; // Import the FullImagePage


class CategoryImagesPage extends StatefulWidget {
  final String category; // The selected category

  const CategoryImagesPage({required this.category, super.key});

  @override
  _CategoryImagesPageState createState() => _CategoryImagesPageState();
}

class _CategoryImagesPageState extends State<CategoryImagesPage> {
  List<Photo> categoryPhotos = [];
  bool isLoading = true;
  String? errorMessage; // Variable to store error message if any

  @override
  void initState() {
    super.initState();
    fetchCategoryPhotos(widget.category); // Fetch images based on the category
  }

  Future<void> fetchCategoryPhotos(String category) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null; // Clear previous errors
      });

      // Call the Unsplash API to search for photos based on the category
      final results = await UnsplashApi().searchPhotos(category);

      setState(() {
        categoryPhotos = results;
        isLoading = false;
      });

      // Handle the case when no photos are found
      if (results.isEmpty) {
        setState(() {
          errorMessage = "No photos found for the category '$category'.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching category photos: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ) // Show error message
          : categoryPhotos.isEmpty
          ? Center(
        child: Text(
          'No photos available for the selected category.',
          style: TextStyle(fontSize: 18),
        ),
      ) // Show message when no photos are found
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display 2 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio:
          2 / 3, // Adjust aspect ratio to fit images nicely
        ),
        itemCount: categoryPhotos.length,
        itemBuilder: (context, index) {
          final photo = categoryPhotos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullImagePage(photo: photo),
                ),
              );
            },
            child: GridTile(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: photo.imageUrl,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  photo.description.isNotEmpty
                      ? photo.description
                      : "No Description",
                  style: const TextStyle(fontFamily: "Poppins"),
                ),
                subtitle: Text(
                  'By: ${photo.photographer}',
                  style: const TextStyle(fontFamily: "Poppins"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
