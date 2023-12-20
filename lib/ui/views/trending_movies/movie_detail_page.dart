import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
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
}

Widget _buildMovieImage(BuildContext context, Movie movie) {
  var screenWidth = MediaQuery.of(context).size.width;

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
            child: Image.network(
              NetworkConstants.BASE_URL_IMAGE + movie.backdropPath,
              fit: BoxFit.cover,
              width: screenWidth - 10,
              height: 250,
            ),
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

Widget _buildMovieDetails(Movie movie) {
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
            'Release Date: ${movie.releaseDate.toLocal().toString().split(' ')[0]}',
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
        ],
      ),
    ),
  );
}
