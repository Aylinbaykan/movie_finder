import '../models/movie.dart';
import '../../core/network/api_service.dart';

class MovieRepository {
  final ApiService apiService;

  MovieRepository(this.apiService);

  /// **Popüler Filmleri Getir (Sayfalama destekli)**
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    return await apiService.getPopularMovies(page: page);
  }

  /// **Arama Sonuçlarını Getir (Sayfalama destekli)**
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    return await apiService.searchMovies(query, page: page);
  }

  /// **Günün Trend Filmleri**
  Future<List<Movie>> getTrendingMovies({String period = "day"}) async {
    return await apiService.getTrendingMovies(period: period);
  }

  /// **Sinemalarda Olan Filmler**
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return await apiService.getNowPlayingMovies(page: page);
  }

  /// **Yayında Olan Filmler (Streaming)**
  Future<List<Movie>> getStreamingMovies() async {
    return await apiService.getStreamingMovies();
  }

  /// **Televizyondaki Filmler**
  Future<List<Movie>> getTvMovies() async {
    return await apiService.getTvMovies();
  }

  /// **Kiralık Filmler**
  Future<List<Movie>> getRentMovies() async {
    return await apiService.getRentMovies();
  }

  /// **Free Filmler ve Tvler**
  Future<List<Movie>> getFreeMovies({String period = "movie"}) async {
    return await apiService.getFreeMovies(period: period);
  }

  Future<Movie> getMovieDetail(int movieId) async {
    return await apiService.getMovieDetail(movieId);
  }
}
