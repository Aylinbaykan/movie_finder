import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_finder/core/constants/color_constants.dart';
import 'package:movie_finder/presentation/widgets/custom_toggle_buttons.dart';
import 'package:movie_finder/presentation/widgets/movie_section.dart';
import 'package:movie_finder/presentation/widgets/search_bar.dart';
import '../../core/constants/constants.dart';
import '../../core/constants/text_styles.dart';
import '../../data/models/movie.dart';
import '../providers/movie_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String trendingPeriod = "day"; // Varsayılan olarak "Bugün" seçili
  String popularCategory = "popular"; // Varsayılan olarak Popüler Filmler
  String freeCategory = "movie"; // Varsayılan olarak Popüler Filmler
  String searchQuery = ""; // Kullanıcının arama sorgusu
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _trendingController = PageController(
    viewportFraction: 0.4,
    initialPage: 0,
    keepPage: false,
  );
  final PageController _popularController = PageController(
    viewportFraction: 0.4,
    initialPage: 0,
    keepPage: false,
  );
  final PageController _freeController = PageController(
    viewportFraction: 0.4,
    initialPage: 0,
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(movieSearchProvider(searchQuery));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(TextConstants.appTitle, style: AppTextStyles.appTitle),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppColors.divider,
              thickness: 1.5,
            ),

            /// **🔹 Arama Çubuğu**
            SearchBarWidget(
              searchController: _searchController,
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              searchQuery: searchQuery,
              searchResults: searchResults,
            ),
            if (_searchController.text.length < 3)
              Column(
                children: [
                  MovieSection(
                    title: TextConstants.trendingTitle,
                    controller: _trendingController,
                    buttons: CustomToggleButtons(
                      options: [TextConstants.today, TextConstants.thisWeek],
                      selectedOption: trendingPeriod == "day"
                          ? TextConstants.today
                          : TextConstants.thisWeek,
                      onSelected: (selected) {
                        double previousOffset = _scrollController.offset;
                        setState(() {
                          trendingPeriod =
                              selected == TextConstants.today ? "day" : "week";
                        });
                        // Scroll pozisyonunu koru
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            previousOffset,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                    ),
                    provider: trendingMoviesProvider(trendingPeriod),
                  ),
                  MovieSection(
                    title: TextConstants.popularTitle,
                    controller: _popularController,
                    buttons: CustomToggleButtons(
                      options: [
                        TextConstants.popular,
                        TextConstants.streaming,
                        TextConstants.onTV,
                        TextConstants.rental,
                        TextConstants.inTheaters
                      ],
                      selectedOption: _mapCategoryToText(popularCategory),
                      onSelected: (selected) {
                        double previousOffset = _scrollController.offset;
                        setState(() {
                          popularCategory = _mapPopularCategory(selected);
                        });
                        // Scroll pozisyonunu koru
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            previousOffset,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                    ),
                    provider: _getPopularProvider(),
                  ),
                  MovieSection(
                    title: TextConstants.freeWatchTitle,
                    controller: _freeController,
                    buttons: CustomToggleButtons(
                      options: [
                        TextConstants.freeMovies,
                        TextConstants.freeTVShows
                      ],
                      selectedOption: freeCategory == "movie"
                          ? TextConstants.freeMovies
                          : TextConstants.freeTVShows,
                      onSelected: (selected) {
                        double previousOffset = _scrollController.offset;

                        setState(() {
                          freeCategory = selected == TextConstants.freeMovies
                              ? "movie"
                              : "tv";
                        });

                        // Scroll pozisyonunu koru
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            previousOffset,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                    ),
                    provider: freeMoviesProvider(freeCategory),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  String _mapPopularCategory(String category) {
    switch (category) {
      case TextConstants.streaming:
        return "streaming";
      case TextConstants.onTV:
        return "tv";
      case TextConstants.rental:
        return "rent";
      case TextConstants.inTheaters:
        return "theaters";
      default:
        return "popular";
    }
  }

  String _mapCategoryToText(String category) {
    switch (category) {
      case "streaming":
        return TextConstants.streaming;
      case "tv":
        return TextConstants.onTV;
      case "rent":
        return TextConstants.rental;
      case "theaters":
        return TextConstants.inTheaters;
      default:
        return TextConstants.popular;
    }
  }

  FutureProvider<List<Movie>> _getPopularProvider() {
    switch (popularCategory) {
      case "streaming":
        return streamingMoviesProvider;
      case "tv":
        return tvMoviesProvider;
      case "rent":
        return rentMoviesProvider;
      case "theaters":
        return nowPlayingMoviesProvider;
      default:
        return popularMoviesProvider;
    }
  }
}
