import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/models/error_model.dart';
import 'package:flutter_docs_clone/models/user_model.dart';
import 'package:flutter_docs_clone/repository/local_storage_repository.dart';
import 'package:flutter_docs_clone/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _localStorageRepository = localStorageRepository,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel errorModel =
        ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl??"",
          id: '',
          token: '',
        );
        var res = await _client.post(Uri.parse("$HOST/api/auth/register"),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            });
        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
                id: jsonDecode(res.body)['user']['_id'],
                token: jsonDecode(res.body)['token']);
            print("registration newUser: $newUser");
            errorModel = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token!);
            break;
          case 400:
            print('User already registered');
            break;
          default:
            errorModel = ErrorModel(
                error: 'Something unexpectd error occured!', data: null);
        }
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
    }
    return errorModel;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel errorModel =
        ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res =
            await _client.get(Uri.parse("$HOST/api/auth/login"), headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
            final user = jsonDecode(res.body)['user'];
            final userAcc = UserModel(
                email: user["email"],
                name: user["name"],
                profilePic: user["profilePic"],
                id: user["_id"],
                token: '');
            final newUser = userAcc.copyWith(token: token);
            // final newUser = UserModel.fromJson(jsonDecode(res.body)['user']).copyWith(token: token);
            // final newUser = UserModel(email: user["email"],name:user["name"] ,profilePic:user["profilePic"] ,token:token ,id:user["_id"] );
            // print("newUser ---: $newUser");
            // print("error Model:  $errorModel");
            errorModel = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token!);
            break;
          case 400:
            print('Error occured 400');
            break;
          default:
            errorModel = ErrorModel(
                error: 'Something unexpectd error occured!', data: null);
        }
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
    }
    return errorModel;
  }

  void singOut ()async{
    await _googleSignIn.signOut();
      _localStorageRepository.setToken('');
  }
}
