import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ultimate_movie_database/data/remote/network_constants.dart';
import 'package:ultimate_movie_database/model/movie.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final String navigationRoute;

  const MovieListItem(
      {Key? key, required this.movie, required this.navigationRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty) {
      imageWidget = CachedNetworkImage(
        imageUrl: NetworkConstants.BASE_URL_IMAGE + movie.backdropPath!,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        width: 100,
        height: 150,
      );
    } else {
      imageWidget = Image.asset(
        'assets/img/image_not_available.png',
        fit: BoxFit.cover,
        width: 100,
        height: 150,
      );
    }

    return InkWell(
      onTap: () {
        context.go(navigationRoute, extra: movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(
            movie.title,
            style: const TextStyle(color: Colors.white),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageWidget,
          ),
        ),
      ),
    );
  }
}
