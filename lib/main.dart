import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/models/error_model.dart';
import 'package:flutter_docs_clone/repository/auth_repository.dart';
import 'package:flutter_docs_clone/router_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state)=>errorModel!.data);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
        final  user = ref.watch(userProvider);
        if(user != null && user.token!.isNotEmpty){
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
     
    );
  }
}
