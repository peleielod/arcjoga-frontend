import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:arcjoga_frontend/models/user.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<bool> isTokenExpired() async {
    final expiryString = await _storage.read(key: 'tokenExpiry');
    if (expiryString != null) {
      final expiryDate = DateTime.tryParse(expiryString);
      if (expiryDate != null) {
        return expiryDate.isBefore(DateTime.now());
      }
    }
    // Assume expired if there's no expiry information
    return true;
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final expiryString = await _storage.read(key: 'tokenExpiry');
    if (token != null && expiryString != null) {
      final expiry = DateTime.tryParse(expiryString);
      if (expiry != null && expiry.isAfter(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  // Retrieve the logged-in user from SecureStorage
  Future<User?> getUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> decreaseFreeFortuneCount() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      User user = User.fromJson(json.decode(userJson));

      if (user.freeFortuneCount > 0) {
        user.freeFortuneCount -= 1;
        final updatedUserJson = json.encode(user.toJson());
        await _storage.write(
          key: 'user',
          value: updatedUserJson,
        );
      }
    }
  }
}
