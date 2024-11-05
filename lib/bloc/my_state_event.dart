part of 'my_state_bloc.dart';

/// Abstract class for photo gallery events
abstract class PhotoGalleryEvent {}

/// Event for fetching photos, optionally with page and timestamp
class FetchPhotoGalleryPhotos extends PhotoGalleryEvent {
  final String query; // Search query or category name
  final int page; // Page number for pagination
  final int timestamp; // Unique timestamp for each request

  // Constructor with default page and timestamp
  FetchPhotoGalleryPhotos(this.query, {this.page = 1})
      : timestamp = DateTime.now().millisecondsSinceEpoch;
}
