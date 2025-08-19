part of 'images_bloc.dart';

abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final List<Map<String, dynamic>> photos;
  ImagesLoaded({required this.photos});
}

class ImagesError extends ImagesState {
  final String message;
  ImagesError(this.message);
}
