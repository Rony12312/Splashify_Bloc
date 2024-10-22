import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../photo_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UnsplashApi unsplashApi = UnsplashApi();
  List<String> wallpaperImage = [];
  int activeIndex = 0;
  bool isLoading = true; // State variable for loading indicator

  @override
  void initState() {
    super.initState();
    fetchRandomPhotos();
  }

  Future<void> fetchRandomPhotos() async {
    try {
      for (int i = 0; i < 6; i++) {
        Photo photo = await unsplashApi.getRandomPhoto();
        setState(() {
          wallpaperImage.add(photo.imageUrl);
        });
      }
    } catch (e) {
      print('Error fetching random photos: $e');
      // Optionally update the UI to show an error message
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    "images/profile.jpg",
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(width: 60),
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
            SizedBox(height: 30),
            if (isLoading) // Show loading indicator if loading
              CircularProgressIndicator(),
            if (!isLoading && wallpaperImage.isNotEmpty) // Show carousel if not loading and images exist
              CarouselSlider.builder(
                itemCount: wallpaperImage.length,
                itemBuilder: (context, index, realIndex) {
                  final res = wallpaperImage[index];
                  return buildImage(res, index);
                },
                options: CarouselOptions(
                  autoPlay: true,
                  height: MediaQuery.of(context).size.height / 1.5,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) => setState(() {
                    activeIndex = index;
                  }),
                ),
              ),
            SizedBox(height: 20),
            if (!isLoading) Center(child: buildIndicator()),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: wallpaperImage.length, // Update count based on the number of images
    effect: SwapEffect(
      activeDotColor: Colors.blue,
      dotColor: Colors.grey,
      dotHeight: 15,
      dotWidth: 15,
    ),
  );

  Widget buildImage(String urlImage, int index) => Container(
    height: MediaQuery.of(context).size.height / 1.5,
    width: MediaQuery.of(context).size.width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.network(urlImage, fit: BoxFit.cover),
    ),
  );
}
