import 'package:fakeflix/fakeflix.dart';
import 'package:fakeflix/liked_data.dart';
import 'package:fakeflix/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LikedData()),
        ChangeNotifierProvider(create: (context) => UserNotifier()),
      ],
      child: const FakeflixApp(),
    ),
  );
}