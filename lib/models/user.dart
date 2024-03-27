import 'dart:convert';

import 'package:arcjoga_frontend/models/user_sub.dart';

class User {
  final int id;
  final String email;
  final String username;
  final String? avatarUrl;
  final bool hasSub;
  final UserSub? userSub;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.hasSub,
    this.userSub,
  });

  factory User.fromJson(Map<String, dynamic> jsonObject) {
    return User(
      id: jsonObject['id'],
      username: jsonObject['name'] ?? jsonObject['username'],
      hasSub: jsonObject['has_sub'] == 1,
      avatarUrl: jsonObject['avatar_url'],
      email: jsonObject['email'],
      userSub: jsonObject['user_sub'] != null
          ? UserSub.fromJson(
              jsonObject['user_sub'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'has_sub': hasSub,
        'avatar_url': avatarUrl,
        'email': email,
      };
}
