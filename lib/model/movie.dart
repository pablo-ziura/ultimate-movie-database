class Movie {
  String? backdropPath;
  int id;
  String title;
  String originalTitle;
  String overview;
  String? posterPath;
  List<int> genreIds;
  double popularity;
  String releaseDate;
  bool video;
  double voteAverage;
  int voteCount;
  int? budget;
  int? revenue;
  int? runtime;

  Movie({
    this.backdropPath,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.budget,
    this.revenue,
    this.runtime,
  });
}
