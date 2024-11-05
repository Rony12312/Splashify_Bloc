part of 'my_state_bloc.dart';

// Abstract class representing all states for the PhotoGalleryBloc
abstract class PhotoGalleryState {}

// Initial state when the PhotoGalleryBloc is first created
class PhotoGalleryInitial extends PhotoGalleryState {}

// Loading state emitted while fetching photos
class PhotoGalleryLoading extends PhotoGalleryState {}

// State emitted when photos are successfully loaded
class PhotoGalleryLoaded extends PhotoGalleryState {
  final List<Photo> photos; // List of photos retrieved from the API

  // Constructor to initialize the photos
  PhotoGalleryLoaded(this.photos);
}

// State emitted when an error occurs while fetching photos
class PhotoGalleryError extends PhotoGalleryState {
  final String message; // Error message describing the issue

  // Constructor to initialize the error message
  PhotoGalleryError(this.message);
}
