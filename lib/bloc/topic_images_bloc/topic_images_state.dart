part of 'topic_images_bloc.dart';

abstract class TopicImagesState {}

final class TopicImagesInitial extends TopicImagesState {}

final class TopicImagesLoading extends TopicImagesState {}

class TopicImagesLoaded extends TopicImagesState {
  final List<Map<String, dynamic>> photos;
  TopicImagesLoaded({required this.photos});
}

class TopicImagesError extends TopicImagesState {
  final String message;
  TopicImagesError(this.message);
}
