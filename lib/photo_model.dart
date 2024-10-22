import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashApi {
  final String accessKey = 'alGyBoMvpbxRJF3oquApAUeqn5t84GXDKdinNrXOZ64';
  static const String _baseUrl = 'https://api.unsplash.com';

  // Search photos method
  Future<List<Photo>> searchPhotos(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/photos?query=$query'),
      headers: {
        'Authorization': 'Client-ID $accessKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Photo> photos = (data['results'] as List).map((photo) {
        return Photo.fromJson(photo);
      }).toList();

      return photos;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  // Generic method to fetch photos by category
  Future<List<Photo>> getPhotosByCategory(String category) async {
    return searchPhotos(
        category); // Using searchPhotos method for category fetching
  }

  // Wildlife photos method
  Future<List<Photo>> getWildlifePhotos() => getPhotosByCategory('wildlife');

  // Nature photos method
  Future<List<Photo>> getNaturePhotos() => getPhotosByCategory('nature');

  // Food photos method
  Future<List<Photo>> getFoodPhotos() => getPhotosByCategory('food');

  // City photos method
  Future<List<Photo>> getCityPhotos() => getPhotosByCategory('city');

  // Get random photo method
  Future<Photo> getRandomPhoto() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/photos/random'),
      headers: {
        'Authorization': 'Client-ID $accessKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Photo.fromJson(data);
    } else {
      throw Exception('Failed to load random photo');
    }
  }
}

// Photo model class
class Photo {
  final String id;
  final String description;
  final String imageUrl;
  final String photographer;
  final int width; // New property for width
  final int height; // New property for height
  final String downloadLink; // New property for download link

  Photo({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.photographer,
    required this.width,
    required this.height,
    required this.downloadLink,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      description: json['description'] ?? 'No description',
      // Handle null case
      imageUrl: json['urls']['regular'],
      photographer: json['user']['name'],
      width: json['width'],
      // Get width from API response
      height: json['height'],
      // Get height from API response
      downloadLink: json['links']
          ['download'], // Get download link from API response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'urls': {'regular': imageUrl},
      'user': {'name': photographer},
      'width': width, // Include width in toJson
      'height': height, // Include height in toJson
      'links': {'download': downloadLink}, // Include download link in toJson
    };
  }
}
