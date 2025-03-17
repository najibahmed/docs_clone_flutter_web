import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Flutter Docs Clone'),
             Text(ref.watch(userProvider)!.email),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}