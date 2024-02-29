import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<String?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/loginCli'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }

  int? getUserIdFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

      return decodedToken['idCli'];
    } catch (e) {
      debugPrint('Error al decodificar el token: $e');
      return null;
    }
  }
}
