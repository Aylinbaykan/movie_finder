import 'package:freezed_annotation/freezed_annotation.dart';
part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  factory Movie({
    required int id,
    String? originalTitle, // `null` olabilir
    String? posterPath, // `null` olabilir
    String? backdropPath, // `null` olabilir
    String? overview, // `null` olabilir
    String? releaseDate, // `null` olabilir
    double? voteAverage, // `null` olabilir
    int? voteCount, // `null` olabilir
    List<int>? genreIds, // `null` olabilir
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        originalTitle: json['original_title'] as String? ?? "Bilinmeyen Başlık",
        posterPath: json['poster_path'] as String? ?? "",
        backdropPath: json['backdrop_path'] as String? ?? "",
        overview: json['overview'] as String? ?? "Açıklama bulunamadı.",
        releaseDate: json['release_date'] as String? ?? "Tarih Yok",
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        voteCount: json['vote_count'] as int? ?? 0,
        genreIds: (json['genre_ids'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
      );
}
