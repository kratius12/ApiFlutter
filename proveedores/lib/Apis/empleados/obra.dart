import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ObrasService {
  ObrasService();

  Future<List<Obra>> getObras(int idEmp) async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/obrasEmp/$idEmp'));
    debugPrint(idEmp as String?);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Obra> obras = data.map((obra) => Obra.fromJson(obra)).toList();
      return obras;
    } else {
      throw Exception('Error al obtener las obras');
    }
  }
}

class Obra {
  final String descripcion;
  final String estado;
  final String? fechaini;
  final String? area;
  final int? precio;
  final String? fechafin;

  Obra(
      {required this.descripcion,
      required this.estado,
      this.area,
      this.fechaini,
      this.precio,
      this.fechafin});

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      descripcion: json['descripcion'],
      fechaini: json['fechaini'],
      area: json['area'],
      precio: json['precio'],
      estado: json['estado'],
    );
  }
}
