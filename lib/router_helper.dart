
import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/screens/document_screen.dart';
import 'package:flutter_docs_clone/screens/home_screen.dart';
import 'package:flutter_docs_clone/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),
});


