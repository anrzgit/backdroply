import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/fullscreenPhotoPage.dart';

class Imagecard extends StatelessWidget {
  const Imagecard({super.key, required this.photos});
  final List<Map<String, dynamic>> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: photos.length,
      itemBuilder: (context, i) {
        final p = photos[i];
        final id = p['id'] as String;
        final url = p['urls']['regular'] as String; // display size
        final fullUrl = p['urls']['full'] as String; // full-size for viewer
        final name = (p['user']?['name'] as String?) ?? '';

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FullscreenPhotoPage(
                  id: id,
                  displayUrl: url,
                  fullUrl: fullUrl,
                  authorName: name,
                ),
              ),
            );
          },
          child: Hero(
            tag: 'photo_$id',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(url, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
