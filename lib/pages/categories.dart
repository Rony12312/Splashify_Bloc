import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/my_state_bloc.dart';
import 'category_images_page.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    // Define categories locally; consider fetching from an API or data source in a real app
    final List<Map<String, String>> categories = [
      {'name': 'Wild Life', 'imagePath': 'images/wildlife.jpg'},
      {'name': 'Nature', 'imagePath': 'images/nature.jpg'},
      {'name': 'Food', 'imagePath': 'images/ff.jpg'},
      {'name': 'City', 'imagePath': 'images/city.jpg'},
      // Add more categories as needed
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40), // Top margin for the container
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Categories", // Title for the categories section
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space between title and category list
              ...categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    // Dispatch event to fetch photos for the selected category
                    BlocProvider.of<PhotoGalleryBloc>(context)
                        .add(FetchPhotoGalleryPhotos(category['name']!));

                    // Navigate to the category images page with the selected category name
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<PhotoGalleryBloc>(), // Pass the current PhotoGalleryBloc
                          child: CategoryImagesPage(
                            category: category['name']!, // Pass actual category name
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width, // Full width of the screen
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30), // Clip the image with rounded corners
                          child: Image.asset(
                            category['imagePath']!, // Image path from category data
                            width: MediaQuery.of(context).size.width, // Full width of the container
                            height: 180, // Fixed height for category images
                            fit: BoxFit.cover, // Cover the entire container
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30), // Rounded corners for the overlay
                            color: Colors.black26, // Semi-transparent overlay color
                          ),
                          height: 180, // Fixed height for overlay
                          child: Center(
                            child: Text(
                              category['name']!, // Display category name
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 28, // Font size for the category name
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
