import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  String? get token => _user?.token;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> login(User user) async {
    _user = user;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
