import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../photo_model.dart'; // Import your Photo model
import 'full_image_page.dart'; // Import the FullImagePage

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final UnsplashApi unsplashApi = UnsplashApi(); // Create UnsplashApi instance
  List<Photo> searchResults = []; // Store search results
  String query = ''; // Store the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
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
            // Search Input Field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(fontFamily: "Poppins"),
                  suffixIcon: Icon(Icons.search),
                ),
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  setState(() {
                    query = value; // Update query on change
                  });
                  searchPhotos(); // Call the search method on query change
                },
              ),
            ),
            SizedBox(height: 20),
            // Display search results using the grid
            Expanded(child: SearchResultsGrid(photos: searchResults)),
          ],
        ),
      ),
    );
  }

  // Method to fetch search results
  Future<void> searchPhotos() async {
    if (query.isNotEmpty) {
      try {
        List<Photo> results = await unsplashApi.searchPhotos(query);
        setState(() {
          searchResults = results; // Update search results
        });
      } catch (e) {
        print('Error fetching search results: $e');
      }
    } else {
      setState(() {
        searchResults = []; // Clear results if query is empty
      });
    }
  }
}

// SearchResultsGrid Widget
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
        return GestureDetector(
          onTap: () {
            // Navigate to FullImagePage when tapped
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
                  child: CircularProgressIndicator(), // Show loading spinner
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                // Show error icon if image fails
                fit: BoxFit.cover, // Cover the entire tile with the image
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(
                photo.description.isNotEmpty
                    ? photo.description
                    : "No Description",
                style: TextStyle(fontFamily: "Poppins"),
              ),
              subtitle: Text(
                'By: ${photo.photographer}',
                style: TextStyle(fontFamily: "Poppins"),
              ),
            ),
          ),
        );
      },
    );
  }
}
