import 'dart:collection';
import 'package:fakeflix/movie.dart';
import 'package:flutter/widgets.dart';


class LikedData extends ChangeNotifier {
  final List<Movie> _movies = [];

  UnmodifiableListView<Movie> get movies => UnmodifiableListView(_movies);
  
  bool isFavorite(Movie movie) {
    return _movies.any((movieInList) => movieInList.id == movie.id);
  }

  void add(Movie movie) {
      _movies.add(movie);
      notifyListeners();
  }
  void remove(Movie movie) {
    _movies.removeWhere((movieInList) => movieInList.id == movie.id);
    notifyListeners();
  }
}