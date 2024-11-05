import 'package:flutter_bloc/flutter_bloc.dart';
import '../photo_model.dart';

part 'my_state_state.dart';
part 'my_state_event.dart';

class PhotoGalleryBloc extends Bloc<PhotoGalleryEvent, PhotoGalleryState> {
  final UnsplashApi unsplashApi; // API instance to fetch photos

  PhotoGalleryBloc(this.unsplashApi) : super(PhotoGalleryInitial()) {
    // Event handler for photo fetching
    on<FetchPhotoGalleryPhotos>((event, emit) async {
      emit(PhotoGalleryLoading()); // Emit loading state

      try {
        List<Photo> photos; // List to store fetched photos

        // Fetch photos based on query and page number
        if (event.query.isNotEmpty) {
          // Fetch photos for specific query/category with pagination
          photos = await unsplashApi.searchPhotos(
              event.query, page: event.page, timestamp: event.timestamp);
        } else {
          // Fetch random photos if no query is provided
          photos = await unsplashApi.getRandomPhotos(count: 5);
        }

        // Emit loaded state with fetched photos
        emit(PhotoGalleryLoaded(photos));
      } catch (e) {
        // Emit error state if fetching fails
        emit(PhotoGalleryError('Error fetching photos: ${e.toString()}'));
      }
    });
  }
}
