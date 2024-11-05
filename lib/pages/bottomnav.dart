import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:untitled9/pages/search.dart';  // Correct import path for Search
import 'categories.dart';
import 'home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0; // Track the currently selected tab index
  late List<Widget> pages; // List to hold the pages corresponding to each tab
  late Home home; // Home page instance
  late Search search; // Search page instance
  late Categories categories; // Categories page instance

  late Widget currentPage; // Current page being displayed

  @override
  void initState() {
    super.initState();
    // Initialize the page instances
    home = Home();
    search = const Search();  // Ensure Search is correctly initialized
    categories = Categories();
    currentPage = home; // Set the initial current page to home
    pages = [home, search, categories]; // List of all pages to navigate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65, // Height of the navigation bar
        buttonBackgroundColor: Colors.black, // Background color of the navigation buttons
        backgroundColor: Colors.white, // Background color of the navigation bar
        color: Colors.black, // Color of the navigation items
        animationCurve: Curves.easeInOutCubicEmphasized, // Animation curve for navigation
        index: currentTabIndex, // Current selected tab index
        animationDuration: const Duration(milliseconds: 500), // Duration of the animation
        onTap: (int index) {
          setState(() {
            currentTabIndex = index; // Update the current tab index on tap
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Colors.white), // Home icon
          Icon(Icons.search_rounded, color: Colors.white), // Search icon
          Icon(Icons.category_outlined, color: Colors.white), // Categories icon
        ],
      ),
      body: pages[currentTabIndex], // Display the current page based on the selected tab
    );
  }
}
