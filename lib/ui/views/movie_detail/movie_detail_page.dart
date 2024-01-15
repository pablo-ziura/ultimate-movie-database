import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/genre.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/provider/favorite_list_provider.dart';
import 'package:ultimate_movie_database/ui/views/movie_detail/viewmodel/movie_detail_view_model.dart';
import 'package:ultimate_movie_database/ui/widgets/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widgets/loading/loading_view.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieDetailViewModel _viewModel = inject<MovieDetailViewModel>();
  List<Genre> _genres = [];
  bool _isInWatchList = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _viewModel.getGenresState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _genres = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchMovieGenres();
          });
          break;
      }
    });
    _viewModel.fetchMovieGenres();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<FavoriteListProvider>(context, listen: false)
          .fetchMoviesFromWatchList();
      _isInit = false;
    }
  }

  Future<void> _toggleWatchList(FavoriteListProvider provider) async {
    if (_isInWatchList) {
      _viewModel.removeFromWatchList(widget.movie);
      await provider.removeFromWatchList(widget.movie);
    } else {
      _viewModel.addToWatchList(widget.movie);
      await provider.addToWatchList(widget.movie);
    }
    setState(() {
      _isInWatchList = !_isInWatchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteListProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMovieImage(context, widget.movie),
            _buildMovieDetails(widget.movie, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie, FavoriteListProvider provider) {
    List<Genre> selectedGenres =
        _genres.where((genre) => movie.genreIds.contains(genre.id)).toList();

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
            GestureDetector(
              onTap: () {
                _toggleWatchList(provider);
              },
              child: StreamBuilder<ResourceState<List<Movie>>>(
                stream: provider.moviesStream,
                builder: (context, snapshot) {
                  if (snapshot.data?.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data?.status == Status.SUCCESS) {
                    bool isMovieInFavorites = snapshot.data?.data
                            ?.any((movie) => movie.id == widget.movie.id) ??
                        false;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isMovieInFavorites
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isMovieInFavorites ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isMovieInFavorites
                              ? 'Remove from watch list'
                              : 'Add to want to watch list',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.data?.status == Status.ERROR) {
                    return GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error: ${snapshot.data?.exception?.toString() ?? 'Unknown error'}'),
                        ),
                      ),
                      child: const Center(child: Text('Failed to load movie')),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              movie.overview,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Average Vote: ${movie.voteAverage.toStringAsFixed(2)} (${movie.voteCount} votes)',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
                'Genres: ${selectedGenres.map((genre) => genre.name).join(', ')}'),
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
