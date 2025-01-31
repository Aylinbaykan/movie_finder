import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../data/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = cardWidth * 1.5;

    return GestureDetector(
      onTap: () {
        // Burada detay sayfasına geçiş eklenebilir
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// **Film Posteri**
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: '${ApiConstants.imageBaseUrl}/${movie.posterPath}',
                placeholder: (context, url) => Container(
                  width: cardWidth,
                  height: cardHeight,
                  color: Colors.grey.shade300,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: cardWidth,
                  height: cardHeight,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
                width: cardWidth,
                height: cardHeight,
                fit: BoxFit.cover,
              ),
            ),

            /// **Gradient Overlay (Arka plan karartma)**
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: cardHeight * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

            /// **Film Adı**
            Positioned(
              bottom: 12,
              left: 10,
              right: 10,
              child: Text(
                movie.originalTitle ?? "Bilinmeyen Başlık",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: cardWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /// **IMDb Puanı (Yuvarlak rozet)**
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.textPrimary, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      movie.voteAverage?.toStringAsFixed(1) ?? "N/A",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// **Puan Çizgileri (TMDB Tarzı)**
            Positioned(
              bottom: 40,
              left: 10,
              right: 10,
              child: _buildRatingBar(movie.voteAverage ?? 0),
            ),

            /// **Vizyon Tarihi (Alt Kısımda Gösterilecek)**
            Positioned(
              bottom: 55,
              left: 10,
              right: 10,
              child: Text(
                movie.releaseDate != null && movie.releaseDate!.isNotEmpty
                    ? "📅 ${movie.releaseDate}"
                    : "📅 Tarih Yok",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: cardWidth * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **IMDb Puanı Çizgileri (TMDB Tarzı)**
  Widget _buildRatingBar(double rating) {
    int barCount = 5; // 5 adet çizgi
    double normalizedRating = (rating / 10) * barCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(barCount, (index) {
        bool isFilled = index < normalizedRating;
        return Container(
          width: 6,
          height: isFilled ? 18 : 10, // Doluysa uzun, boşsa kısa
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), // Yuvarlak uçlar
            color: isFilled ? Colors.greenAccent : Colors.grey.shade600,
            gradient: isFilled
                ? LinearGradient(
                    colors: [
                      Colors.greenAccent.shade400,
                      Colors.green.shade900
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
          ),
        );
      }),
    );
  }
}
