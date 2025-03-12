import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/models/error_model.dart';
import 'package:flutter_docs_clone/models/user_model.dart';
import 'package:flutter_docs_clone/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel errorModel = ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: '',
          token: '',
        );
        var res= await _client.post(Uri.parse("$HOST/api/auth/register"),
            body: userAcc.toJson(), headers: {
              'Content-Type': 'application/json; charset=utf-8',
      
            });
            switch (res.statusCode) {
              case 200:
              final newUser= userAcc.copyWith(
                uid: jsonDecode(res.body)['user']['_id']
                );
                errorModel = ErrorModel(error: null, data: newUser);
                break;
              case 400:
                print('User already registered');
                break;
              default:
                errorModel = ErrorModel(error: 'Something unexpectd error occured!', data: null);
            }
      }
     
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
    }
     return errorModel;
  }

}
