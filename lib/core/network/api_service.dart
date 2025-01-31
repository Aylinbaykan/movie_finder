import '../../data/models/movie.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient apiClient;

  ApiService({required this.apiClient});

  /// **Popüler Filmleri Getir (Paging Destekli)**
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    return _fetchMovies('/movie/popular', page: page);
  }

  /// **Trending (Ana Akım) Filmler (Bugün / Bu Hafta)**
  Future<List<Movie>> getTrendingMovies({String period = "day"}) async {
    return _fetchMovies('/trending/movie/$period');
  }

  /// **Sinemalarda Gösterimde Olan Filmler**
  Future<List<Movie>> getNowPlayingMovies({int page = 2}) async {
    return _fetchMovies('/movie/now_playing',
        page: page, extraParams: {'region': 'TR'});
  }

  /// **Yayında (Streaming) Olan Filmler**
  Future<List<Movie>> getStreamingMovies({int page = 1}) async {
    return _fetchMovies('/discover/movie', page: page, extraParams: {
      'with_watch_monetization_types': 'flatrate',
      'watch_region': 'TR'
    });
  }

  /// **Televizyonda Olan Filmler**
  Future<List<Movie>> getTvMovies({int page = 1}) async {
    return _fetchMovies('/discover/movie', page: page, extraParams: {
      'with_watch_monetization_types': 'free',
      'watch_region': 'TR'
    });
  }

  /// **Kiralık Olan Filmler**
  Future<List<Movie>> getRentMovies({int page = 1}) async {
    return _fetchMovies('/discover/movie', page: page, extraParams: {
      'with_watch_monetization_types': 'rent',
      'watch_region': 'TR'
    });
  }

  /// **Ücretsiz İzlenebilir Filmleri Getir**
  Future<List<Movie>> getFreeMovies({String period = "movie"}) async {
    return _fetchMovies('/discover/$period', extraParams: {
      'with_watch_monetization_types': 'free',
      'watch_region': 'TR'
    });
  }

  /// **Genel API Çağrısı Yapan Metod**
  Future<List<Movie>> _fetchMovies(String path,
      {int page = 1, Map<String, String>? extraParams}) async {
    try {
      final params = {'page': page.toString()};
      if (extraParams != null) params.addAll(extraParams);

      final response = await apiClient.get(path, params: params);

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Film verileri alınırken hata oluştu: $e");
    }
  }

  /// **Arama Yap (Paging Destekli)**
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await apiClient.get('/search/movie', params: {
        'query': query,
        'page': page.toString(),
      });
      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Film arama sırasında hata oluştu: $e");
    }
  }

  Future<Movie> getMovieDetail(int movieId) async {
    final response = await apiClient.get('/movie/$movieId');

    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    } else {
      throw Exception('Film detayları alınırken hata oluştu.');
    }
  }
}
