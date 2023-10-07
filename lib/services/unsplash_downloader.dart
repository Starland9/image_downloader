import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class UnsplashDownloader {
  static const _baseUrl = 'https://unsplash.com/fr/s/photos/';

  static Future<List<String>> getImagesUrls({required String query}) async {
    final response = await http.get(Uri.parse('$_baseUrl/$query'));
    final body = response.body;

    return _extractImageUrls(body);
  }

  static Future<List<String>> getMoreImagesUrls(
      {required String query, required int page}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?query=$query&page=$page'),
    );
    final body = response.body;

    return _extractImageUrls(body);
  }

  static Future<void> downloadImages(List<String> imageUrls) async {
    for (int i = 0; i < imageUrls.length; i++) {
      final imageUrl = imageUrls[i];
      try {
        final response = await http.get(Uri.parse(imageUrl));
        final bytes = response.bodyBytes;
        final title = 'image_$i';

        PermissionStatus status = await Permission.storage.request();
        if (status.isGranted) {
          final dir =
              Directory('/storage/emulated/0/Starland/Images Downloader/');
          if (!dir.existsSync()) {
            dir.createSync(recursive: true);
          }
          final file = File('${dir.path}$title.png');
          await file.writeAsBytes(bytes);
        } else {
          throw 'Permission not granted';
        }
      } catch (e) {
        throw 'Error downloading image: $e';
      }
    }
  }

  static List<String> _extractImageUrls(String html) {
    final document = parser.parse(html);
    final List<String> imageUrls = [];

    final elements = document.getElementsByTagName('img');
    for (final element in elements) {
      final imageUrl = element.attributes['src'];
      final imageTitle = element.attributes['title'];
      if (imageUrl != null &&
          imageTitle != null &&
          imageUrls.contains(imageUrl) == false) {
        imageUrls.add(imageUrl);
      }
    }

    return imageUrls;
  }
}
