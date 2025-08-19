import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:wallpaper_app/core/secrets.dart';

class Downloadimage {
  Future<void> _trackUnsplashDownload({
    required String photoId,
    required String accessKey,
  }) async {
    final uri = Uri.https('api.unsplash.com', '/photos/$photoId/download', {
      'client_id': accessKey,
    });
    await http.get(uri).catchError((_) {});
  }

  Future<void> saveUnsplashImage({
    required String photoId,
    required String imageUrl, // Use urls.full OR build from urls.raw
    String albumName = 'Wallpapers',
  }) async {
    // 1) Track download with Unsplash
    await _trackUnsplashDownload(
      photoId: photoId,
      accessKey: AppSecrets().accessKey,
    );

    // 2) Force a direct image response (adds format/quality if missing)
    final directUrl = Uri.parse(
      '$imageUrl${imageUrl.contains('?') ? '&' : '?'}fm=jpg&q=95',
    );

    // 3) Download bytes
    final resp = await http.get(
      directUrl,
      headers: {'Accept': 'image/*', 'User-Agent': 'FlutterGallerySaver/1.0'},
    );
    if (resp.statusCode != 200) {
      throw Exception('Download failed: ${resp.statusCode}');
    }

    // Optional safety: ensure it's an image
    final ct = resp.headers['content-type'] ?? '';
    if (!ct.startsWith('image/')) {
      throw Exception('Server returned non-image content: $ct');
    }

    // 4) Write to temporary .jpg file (ensures Android sees it as image)
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/unsplash_$photoId.jpg');
    await file.writeAsBytes(resp.bodyBytes);

    // 5) Save local file to gallery
    final ok = await GallerySaver.saveImage(file.path, albumName: albumName);
    if (ok != true) {
      throw Exception('Save failed');
    }
  }
}
