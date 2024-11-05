import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'full_image_page.dart';
import '../bloc/my_state_bloc.dart';

class CategoryImagesPage extends StatefulWidget {
  final String category; // The selected category name

  const CategoryImagesPage({required this.category, super.key});

  @override
  _CategoryImagesPageState createState() => _CategoryImagesPageState();
}

class _CategoryImagesPageState extends State<CategoryImagesPage> {
  int page = 1; // Track the current page for pagination

  @override
  void initState() {
    super.initState();
    _fetchPhotos(); // Fetch photos when the page initializes
  }

  /// Fetch photos for the selected category and current page
  void _fetchPhotos() {
    context
        .read<PhotoGalleryBloc>()
        .add(FetchPhotoGalleryPhotos(widget.category, page: page));
  }

  /// Refresh function to load the next page of photos
  Future<void> _refreshPage() async {
    setState(() {
      page++; // Increment page to fetch the next set of images
    });
    _fetchPhotos(); // Fetch photos for the new page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category), // Display the selected category in the title
      ),
      body: BlocBuilder<PhotoGalleryBloc, PhotoGalleryState>(
        builder: (context, state) {
          if (state is PhotoGalleryLoading) {
            // Show a loading indicator while photos are being fetched
            return Center(child: CircularProgressIndicator());
          } else if (state is PhotoGalleryError) {
            // Show an error message if fetching fails
            return Center(
              child: Text(
                state.message, // Error message from the state
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (state is PhotoGalleryLoaded) {
            // When photos are successfully loaded
            final categoryPhotos = state.photos; // Get photos from loaded state
            return categoryPhotos.isEmpty
                ? Center(
              // Show message if no photos are available
              child: Text(
                'No photos available for the selected category.',
                style: TextStyle(fontSize: 18),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display photos in 2 columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 3, // Aspect ratio for images
              ),
              itemCount: categoryPhotos.length, // Number of photos to display
              itemBuilder: (context, index) {
                final photo = categoryPhotos[index]; // Get photo at the current index
                return GestureDetector(
                  // Navigate to a fullscreen view of the photo on tap
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImagePage(photo: photo),
                      ),
                    );
                  },
                  child: GridTile(
                    // Display each photo in a grid tile with a description footer
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Rounded corners for the image
                      child: CachedNetworkImage(
                        imageUrl: photo.imageUrl, // Image URL from photo data
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(), // Placeholder while loading
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error), // Error widget
                        fit: BoxFit.cover, // Fit the image to cover the tile
                      ),
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        photo.description.isNotEmpty ? photo.description : "No Description",
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                      subtitle: Text(
                        'By: ${photo.photographer}', // Show photographer's name
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // Default loading indicator while in an unknown state
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
