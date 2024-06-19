import 'package:fakeflix/liked_data.dart';
import 'package:fakeflix/movie.dart';
import 'package:fakeflix/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  const Details({super.key, required this.id});
  final int id;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<dynamic> _movieFuture;

  @override
  void initState() {
    super.initState();
    _movieFuture = MovieService().getMovieById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Image.asset(
            'images/fakeflix-typo.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              context.go('/home/favorites');
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: _movieFuture,
          builder: (BuildContext context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if(snapshot.hasData) {
              Movie movie = snapshot.data;
              return Consumer<LikedData>(
                builder: (context, likedData, child) {
                  bool isFavorite = likedData.isFavorite(movie);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.network(
                        'https://image.tmdb.org/t/p/original${movie.posterPath}',
                        width: 300,
                      ),
                      IconButton(
                        onPressed: () {
                            if (isFavorite) {
                              likedData.remove(movie);
                            } else {
                              likedData.add(movie);
                            }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.pink,
                        ),
                      ),
                      Text(
                        movie.title,
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        child: Text(
                        movie.overview,
                        style: const TextStyle(
                          color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.go('/'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        child: const Text(
                          'Back to movie list',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)
                          ),
                        ),
                        ),
                    ],
                  );

                }
              );
            } else if (snapshot.hasError) {
              return const Text('Error happened...');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}