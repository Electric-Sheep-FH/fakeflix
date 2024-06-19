import 'package:fakeflix/liked_data.dart';
import 'package:fakeflix/movie.dart';
import 'package:fakeflix/movie_service.dart';
import 'package:fakeflix/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieService().discoverMovie();
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
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
      body: FutureBuilder<dynamic>(
        future: _moviesFuture,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            List<Movie> movies = snapshot.data;
            return Consumer<LikedData>(
              builder: (context, likedData, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'WELCOME BACK, ${userNotifier.user!.firstName.toUpperCase()} ${userNotifier.user!.lastName.toUpperCase()}, HERE IS THE DISCOVER LIST',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oswald(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),  // Disable scroll for ListView as it's inside SingleChildScrollView
                        shrinkWrap: true,  // Make the ListView take only as much space as it needs
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          Movie movie = movies[index];
                          bool isFavorite = likedData.isFavorite(movie);
                          return ListTile(
                            title: Text(
                              movies[index].title,
                              style: GoogleFonts.oswald(),
                            ),
                            titleTextStyle: const TextStyle(color: Colors.white),
                            tileColor: Colors.black,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
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
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.red),
                                  ),
                                  onPressed: () => context.go('/home/details/${movies[index].id}'),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            shape: const Border(bottom: BorderSide(color: Colors.red)),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('Error happened...');
          }
        },
      ),
    );
  }
}