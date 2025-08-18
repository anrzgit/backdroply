import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/images_bloc.dart';
import 'package:wallpaper_app/screens/widget/imageCard.dart';
import 'package:wallpaper_app/screens/widget/searchbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //
  Future<List<dynamic>>? futurePhotos; // Changed to List<dynamic>
  //

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
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
