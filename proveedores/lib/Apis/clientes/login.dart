import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final String baseUrl = "http://localhost:4000";

  AuthService();

  Future<String?> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loginCli'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['token'];
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error al realizar la solicitud: $e');
      return null;
    }
  }

  Future<String?> enviarCodigo(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendCodeCli'),
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

  Future<String?> register(
      String nombre,
      String apellidos,
      String email,
      String direccion,
      String telefono,
      String tipoDoc,
      String cedula,
      // ignore: non_constant_identifier_names
      String constrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cliente'),
        body: jsonEncode({
          'nombre': nombre,
          'apellidos': apellidos,
          'email': email,
          'direccion': direccion,
          'telefono': telefono,
          'tipoDoc': tipoDoc,
          'cedula': cedula,
          'constrasena': constrasena,
          'estado': 1,
          'fecha_nac': "123213-123123-23222"
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return 'Cliente registrado con exito!!';
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
      return decodedToken['idCli'];
    } catch (e) {
      debugPrint('Error al decodificar el token: $e');
      return null;
    }
  }
}
