import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/core/secrets.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(ImagesInitial()) {
    on<SearchImages>(_onSearchImages);
  }

  Future<void> _onSearchImages(
    SearchImages event,
    Emitter<ImagesState> emit,
  ) async {
    emit(ImagesLoading());

    final accessKey = AppSecrets().accessKey; // <-- provide your key
    final uri = Uri.https('api.unsplash.com', '/search/photos', {
      'client_id': accessKey,
      'query': event.query, // from event
      'page': '${event.page}',
      'per_page': '${event.perPage}',
      'order_by': event.orderBy, // 'relevant' | 'latest'
      if (event.orientation != null)
        'orientation':
            event.orientation!, // 'landscape' | 'portrait' | 'squarish'
      'content_filter': 'low', // or 'high'
    });

    try {
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(res.body);
        final photos = List<Map<String, dynamic>>.from(jsonBody['results']);
        emit(ImagesLoaded(photos: photos));
      } else {
        emit(ImagesError('Search failed: ${res.statusCode} ${res.body}'));
      }
    } catch (e) {
      emit(ImagesError(e.toString()));
    }
  }
}
