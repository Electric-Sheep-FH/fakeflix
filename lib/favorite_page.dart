import 'package:fakeflix/liked_data.dart';
import 'package:fakeflix/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

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
      ),
      body: Consumer<LikedData>(
        builder: (context, likedData, child) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'YOUR FAVORITES, ${userNotifier.user!.firstName.toUpperCase()} ${userNotifier.user!.lastName.toUpperCase()}',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    //fontFamily: ,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: likedData.movies.length,
                  itemBuilder: (context, index) {
                    final movie = likedData.movies[index];
                    return ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(movie.title,
                            style: GoogleFonts.oswald(color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_snippet_rounded, color: Colors.white,),
                            onPressed: () => context.go('/home/details/${movie.id}'),
                          ),
                        ]
                        ,),
                      // subtitle: Text(movie.overview),
                      leading: Image.network(
                        'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<LikedData>(context, listen: false).remove(movie);
                        },
                      ),
                      shape: const Border(bottom: BorderSide(color: Colors.white)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}