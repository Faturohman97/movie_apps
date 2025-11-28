import 'package:dio/dio.dart';

class TMDBService{
  TMDBService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3'));

  final Dio _dio;

  Future<List<dynamic>> fetchPopular({required String apiKey, int page = 1}) async{
    final res = await _dio.get('/movie/popular', queryParameters: {
      'api_key' : apiKey,
      'language' : 'en-US',
      'page' : page,
    });
    return res.data['results'] as List<dynamic>;
  }
}