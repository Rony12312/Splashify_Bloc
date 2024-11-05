import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled9/bloc/my_state_bloc.dart'; // Import your BLoC file for state management
import 'package:untitled9/pages/bottomnav.dart'; // Import the Bottom Navigation page
import 'package:untitled9/photo_model.dart'; // Import UnsplashApi for fetching photos

void main() {
  runApp(const MyApp()); // Run the MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor with key for widget identification

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoGalleryBloc>( // Provide the PhotoGalleryBloc to the widget tree
          create: (context) => PhotoGalleryBloc(UnsplashApi()), // Initialize the PhotoGalleryBloc with UnsplashApi
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Disable the debug banner
        title: 'Splashify', // Title of the application
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Define color scheme for the app
          useMaterial3: true, // Use Material 3 design
        ),
        home: const BottomNav(), // Set the home widget to BottomNav
      ),
    );
  }
}
