// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ErrorModel {
  final String? error;
  final dynamic data;
  ErrorModel({
     this.error,
    required this.data,
  });



  ErrorModel copyWith({
    String? error,
    dynamic? data,
  }) {
    return ErrorModel(
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'data': data,
    };
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      error: map['error'] as String,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(String source) => ErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ErrorModel(error: $error, data: $data)';

  @override
  bool operator ==(covariant ErrorModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.error == error &&
      other.data == data;
  }

  @override
  int get hashCode => error.hashCode ^ data.hashCode;
}
