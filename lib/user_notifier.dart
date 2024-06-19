import 'package:flutter/material.dart';

import 'user.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null;

  void setUser(User user, String token) {
    _user = user;
    _token = token;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _token = null;
    notifyListeners();
  }


}