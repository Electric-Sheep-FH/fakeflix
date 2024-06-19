class Movie {
  final String title;
  final int id;
  final String posterPath;
  final String overview;
  //final double voteAverage;

  const Movie({
    required this.title,
    required this.id,
    required this.posterPath,
    required this.overview,
    //required this.voteAverage
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title' : String title,
        'id' : int id,
        'poster_path' : String posterPath,
        'overview' : String overview,
        //'vote_average' : double voteAverage,
      } => 
        Movie(
          title : title,
          id : id,
          posterPath: posterPath,
          overview: overview,
          //voteAverage: voteAverage,
        ),
      _ => throw const FormatException('Failed to load movie.'),
    };
  }
}