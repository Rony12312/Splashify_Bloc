import 'package:flutter/material.dart';
import 'category_images_page.dart'; // Import the new page to display images

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final List<Map<String, String>> categories = [
    {'name': 'Wild Life', 'imagePath': 'images/wildlife.jpg'},
    {'name': 'Nature', 'imagePath': 'images/nature.jpg'},
    {'name': 'Food', 'imagePath': 'images/ff.jpg'},
    {'name': 'City', 'imagePath': 'images/city.jpg'},
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the category images page with the selected category
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryImagesPage(category: category['name']!),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            category['imagePath']!,
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black26,
                          ),
                          height: 180,
                          child: Center(
                            child: Text(
                              category['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
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
