part of 'topic_images_bloc.dart';

abstract class TopicImagesEvent {}

class FetchTopicPhotos extends TopicImagesEvent {
  FetchTopicPhotos({
    required this.slug, // e.g. 'nature'
    this.page = 1,
    this.perPage = 30,
    this.orderBy = 'latest', // latest | oldest | popular | views | downloads
    this.orientation, // landscape | portrait | squarish
    this.contentFilter = 'low', // low | high
  });

  final String slug;
  final int page;
  final int perPage;
  final String orderBy;
  final String? orientation;
  final String contentFilter;
}

class ClearTopicCache extends TopicImagesEvent {}
