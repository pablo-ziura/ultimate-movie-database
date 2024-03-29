import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';
import 'package:ultimate_movie_database/ui/views/trending_movies/viewmodel/trending_movies_view_model.dart';
import 'package:ultimate_movie_database/ui/widgets/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widgets/loading/loading_view.dart';

class TrendingMoviesPage extends StatefulWidget {
  const TrendingMoviesPage({super.key});

  @override
  State<TrendingMoviesPage> createState() => _TrendingMoviesPageState();
}

class _TrendingMoviesPageState extends State<TrendingMoviesPage> {
  final TrendingMoviesViewModel _moviesViewModel =
      inject<TrendingMoviesViewModel>();
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _moviesViewModel.getTrendingWeekMoviesState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _movies = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _moviesViewModel.fetchTrendingWeekMovies();
          });
          break;
      }
    });
    _moviesViewModel.fetchTrendingWeekMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        _buildMovieList(context),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "TRENDING MOVIES",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
                shadows: [
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.amberAccent,
                  ),
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.amberAccent,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildMovieList(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    if (_movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CarouselSlider.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index, realIndex) {
        return _buildMovieItem(_movies[index], context);
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        height: screenHeight,
      ),
    );
  }

  Widget _buildMovieItem(Movie movie, BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    Widget imageWidget;
    if (movie.posterPath != null && movie.posterPath!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: NetworkConstants.BASE_URL_IMAGE + movie.posterPath!,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        width: screenWidth,
        height: screenHeight,
      );
    } else {
      imageWidget = Image.asset(
        'assets/img/image_not_available.png',
        fit: BoxFit.cover,
        width: screenWidth,
        height: screenHeight,
      );
    }

    return InkWell(
      onTap: () {
        context.go(NavigationRoutes.TRENDING_MOVIE_DETAIL_ROUTE, extra: movie);
      },
      child: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            imageWidget,
            Positioned(
              child: Container(
                height: screenHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 10,
              right: 25,
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              right: 10,
              child: RatingBar.builder(
                initialRating: movie.voteAverage,
                minRating: 0,
                direction: Axis.vertical,
                allowHalfRating: true,
                itemCount: 10,
                itemSize: 30.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _moviesViewModel.dispose();
    super.dispose();
  }
}
