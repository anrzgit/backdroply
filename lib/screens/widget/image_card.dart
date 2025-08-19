import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/screens/fullscreen_photo_page.dart';

class Imagecard extends StatelessWidget {
  const Imagecard({super.key, required this.photos});
  final List<Map<String, dynamic>> photos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            QuiltedGridTile(3, 2),
            QuiltedGridTile(2, 2),
            QuiltedGridTile(2, 2),
            QuiltedGridTile(2, 2),
          ],
        ),

        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          final p = photos[index];
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
        }, childCount: photos.length),
      ),
    );
  }
}
