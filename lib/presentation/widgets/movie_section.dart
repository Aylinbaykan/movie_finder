import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_finder/core/constants/text_styles.dart';
import 'package:movie_finder/data/models/movie.dart';
import '../../core/constants/color_constants.dart';
import 'movie_card.dart';
import 'navigation_buttons.dart';

class MovieSection extends ConsumerWidget {
  final String title;
  final FutureProvider<List<Movie>> provider;
  final PageController controller;
  final Widget buttons;
  const MovieSection(
      {super.key,
      required this.title,
      required this.provider,
      required this.controller,
      required this.buttons});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: title == "Popüler"
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.sectionTitle),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    buttons,
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTextStyles.sectionTitle),
                    buttons,
                  ],
                ),
        ),
        Consumer(builder: (context, ref, child) {
          final movies = ref.watch(provider);
          return movies.when(
            data: (data) => Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              height: 250,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: PageView.builder(
                        controller: controller,
                        itemCount: data.length,
                        padEnds: false,
                        itemBuilder: (context, index) => Align(
                          alignment: Alignment.centerLeft,
                          child: MovieCard(movie: data[index]),
                        ),
                      )),
                  NavigationButtons(
                      controller: controller,
                      icon: Icons.arrow_back_ios,
                      isLeft: true),
                  NavigationButtons(
                      controller: controller,
                      icon: Icons.arrow_forward_ios,
                      isLeft: false),
                ],
              ),
            ),
            loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.textPrimary)),
            error: (e, _) => Center(
              child: Text("Error loading movies$e",
                  style: AppTextStyles.sectionTitle),
            ),
          );
        }),
      ],
    );
  }
}
