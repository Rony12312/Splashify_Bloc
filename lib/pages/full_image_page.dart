import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
// For opening the download link in a browser
import 'package:share_plus/share_plus.dart'; // Import share_plus package
import '../photo_model.dart';

class FullImagePage extends StatelessWidget {
  final Photo photo;

  const FullImagePage({required this.photo, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          photo.description.isNotEmpty ? photo.description : "Image",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await requestPermissions(); // Ensure permissions are granted
              await downloadImage(photo.downloadLink); // Call the download function
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

              // Photographer and resolution details with appealing styles
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

              // Beautiful download button
              ElevatedButton.icon(
                onPressed: () async {
                  await requestPermissions(); // Ensure permissions are granted
                  await downloadImage(photo.downloadLink); // Call the download function
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
                  elevation: 5, // Add shadow for depth
                ),
              ),
              SizedBox(height: 20),

              // Share button for sharing the image
              ElevatedButton.icon(
                onPressed: () async {
                  await shareImage(photo.downloadLink, photo.imageUrl); // Share the image with the link
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
                  elevation: 5, // Add shadow for depth
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Function to request storage permissions
  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  // Function to download the image
  Future<void> downloadImage(String imageUrl) async {
    try {
      // Check for permissions
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Get the directory to save the image
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("Unable to get the directory");
      }
      final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Fetch the image data
      final response = await http.get(Uri.parse(imageUrl));
      final file = File(filePath);

      // Write the image data to the file
      await file.writeAsBytes(response.bodyBytes);
      print('Image downloaded to: $filePath');
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  // Function to share the image with the link using share_plus
  Future<void> shareImage(String downloadLink, String imageUrl) async {
    try {
      // Download the image to share
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(imagePath);
      await file.writeAsBytes(response.bodyBytes);

      // Convert the file path to XFile (which shareFiles expects)
      final xFile = XFile(imagePath);

      // Share the image and the download link
      await Share.shareXFiles(
        [xFile],
        text: 'Check out this image! Download it here: $downloadLink',
      );
    } catch (e) {
      print('Error sharing image: $e');
    }
  }
}

// New Page to display the image in its original dimensions
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
          panEnabled: true, // Allow panning
          scaleEnabled: true, // Allow zooming
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
