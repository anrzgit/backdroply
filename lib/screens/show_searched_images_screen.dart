import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/search_bloc/images_bloc.dart';
import 'package:wallpaper_app/screens/widget/image_card.dart';

class ShowSearchedImagesScreen extends StatelessWidget {
  const ShowSearchedImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (context, state) {
          if (state is ImagesInitial) {
            return const Center(child: Text('Welcome! Search for photos.'));
          }
          if (state is ImagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ImagesError) return Center(child: Text(state.message));
          if (state is ImagesLoaded) {
            final photos = state.photos;
            return Imagecard(photos: photos);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
