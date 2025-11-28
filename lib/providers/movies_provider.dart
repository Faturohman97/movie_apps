import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

final tmdbServiceProvider = Provider<TMDBService> ((ref) => TMDBService());

//AsyncNotifier menggunakan riverpod 
class MovieNotifier extends AsyncNotifier<List<Movie>> {
  @override
  Future<List<Movie>> build() async{
    return await _fetchPage();
  }

  Future <List<Movie>> _fetchPage({int page = 1}) async{
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty){
      throw StateError('TMDB_API_KEY not found. Put it in your .env file');
    }

    final svc  = ref.read(tmdbServiceProvider);
    final results = await svc.fetchPopular(apiKey: apiKey, page: page);

    return results
      .map((e) => Movie.fromJson(e as Map<String, dynamic>))
      .toList();
  }

  Future <void> refresh()async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage());
  }
}

final moviesProvider = AsyncNotifierProvider<MovieNotifier, List<Movie>>(() => MovieNotifier());