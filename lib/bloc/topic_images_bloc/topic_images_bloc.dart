import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/core/secrets/secrets.dart';

part 'topic_images_event.dart';
part 'topic_images_state.dart';

class TopicImagesBloc extends Bloc<TopicImagesEvent, TopicImagesState> {
  TopicImagesBloc() : super(TopicImagesInitial()) {
    on<FetchTopicPhotos>(_onFetchTopicPhotos);
    on<ClearTopicCache>(_onClearCache);
  }

  // Cache: key -> photos
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  // Dedupe: only one identical request at a time
  String? _inFlightKey;

  String _key(FetchTopicPhotos e) =>
      'topic:${e.slug}|p=${e.page}|pp=${e.perPage}|ord=${e.orderBy}|ori=${e.orientation}|cf=${e.contentFilter}';

  Future<void> _onFetchTopicPhotos(
    FetchTopicPhotos event,
    Emitter<TopicImagesState> emit,
  ) async {
    final key = _key(event);

    // 1) Instant restore from cache
    final cached = _cache[key];
    if (cached != null) {
      emit(TopicImagesLoaded(photos: cached));
      return;
    }

    // 2) Ignore duplicate in-flight request
    if (_inFlightKey == key) return;
    _inFlightKey = key;

    emit(TopicImagesLoading());

    final accessKey = AppSecrets().accessKey;
    final path = '/topics/${event.slug}/photos';
    final query = <String, String>{
      'client_id': accessKey,
      'page': '${event.page}',
      'per_page': '${event.perPage}',
      'order_by':
          event.orderBy, // latest | oldest | popular | views | downloads
      'content_filter': event.contentFilter,
      if (event.orientation != null) 'orientation': event.orientation!,
    };

    final uri = Uri.https('api.unsplash.com', path, query);

    try {
      print('Fetching topic photos: ${event.slug}');
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(res.body);
        final photos = List<Map<String, dynamic>>.from(jsonList);
        _cache[key] = photos; // 3) store in cache
        emit(TopicImagesLoaded(photos: photos));
      } else {
        emit(
          TopicImagesError('Topic fetch failed: ${res.statusCode} ${res.body}'),
        );
      }
    } catch (e) {
      emit(TopicImagesError(e.toString()));
    } finally {
      _inFlightKey = null;
    }
  }

  Future<void> _onClearCache(
    ClearTopicCache event,
    Emitter<TopicImagesState> emit,
  ) async {
    _cache.clear();
  }
}
