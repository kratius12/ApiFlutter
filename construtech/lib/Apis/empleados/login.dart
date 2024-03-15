import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final String baseUrl = "https://apismovilconstru.onrender.com";

  AuthService();
  Future<String?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
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
        Uri.parse("https://apismovilconstru.onrender.com/sendCode"),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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

  Future<String?> changePass(String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/password'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return "El cambio de contraseña fue exitoso!";
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> changePassEn(String password, int email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/passwordEn'),
        body: jsonEncode({'idEmp': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return "El cambio de contraseña fue exitoso!";
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

  Future<Map<String?, dynamic>> getEmpleado(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/empleado/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar los datos del empleado');
    }
  }

  Future<String?> updateEmp(
    String nombre,
    String direccion,
    String email,
    String telefono,
    String cedula,
    String tipoDoc,
    String apellidos,
    int idEmp,
  ) async {
    try {
      final response = await Future.any([
        http.put(
          Uri.parse("$baseUrl/empleadoMo/$idEmp"),
          body: {
            "nombre": nombre,
            'direccion': direccion,
            "email": email,
            "telefono": telefono,
            "cedula": cedula,
            "tipoDoc": tipoDoc,
            "apellidos": apellidos,
          },
        ),
      ]);

      if (response.statusCode == 200) {
        return "${response.statusCode}";
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
