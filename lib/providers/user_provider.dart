import 'package:arcjoga_frontend/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<User?> fetchUser() async {
    String? userJson = await _secureStorage.read(key: 'user');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
      notifyListeners();
      return _user;
    }
    return null;
  }

  Future<void> updateUser(User newUser) async {
    String userJson = json.encode(newUser.toJson());
    await _secureStorage.write(
      key: 'user',
      value: userJson,
    );
    _user = newUser;
    notifyListeners();
  }

  Future<bool> isUserLoggedIn() async {
    final token = await _secureStorage.read(key: 'token');
    final expiryString = await _secureStorage.read(key: 'tokenExpiry');
    if (token != null && expiryString != null) {
      final expiry = DateTime.tryParse(expiryString);
      if (expiry != null && expiry.isAfter(DateTime.now())) {
        _isLoggedIn = true;
        return true;
      }
    }
    _isLoggedIn = false;
    return false;
  }

  void login(String token, String expiresAt) async {
    _isLoggedIn = true;
    notifyListeners();

    await _secureStorage.write(key: 'token', value: token);
    await _secureStorage.write(key: 'tokenExpiry', value: expiresAt);
  }

  void logout() async {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
    await _secureStorage.delete(key: 'user');
    await _secureStorage.delete(key: 'useBiometricAuth');
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'tokenExpiry');
  }

  void logoff() async {}
}
