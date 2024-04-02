import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final String baseUrl = "https://apismovilconstru-production-be9a.up.railway.app";

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
        return 'codigo enviado correctamente';
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error al realizar la solicitud: $e');
      return null;
    }
  }

  Future<int> changePass(String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/passwordCli'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      return 2;
    }
  }

  Future<String?> changePassEn(String password, int email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/passwordCliEn'),
        body: jsonEncode({'idCli': email, 'password': password}),
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

  Future<String?> checkcode(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkCode'),
        body: jsonEncode({'code': code}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return 'El codigo es correcto!';
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchCliente(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/cliente/$id'));

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, decodifica el cuerpo JSON de la respuesta.
      return json.decode(response.body);
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción.
      throw Exception('Error al cargar los datos del cliente');
    }
  }

  Future<int> checkEmail(String email, int? id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/checkEmail/$email/$id'));

    if (response.statusCode == 203) {
      return 2;
    } else {
      return 1;
    }
  }

  Future<String?> updateUser(
    
      int id,
      String nombre,
      String apellidos,
      String tipoDoc,
      String cedula,
      String direccion,
      String email,
      String fechaNac,
      String telefono) async {
        try{
    final response = await http.put(Uri.parse('$baseUrl/clienteMo/$id'), body: {
      "nombre": nombre,
      "apellidos": apellidos,
      "tipoDoc": tipoDoc,
      "cedula": cedula,
      "direccion": direccion,
      "email": email,
      "fecha_nac": fechaNac,
      "telefono": telefono
    });

    if (response.statusCode == 200) {
      return "Cliente actualizado con exito";
    } else {
      return null;
    }
    }
    catch(e){
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
      String fechaNac,
      String contrasena) async {
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
          'contrasena': contrasena,
          'estado': 1,
          'fecha_nac': fechaNac
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
      return null;
    }
  }
}
