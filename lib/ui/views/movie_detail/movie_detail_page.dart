import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/views/movie_detail/viewmodel/movie_detail_view_model.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieDetailViewModel _viewModel = inject<MovieDetailViewModel>();

  bool _isInWatchList = false;

  @override
  void initState() {
    super.initState();
    _checkIfMovieIsInWatchList();
  }

  void _checkIfMovieIsInWatchList() async {
    _isInWatchList = await _viewModel.isMovieInWatchList(widget.movie);
    setState(() {});
  }

  void _toggleWatchList() {
    if (_isInWatchList) {
      _viewModel.removeFromWatchList(widget.movie);
    } else {
      _viewModel.addToWatchList(widget.movie);
    }
    setState(() {
      _isInWatchList = !_isInWatchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMovieImage(context, widget.movie),
            _buildMovieDetails(widget.movie),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie) {
    String buttonText =
        _isInWatchList ? 'Remove from watch list' : 'Add to want to watch list';
    Color iconColor = _isInWatchList ? Colors.red : Colors.black;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Release Date: ${movie.releaseDate}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              movie.overview,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _toggleWatchList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: iconColor),
                  const SizedBox(width: 5),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieImage(BuildContext context, Movie movie) {
    var screenWidth = MediaQuery.of(context).size.width;

    Widget imageWidget;
    if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: NetworkConstants.BASE_URL_IMAGE + movie.backdropPath!,
        fit: BoxFit.cover,
        width: screenWidth - 10,
        height: 250,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      imageWidget = Image.asset(
        'assets/img/image_not_available.png',
        fit: BoxFit.cover,
        width: screenWidth - 10,
        height: 250,
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 5.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: imageWidget,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: RatingBar.builder(
              initialRating: movie.voteAverage,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 10,
              itemSize: 25.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          ),
        ],
      ),
    );
  }
}
