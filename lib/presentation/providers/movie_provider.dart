import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_service.dart';
import '../../data/models/movie.dart';
import '../../domain/usecases/search_movies_usecase.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(apiClient: ref.read(apiClientProvider)),
);

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepository(ref.read(apiServiceProvider)),
);

/// **Movie StateNotifier'ını Kullanan Yeni Provider**

/// **Popüler Filmler**
final popularMoviesProvider = FutureProvider<List<Movie>>(
  (ref) async => ref.read(movieRepositoryProvider).getPopularMovies(),
);

/// **Trend Olanlar (Bugün / Bu Hafta)**
final trendingMoviesProvider = FutureProvider.family<List<Movie>, String>(
  (ref, period) async =>
      ref.read(movieRepositoryProvider).getTrendingMovies(period: period),
);

/// **Sinemalarda Olanlar**
final nowPlayingMoviesProvider = FutureProvider<List<Movie>>(
  (ref) async => ref.read(movieRepositoryProvider).getNowPlayingMovies(),
);

/// **Yayında Olanlar (Streaming)**
final streamingMoviesProvider = FutureProvider<List<Movie>>(
  (ref) async => ref.read(movieRepositoryProvider).getStreamingMovies(),
);

/// **Televizyonda Olanlar**
final tvMoviesProvider = FutureProvider<List<Movie>>(
  (ref) async => ref.read(movieRepositoryProvider).getTvMovies(),
);

/// **Kiralık Olanlar**
final rentMoviesProvider = FutureProvider<List<Movie>>(
  (ref) async => ref.read(movieRepositoryProvider).getRentMovies(),
);

/// **Ücretsiz Olanlar**
final freeMoviesProvider = FutureProvider.family<List<Movie>, String>(
  (ref, period) async =>
      ref.read(movieRepositoryProvider).getFreeMovies(period: period),
);

/// **UseCase Bağlantısı**
final searchMoviesUseCaseProvider = Provider<SearchMoviesUseCase>(
  (ref) => SearchMoviesUseCase(ref.read(movieRepositoryProvider)),
);

/// **Arama UseCase Kullanılarak Çalıştırıldı**
final movieSearchProvider = FutureProvider.family<List<Movie>, String>(
  (ref, query) async {
    final movieEntities = await ref.read(searchMoviesUseCaseProvider)(query);

    // **MovieEntity → Movie dönüşümü**
    return movieEntities
        .map((entity) => Movie(
              id: entity.id,
              originalTitle: entity.originalTitle!,
              posterPath: entity.posterPath!,
            ))
        .toList();
  },
);

final movieDetailProvider =
    FutureProvider.family<Movie, int>((ref, movieId) async {
  return ref.read(movieRepositoryProvider).getMovieDetail(movieId);
});
