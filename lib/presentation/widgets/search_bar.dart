// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_finder/core/constants/color_constants.dart';
import 'package:movie_finder/core/constants/text_styles.dart';
import 'package:movie_finder/data/models/movie.dart';
import 'package:movie_finder/presentation/widgets/movie_card.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  String? searchQuery;
  AsyncValue<List<Movie>>? searchResults;

  SearchBarWidget(
      {super.key,
      required this.searchController,
      required this.onSearch,
      this.searchQuery,
      this.searchResults});

  @override
  _CustomToggleButtonsState createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: widget.searchController,
            style: AppTextStyles.subtitle,
            decoration: InputDecoration(
              hintText: "Film ara...",
              hintStyle: TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.entryBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: AppColors.textPrimary),
                onPressed: () {
                  widget.onSearch(widget.searchController.text);
                },
              ),
            ),
            onChanged: (value) {
              if (value.length >= 2) {
                widget.onSearch(value);
              }
            },
          ),
        ),
        if (widget.searchController.text.length > 2)
          widget.searchResults!.when(
            data: (movies) => movies.isNotEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    //width: ,
                    child: GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return MovieCard(movie: movie);
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "Sonuç Bulunamadı",
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),
            loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.textPrimary)),
            error: (e, _) => Center(
                child: Text("Hata: $e", style: AppTextStyles.sectionTitle)),
          ),
      ],
    );
  }
}
