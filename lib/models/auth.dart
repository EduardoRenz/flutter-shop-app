import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    bool isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return (isValid && _token != null);
  }

  String? get token => isAuth ? _token : null;
  String? get email => isAuth ? _email : null;
  String? get userId => isAuth ? _userId : null;

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${dotenv.env['WEB_API_KEY']}';
    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    }

    _token = body['idToken'];
    _email = body['email'];
    _userId = body['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          body['expiresIn'],
        ),
      ),
    );

    Store.saveMap('userData', {
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate!.toIso8601String(),
      'email': _email,
    });

    _autoLogout();
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _userId = userData['userId'];
    _email = userData['email'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _email = null;
    Store.remove('userData');
    _clearTimer();
    notifyListeners();
  }

  void _clearTimer() {
    _authTimer?.cancel();
    _authTimer = null;
  }

  void _autoLogout() {
    _clearTimer();
    final expireTime = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;
    _authTimer = Timer(Duration(seconds: expireTime), logout);
    notifyListeners();
  }
}
