import '../../data/repositories/movie_repository.dart';
import '../entities/movie_entity.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<List<MovieEntity>> call(String query) async {
    if (query.length < 2) {
      return []; // En az 2 karakter kontrolü
    }

    final movies = await repository.searchMovies(query);

    // Movie modelini MovieEntity'ye dönüştürüyoruz
    return movies
        .map((movie) => MovieEntity(
              id: movie.id,
              originalTitle: movie.originalTitle!,
              posterPath: movie.posterPath!,
            ))
        .toList();
  }
}
