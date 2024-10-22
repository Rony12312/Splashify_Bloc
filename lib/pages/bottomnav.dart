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
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Home home;
  late Search search;
  late Categories categories;

  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    home = Home();
    search = const Search();  // Ensure Search is correctly initialized
    categories = Categories();
    currentPage = home;
    pages = [home, search, categories];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        buttonBackgroundColor: Colors.black,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationCurve: Curves.easeInOutCubicEmphasized,
        index: currentTabIndex,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.search_rounded, color: Colors.white),
          Icon(Icons.category_outlined, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
