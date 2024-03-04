import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';


class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<String?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/login'),
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
   Future<String?> enviarCodigo(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendCode'),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Map<String, dynamic> data = jsonDecode(response.body);
        return 'codigo enviado correctamente';
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error al realizar la solicitud: $e');
      return null;
    }
  }
  
  Future<String?> checkcode(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkCode'),
        body: jsonEncode({'code': code}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return 'El codigo ha es correcto!';
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

   int? getUserIdFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      return decodedToken['idEmp'];
    } catch (e) {
      debugPrint('Error al decodificar el token: $e');
      return null;
    }
  }
}
