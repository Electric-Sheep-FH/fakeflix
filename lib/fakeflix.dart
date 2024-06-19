import 'package:fakeflix/details.dart';
import 'package:fakeflix/favorite_page.dart';
import 'package:fakeflix/home.dart';
import 'package:fakeflix/login.dart';
import 'package:fakeflix/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (BuildContext context, GoRouterState state) {
            final int parsedId = int.parse(state.pathParameters['id']!);
            return Details(id: parsedId);
          },
        ),
        GoRoute(
          path: 'favorites',
          builder: (BuildContext context, GoRouterState state) {
            return const FavoritesPage();
          },
        ),
      ],
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    final bool isLoggingIn = state.matchedLocation == '/';
    final bool isAuthenticated = userNotifier.isAuthenticated;

    if (!isAuthenticated && !isLoggingIn) return '/';
    if (isAuthenticated && isLoggingIn) return '/home';

    return null;
  },
);

class FakeflixApp extends StatelessWidget {
  const FakeflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserNotifier(),
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
