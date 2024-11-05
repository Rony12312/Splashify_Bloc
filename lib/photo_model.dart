import 'dart:convert';
import 'package:http/http.dart' as http;

/// A model class representing a Photo.
class Photo {
  final String id; // Unique identifier for the photo
  final String description; // Description of the photo
  final String imageUrl; // URL for the image
  final String photographer; // Name of the photographer
  final int width; // Property for image width
  final int height; // Property for image height
  final String downloadLink; // Property for download link

  Photo({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.photographer,
    required this.width,
    required this.height,
    required this.downloadLink,
  });

  /// Creates a Photo instance from a JSON object
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'], // Extract the photo ID
      description: json['description'] ?? 'No description', // Handle null case
      imageUrl: json['urls']['regular'], // Extract regular image URL
      photographer: json['user']['name'], // Extract photographer's name
      width: json['width'], // Extract image width
      height: json['height'], // Extract image height
      downloadLink: json['links']['download'], // Extract download link
    );
  }

  /// Converts a Photo instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'urls': {'regular': imageUrl}, // URL as a nested object
      'user': {'name': photographer}, // Photographer as a nested object
      'width': width,
      'height': height,
      'links': {'download': downloadLink}, // Download link as a nested object
    };
  }
}

/// Unsplash API class to fetch photos
class UnsplashApi {
  final String accessKey = 'alGyBoMvpbxRJF3oquApAUeqn5t84GXDKdinNrXOZ64'; // Unsplash API access key
  static const String _baseUrl = 'https://api.unsplash.com'; // Base URL for Unsplash API

  /// Search photos method
  Future<List<Photo>> searchPhotos(String query, {int page = 1, int timestamp = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/photos?query=$query&page=$page'), // Added page parameter for pagination
      headers: {
        'Authorization': 'Client-ID $accessKey', // Set the authorization header with the access key
      },
    );

    // Check the response status
    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Decode the response body
      List<Photo> photos = (data['results'] as List).map((photo) {
        return Photo.fromJson(photo); // Map each result to a Photo instance
      }).toList();

      return photos; // Return the list of photos
    } else {
      throw Exception('Failed to load photos'); // Handle errors
    }
  }

  /// Fetch multiple random photos
  Future<List<Photo>> getRandomPhotos({int count = 10}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/photos/random?count=$count'), // Added count parameter to specify number of photos
      headers: {
        'Authorization': 'Client-ID $accessKey', // Set the authorization header
      },
    );

    // Check the response status
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List; // Decode and cast response body to List
      return data.map((photo) => Photo.fromJson(photo)).toList(); // Map each result to a Photo instance
    } else {
      throw Exception('Failed to load random photos'); // Handle errors
    }
  }

  /// Generic method to fetch photos by category
  Future<List<Photo>> getPhotosByCategory(String category) async {
    return searchPhotos(category); // Using searchPhotos method for category fetching
  }

  /// Wildlife photos method
  Future<List<Photo>> getWildlifePhotos() => getPhotosByCategory('wildlife');

  /// Nature photos method
  Future<List<Photo>> getNaturePhotos() => getPhotosByCategory('nature');

  /// Food photos method
  Future<List<Photo>> getFoodPhotos() => getPhotosByCategory('food');

  /// City photos method
  Future<List<Photo>> getCityPhotos() => getPhotosByCategory('city');
}
