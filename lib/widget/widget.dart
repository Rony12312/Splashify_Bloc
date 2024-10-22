import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../photo_model.dart'; // Import your Photo model

class SearchResultsGrid extends StatelessWidget {
  final List<Photo> photos; // The list of photos to display

  const SearchResultsGrid({required this.photos, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display 2 columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2 / 3, // Adjust aspect ratio to fit images nicely
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: photo.imageUrl,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(), // Show loading spinner
              ),
              errorWidget: (context, url, error) => Icon(Icons.error), // Show error icon if image fails
              fit: BoxFit.cover, // Cover the entire tile with the image
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              photo.description.isNotEmpty ? photo.description : "No Description",
              style: TextStyle(fontFamily: "Poppins"),
            ),
            subtitle: Text(
              'By: ${photo.photographer}',
              style: TextStyle(fontFamily: "Poppins"),
            ),
          ),
        );
      },
    );
  }
}
