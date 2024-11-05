import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../photo_model.dart';
import '../bloc/my_state_bloc.dart';
import 'full_image_page.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // Controller for the search input field
  final TextEditingController _searchController = TextEditingController();
  String query = ''; // Stores the current search query
  Timer? _debounce; // Timer to manage debouncing on search input

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel any active debounce timer on dispose
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  // Debounced search function that triggers after user stops typing
  void _onSearchChanged(String value) {
    query = value; // Update the query with new input
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // Cancel existing debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () { // Set new debounce timer
      if (query.isNotEmpty) {
        // Dispatch event to fetch photos if query is not empty
        context.read<PhotoGalleryBloc>().add(FetchPhotoGalleryPhotos(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            // Search page title
            Center(
              child: Text(
                "Search",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            SizedBox(height: 20),

            // Search input field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: TextField(
                controller: _searchController, // Attach controller to field
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(fontFamily: "Poppins"),
                  suffixIcon: Icon(Icons.search), // Add search icon
                ),
                textAlignVertical: TextAlignVertical.center,
                onChanged: _onSearchChanged, // Trigger onChange event
              ),
            ),
            SizedBox(height: 20),

            // BlocBuilder to handle different states from the BLoC
            Expanded(
              child: BlocBuilder<PhotoGalleryBloc, PhotoGalleryState>(
                builder: (context, state) {
                  if (state is PhotoGalleryLoading) {
                    // Display loading indicator during fetch
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PhotoGalleryLoaded) {
                    // Display the search results grid when photos are loaded
                    return SearchResultsGrid(photos: state.photos);
                  } else if (state is PhotoGalleryError) {
                    // Display error message if there's an error
                    return Center(
                      child: Text(
                        'Error fetching photos: ${state.message}',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  }
                  return SizedBox.shrink(); // Display nothing if no state change
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display search results in a grid format
class SearchResultsGrid extends StatelessWidget {
  final List<Photo> photos; // List of photos to display

  const SearchResultsGrid({required this.photos, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10, // Spacing between columns
        mainAxisSpacing: 10, // Spacing between rows
        childAspectRatio: 2 / 3, // Aspect ratio for each grid tile
      ),
      itemCount: photos.length, // Number of items to display
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
          onTap: () {
            // Navigate to full image view on tap
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
                placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Show loader while image loads
                errorWidget: (context, url, error) => Icon(Icons.error), // Show error icon on failure
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(
                photo.description.isNotEmpty ? photo.description : "No Description", // Show description or fallback
                style: TextStyle(fontFamily: "Poppins"),
              ),
              subtitle: Text(
                'By: ${photo.photographer}', // Show photographer info
                style: TextStyle(fontFamily: "Poppins"),
              ),
            ),
          ),
        );
      },
    );
  }
}
