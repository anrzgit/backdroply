import 'package:flutter/material.dart';
import 'package:wallpaper_app/logic/download_image.dart';

class FullscreenPhotoPage extends StatefulWidget {
  const FullscreenPhotoPage({
    super.key,
    required this.id,
    required this.displayUrl,
    required this.fullUrl,
    this.authorName,
  });

  final String id;
  final String displayUrl; // regular (fast to show)
  final String fullUrl; // full-size (tap to open/share/use)
  final String? authorName;

  @override
  State<FullscreenPhotoPage> createState() => _FullscreenPhotoPageState();
}

class _FullscreenPhotoPageState extends State<FullscreenPhotoPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.authorName ?? 'Photo',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            tooltip: 'Download',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(
                const SnackBar(content: Text('Downloading...')),
              );
              try {
                await Downloadimage().saveUnsplashImage(
                  photoId: widget.id,
                  imageUrl: widget
                      .fullUrl, // use 'full' for best quality; 'regular' for faster download
                );
                if (context.mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Saved to gallery')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  print('Download error: $e');
                  messenger.showSnackBar(
                    SnackBar(content: Text('Download failed: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.download_rounded, color: Colors.white),
          ),
          IconButton(
            tooltip: 'Open full',
            onPressed: () {
              // Optionally open fullUrl in a browser or show a bottom sheet
              // with share/save actions. For now: simple dialog with the URL.
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Full image URL'),
                  content: Text(widget.fullUrl),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: 'photo_${widget.id}',
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Image.network(
              // Start with displayUrl (faster). You can switch to fullUrl after first frame if you want.
              widget.displayUrl,
              fit: BoxFit.contain,
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image,
                color: Colors.white70,
                size: 48,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.authorName == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Photo by ${widget.authorName} on Unsplash',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
    );
  }
}
