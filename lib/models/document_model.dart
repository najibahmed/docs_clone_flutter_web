// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DocumentModel {
  final String uid;
  final String title;
  final List content;
  final DateTime createdAt;
  final String id;

  DocumentModel({
    required this.uid,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  DocumentModel copyWith({
    String? uid,
    String? title,
    List? content,
    DateTime? createdAt,
    String? id,
  }) {
    return DocumentModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      '_id': id,
    };
  }

factory DocumentModel.fromMap(Map<String, dynamic> map) {
  return DocumentModel(
    uid: map['uid'] as String,
    title: map['title'] as String,
    content: map['content'] != null ? List<dynamic>.from(map['content']) : [],
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    id: map['_id'] as String,
  );
}

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentModel(uid: $uid, title: $title, content: $content, createdAt: $createdAt, _id: $id)';
  }

  @override
  bool operator ==(covariant DocumentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.title == title &&
      listEquals(other.content, content) &&
      other.createdAt == createdAt &&
      other.id == id;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      title.hashCode ^
      content.hashCode ^
      createdAt.hashCode ^
      id.hashCode;
  }
}
