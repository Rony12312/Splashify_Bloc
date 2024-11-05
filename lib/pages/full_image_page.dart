import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart'; // Import for sharing the image
import '../photo_model.dart';

class FullImagePage extends StatelessWidget {
  final Photo photo;

  const FullImagePage({required this.photo, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Display the image description as title or "Image" if empty
          photo.description.isNotEmpty ? photo.description : "Image",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await requestPermissions(); // Ensure permissions are granted
              await downloadImage(photo.downloadLink); // Download image
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the image, with tap to view in full resolution
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OriginalImagePage(photo: photo),
                    ),
                  );
                },
                child: Image.network(photo.imageUrl),
              ),
              SizedBox(height: 20),

              // Display photographer and image resolution details
              Text(
                "Photographer: ${photo.photographer}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Resolution: ${photo.width} x ${photo.height}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 20),

              // Download button with icon and text
              ElevatedButton.icon(
                onPressed: () async {
                  await requestPermissions(); // Check permissions before download
                  await downloadImage(photo.downloadLink); // Trigger download
                },
                icon: Icon(Icons.download_rounded, color: Colors.white),
                label: Text(
                  "Download",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5, // Adds button shadow
                ),
              ),
              SizedBox(height: 20),

              // Share button to share the image URL
              ElevatedButton.icon(
                onPressed: () async {
                  await shareImage(photo.downloadLink, photo.imageUrl); // Share image and link
                },
                icon: Icon(Icons.share, color: Colors.white),
                label: Text(
                  "Share",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5, // Adds button shadow
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Request storage permissions if not already granted
  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Download the image from the provided URL
  Future<void> downloadImage(String imageUrl) async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Get the external storage directory for saving the image
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("Unable to get the directory");
      }
      final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Fetch and save the image data
      final response = await http.get(Uri.parse(imageUrl));
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      print('Image downloaded to: $filePath');
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  // Share the image with a download link using share_plus
  Future<void> shareImage(String downloadLink, String imageUrl) async {
    try {
      // Download the image temporarily for sharing
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(imagePath);
      await file.writeAsBytes(response.bodyBytes);

      // Prepare the image file for sharing
      final xFile = XFile(imagePath);

      // Share the image file with the download link
      await Share.shareXFiles(
        [xFile],
        text: 'Check out this image! Download it here: $downloadLink',
      );
    } catch (e) {
      print('Error sharing image: $e');
    }
  }
}

// Page to display the image at its full resolution
class OriginalImagePage extends StatelessWidget {
  final Photo photo;

  const OriginalImagePage({required this.photo, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Image'),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Enable panning
          scaleEnabled: true, // Enable zooming
          child: Image.network(
            photo.imageUrl,
            width: photo.width.toDouble(),
            height: photo.height.toDouble(),
          ),
        ),
      ),
    );
  }
}
