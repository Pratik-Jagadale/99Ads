import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void message(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

class EmailAuthentication with ChangeNotifier {
  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBoRKKrdm8zQIECMR9jEORmp6ALtkUrVhk';

    try {
      final responce = await http.post(
        Uri.parse(url),
        body: jsonEncode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responceData = json.decode(responce.body);
      if (responceData['error'] != null) {
        throw (responceData['error']['message']);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signin(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBoRKKrdm8zQIECMR9jEORmp6ALtkUrVhk';
    try {
      final responce = await http.post(
        Uri.parse(url),
        body: jsonEncode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responceData = json.decode(responce.body);

      if (responceData['error'] != null) {
        throw (responceData['error']['message']);
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
