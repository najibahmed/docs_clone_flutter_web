import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/repository/auth_repository.dart';
import 'package:flutter_docs_clone/screens/home_screen.dart';
import 'package:flutter_docs_clone/utils/app_images.dart';
import 'package:flutter_docs_clone/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state)=>errorModel.data);
      navigator.replace("/");
    } else {
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ElevatedButton.icon(
                  onPressed: () => signInWithGoogle(context, ref),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kWhiteColor,
                      minimumSize: const Size(150, 50)),
                  icon: Image.asset(
                    AppImages.instance.googleLogo,
                    height: 20,
                  ),
                  label: const Text("Sign in wiht Google")),
            ),
          ],
        ),
      ),
    );
  }
}
