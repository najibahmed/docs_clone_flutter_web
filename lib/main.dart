import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        primaryColor: const Color(0xff1A1A1A),
        scaffoldBackgroundColor: const Color(0xff0D0D0D),
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        // Add more theme configurations
      ),
      theme: ThemeData(
        primaryColor: const Color(0xffE9EEFA),
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        // Add more theme configurations
      ),
      home: const LoginScreen(),
    );
  }
}
