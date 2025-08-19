part of 'images_bloc.dart';

abstract class ImagesEvent {}

class SearchImages extends ImagesEvent {
  final String query; // e.g., 'abstract'
  final int page; // default 1
  final int perPage; // default 20
  final String orderBy; // 'relevant' | 'latest'
  final String? orientation; // 'landscape' | 'portrait' | 'squarish'

  SearchImages({
    required this.query,
    this.page = 1,
    this.perPage = 20,
    this.orderBy = 'relevant',
    this.orientation,
  });
}

// class FetchTopicPhotos extends ImagesEvent {
//   FetchTopicPhotos({
//     required this.slug, // e.g. 'nature'
//     this.page = 1,
//     this.perPage = 30,
//     this.orderBy =
//         'latest', // valid: 'latest' | 'oldest' | 'popular' | 'views' | 'downloads'
//     this.orientation, // 'landscape' | 'portrait' | 'squarish'
//     this.contentFilter = 'low', // 'low' | 'high'
//   });

//   final String slug;
//   final int page;
//   final int perPage;
//   final String orderBy;
//   final String? orientation;
//   final String contentFilter;
// }
