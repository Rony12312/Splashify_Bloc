import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../bloc/my_state_bloc.dart';
import 'full_image_page.dart'; // Import the FullImagePage

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int activeIndex = 0; // Tracks the currently active index for the carousel

  @override
  void initState() {
    super.initState();
    // Fetch random photos when the page initializes
    _fetchRandomPhotos();
  }

  // Function to fetch random photos from the BLoC
  void _fetchRandomPhotos() {
    context.read<PhotoGalleryBloc>().add(FetchPhotoGalleryPhotos('')); // Trigger fetch with empty query for random photos
  }

  // Refresh function to reload photos on pull-to-refresh
  Future<void> _refreshPage() async {
    _fetchRandomPhotos(); // Fetch new photos on refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPage, // Handle pull-to-refresh
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20), // Margin for page layout
              child: Column(
                children: [
                  // Profile section with app logo and title
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60), // Rounded profile image
                        child: Image.asset(
                          "images/profile.jpg",
                          height: 50,
                          width: 50,
                        ),
                      ),
                      SizedBox(width: 60), // Space between profile image and title
                      Text(
                        "Splashify",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Space after profile section

                  // BlocBuilder for handling different states from PhotoGalleryBloc
                  BlocBuilder<PhotoGalleryBloc, PhotoGalleryState>(
                    builder: (context, state) {
                      if (state is PhotoGalleryLoading) {
                        // Show loading spinner while photos are being fetched
                        return Center(child: CircularProgressIndicator());
                      } else if (state is PhotoGalleryLoaded) {
                        // Show photo carousel when photos are successfully loaded
                        return buildPhotoCarousel(state); // Pass loaded state to carousel builder
                      } else if (state is PhotoGalleryError) {
                        // Display error message if photo fetch fails
                        return Text(
                          'Error fetching photos: ${state.message}',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        );
                      }
                      return SizedBox.shrink(); // Placeholder for initial or unknown states
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the photo carousel when photos are successfully loaded
  Widget buildPhotoCarousel(PhotoGalleryLoaded state) {
    if (state.photos.isEmpty) {
      // Display a message if no photos are available
      return Center(
        child: Text(
          'No photos available.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        // CarouselSlider displays images with specified configurations
        CarouselSlider.builder(
          itemCount: state.photos.length, // Total number of photos
          itemBuilder: (context, index, realIndex) {
            final res = state.photos[index].imageUrl; // Fetch image URL for each photo
            return buildImage(res, index, state); // Build each image with provided state
          },
          options: CarouselOptions(
            autoPlay: true, // Automatically scrolls the carousel
            height: MediaQuery.of(context).size.height / 1.4, // Carousel height relative to screen
            viewportFraction: 1, // Display only one image at a time
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index, reason) => setState(() {
              activeIndex = index; // Update active index on page change
            }),
          ),
        ),
        SizedBox(height: 20), // Space between carousel and indicator
        Center(child: buildIndicator(state.photos.length)), // Build carousel indicator
        SizedBox(height: 40), // Space before any bottom content
      ],
    );
  }

  // Widget to build indicator dots for the carousel
  Widget buildIndicator(int photoCount) {
    return photoCount > 0
        ? AnimatedSmoothIndicator(
      activeIndex: activeIndex, // Shows the active index dot as highlighted
      count: photoCount, // Total number of dots
      effect: SwapEffect(
        activeDotColor: Colors.blue,
        dotColor: Colors.grey,
        dotHeight: 15,
        dotWidth: 15,
      ),
    )
        : SizedBox.shrink(); // Empty widget if there are no photos
  }

  // Method to build each individual image in the carousel
  Widget buildImage(String urlImage, int index, PhotoGalleryLoaded state) => GestureDetector(
    onTap: () {
      // Navigate to FullImagePage with selected photo on tap
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullImagePage(
            photo: state.photos[index], // Pass the selected photo object to new page
          ),
        ),
      );
    },
    child: Container(
      height: MediaQuery.of(context).size.height / 1.5, // Container height relative to screen
      width: MediaQuery.of(context).size.width, // Full screen width
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Rounded corners for images
        child: Image.network(urlImage, fit: BoxFit.cover), // Display image from URL
      ),
    ),
  );
}
