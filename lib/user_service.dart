import 'package:dio/dio.dart';
import 'package:fakeflix/user.dart';
import 'package:fakeflix/user_notifier.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {

  final dio = Dio();
  final String baseUrl = dotenv.env['LOGIN_API'] ?? '';
  final UserNotifier userNotifier;

  UserService({required this.userNotifier});

  Future<void> signUp(User user) async {
    await dio.post(
      '${baseUrl}users',
      data: {
        'email': user.email,
        'password': user.password,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'role': 'dc6fb553-1fea-4bce-9ece-67b913e8f6d6',
      }
    );
  }

  Future<void> signIn(String email, String password) async {
    try {
      Response response = await dio.post(
        '${baseUrl}auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.data.containsKey('data') && response.data['data'].containsKey('access_token')) {
        String token = response.data['data']['access_token'];
        User? user = await getUserByToken(token);
        if (user != null) {

          userNotifier.setUser(user, token);
        }
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<User?> getUserByToken(String token) async {
    try {
      Response response = await dio.get(
        '${baseUrl}users/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data['data'];
        User user = User(
          id: data['id'],
          email: data['email'],
          password: data['password'],
          firstName: data['first_name'],
          lastName: data['last_name'],
          role: data['role'],
          // Ajoutez d'autres champs si nécessaire
        );
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}