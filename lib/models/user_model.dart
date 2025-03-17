// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  
  final String email;
  final String name;
  final String profilePic;
  final String id; 
  final String? token;

  UserModel({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.id,
    this.token,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? id,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'id': id,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      id: map['id'] as String,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, profilePic: $profilePic, id: $id, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.name == name &&
      other.profilePic == profilePic &&
      other.id == id &&
      other.token == token;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      profilePic.hashCode ^
      id.hashCode ^
      token.hashCode;
  }
}
