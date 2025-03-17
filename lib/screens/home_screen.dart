import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/repository/document_repository.dart';
import 'package:flutter_docs_clone/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

void signOut(WidgetRef ref){
  ref.read(authRepositoryProvider).singOut();
  ref.read(userProvider.notifier).update((state)=>null);

}

void createDocument (BuildContext context,WidgetRef ref)async{
  String token = ref.read(userProvider)!.token!;
  final navigator = Routemaster.of(context);
  final snakbar= ScaffoldMessenger.of(context);
  final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);
  if(errorModel.data !=null){
    navigator.push('/document/${errorModel.data.id}');
  }else{
    snakbar.showSnackBar(SnackBar(content: Text(errorModel.error.toString())));
  }
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>createDocument(context,ref),child: Icon(Icons.add),),
      appBar: AppBar(
        title: Text(ref.watch(userProvider)!.email),
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(onPressed: ()=>signOut(ref), 
          icon: const Icon(Icons.logout_outlined,color: kRedColor,))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Flutter Docs Clone'),
             Text(ref.watch(userProvider)!.email),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}