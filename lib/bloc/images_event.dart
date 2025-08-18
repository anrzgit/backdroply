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
