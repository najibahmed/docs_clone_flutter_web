import 'dart:convert';

import 'package:flutter_docs_clone/models/document_model.dart';
import 'package:flutter_docs_clone/models/error_model.dart';
import 'package:flutter_docs_clone/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      var res = await _client.post(Uri.parse("$HOST/api/docs/create"),
          body: jsonEncode({
            "createdAt": DateTime.now().microsecondsSinceEpoch,
          }),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-auth-token': token
          });
      switch (res.statusCode) {
        case 200:
          // print(DocumentModel.fromJson(res.body));
          var data = jsonDecode(res.body)['document'];
          print(data);
          errorModel = ErrorModel(
              error: null, data: DocumentModel.fromJson(jsonEncode(data)));
          // DocumentModel(
          //   uid: data['uid'],
          //   title: data['title'],
          //   content: [],
          //   createdAt: data['createdAt'],
          //   id: data['_id']

          // )
          break;
        case 400:
          print('error create document 400');
          break;
        default:
          print(res.statusCode);
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
      print("error:   $error");
    }
    return errorModel;
  }

  Future<ErrorModel> getDocument(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      var res = await _client.get(Uri.parse("$HOST/api/docs/"), headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': token
      });
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          List data = jsonDecode(res.body)['documents'];
          documents =
              data.map((e) => DocumentModel.fromJson(jsonEncode(e))).toList();
          errorModel = ErrorModel(error: null, data: documents);
          // DocumentModel(
          //   uid: data['uid'],
          //   title: data['title'],
          //   content: [],
          //   createdAt: data['createdAt'],
          //   id: data['_id']

          // )
          break;
        case 400:
          print('error fetching document 400');
          break;
        default:
          print(res.statusCode);
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
      print("error:   $error");
    }
    return errorModel;
  }

  Future<ErrorModel> updateTilte(
      {required String token,
      required String id,
      required String title}) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      var res = await _client.post(Uri.parse("$HOST/api/docs/title"),
          body: jsonEncode({"id": id, "title": title}),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-auth-token': token
          });
      switch (res.statusCode) {
        case 200:
          // print(DocumentModel.fromJson(res.body));
          var data = jsonDecode(res.body)['document'];
          errorModel = ErrorModel(
              error: null, data: DocumentModel.fromJson(jsonEncode(data)));
          break;
        case 400:
          print('error create document 400');
          break;
        default:
          print(res.statusCode);
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
      print("error:   $error");
    }
    return errorModel;
  }

  Future<ErrorModel> getSingleDocument(String token, String id) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Something unexpectd error occured!', data: null);
    try {
      var res = await _client.get(Uri.parse("$HOST/api/docs/$id"), headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': token
      });
      switch (res.statusCode) {
        case 200:
          var data = jsonDecode(res.body)['document'];
          errorModel = ErrorModel(
              error: null, data: DocumentModel.fromJson(jsonEncode(data)));
          break;
        case 400:
          print('error fetching document 400');
          break;
        default:
          print(res.statusCode);
          throw "This document does not exist, Please create a new one.";
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
      print("error:   $error");
    }
    return errorModel;
  }
}
