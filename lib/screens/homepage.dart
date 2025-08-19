import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/topic_images_bloc/topic_images_bloc.dart';
import 'package:wallpaper_app/screens/widget/category_controller.dart';
import 'package:wallpaper_app/screens/widget/image_card.dart';
import 'package:wallpaper_app/screens/widget/searchbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> categories = const ['Nature', 'Travel', 'People'];

  String? _currentSlug; // UI guard to prevent duplicate dispatches

  @override
  void initState() {
    super.initState();
    // Load default topic once
    _currentSlug = 'nature';
    context.read<TopicImagesBloc>().add(
      FetchTopicPhotos(
        slug: _currentSlug!,
        page: 1,
        perPage: 30,
        orderBy: 'latest',
        orientation: 'portrait',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryScroller(
            categories: categories,
            initialIndex: 0,
            onSelected: (i) {
              final slug = categories[i].toLowerCase();
              if (_currentSlug == slug) return; // UI guard
              setState(() => _currentSlug = slug);
              context.read<TopicImagesBloc>().add(
                FetchTopicPhotos(
                  slug: slug,
                  page: 1,
                  perPage: 30,
                  orderBy: 'latest',
                  orientation: 'portrait',
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<TopicImagesBloc, TopicImagesState>(
              builder: (context, state) {
                if (state is TopicImagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TopicImagesError) {
                  return Center(child: Text(state.message));
                }
                if (state is TopicImagesLoaded) {
                  return Imagecard(photos: state.photos);
                }
                // Initial state before first load
                return const Center(child: Text('Loading...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
