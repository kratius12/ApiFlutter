import 'dart:convert';
import 'package:http/http.dart' as http;

class ObrasService {
  ObrasService();

  Future<List<ObraDetalle>> getObras(int idEmp) async {
    final response = await http.get(
        Uri.parse('https://apismovilconstru.onrender.com/obrasEmp/$idEmp'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("obras") && responseData["obras"] is List) {
        List<dynamic> obrasData = responseData["obras"];

        // Mapear cada obra en la lista
        List<ObraDetalle> obras = obrasData
            .map((obra) => ObraDetalle.fromJson(obra as Map<String, dynamic>))
            .toList();

        return obras;
      } else {
        throw Exception(
            'La propiedad "obras" no es una lista válida en la respuesta JSON.');
      }
    } else {
      throw Exception('Error al obtener el detalle de la obra');
    }
  }

  Future<String?> updateActividad(int id, String estado) async {
    try {
      final response = await http.put(
        Uri.parse('https://apismovilconstru.onrender.com/estadoAct/$id'),
        body: jsonEncode({'estado': estado}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return "OK";
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> createActividad(
      actividad, fechaini, fechafin, estado, idEmp, idObra) async {
    try {
      final response = await http.post(
        Uri.parse("https://apismovilconstru.onrender.com/AddActividadMov"),
        body: ({
          "actividad": actividad,
          "fechaini": fechaini,
          "fechafin": fechafin,
          "estado": estado,
          "idObra": idObra,
          "idEmp": idEmp
        }),
      );

      if (response.statusCode == 200) {
        return 1;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class ObraDetalle {
  final int idObra;
  final String? descripcion;
  final String? fechaini;
  final String? fechafin;
  final String? estado;
  final String? area;
  final String? createdAt;
  final String? idCliente;
  final String? idEmp;
  final int? precio;
  final List<Actividad> actividades;

  ObraDetalle({
    required this.idObra,
    this.descripcion,
    this.fechaini,
    this.fechafin,
    this.estado,
    this.area,
    this.createdAt,
    this.idCliente,
    this.idEmp,
    this.precio,
    this.actividades = const [],
  });

  factory ObraDetalle.fromJson(Map<String, dynamic> json) {
    List<dynamic> detalleObraData = json['detalle_obra'] ?? [];
    List<Actividad> actividades = detalleObraData
        .map((actividad) =>
            Actividad.fromJson(actividad as Map<String, dynamic>))
        .toList();

    return ObraDetalle(
      idObra: json['idObra'],
      descripcion: json['descripcion'],
      fechaini: json['fechaini'],
      fechafin: json['fechafin'],
      estado: json['estado'],
      area: json['area'],
      createdAt: json['createdAt'],
      idCliente: json['cliente']['nombre'] + " " + json['cliente']['apellidos'],
      idEmp: json['empleado']['nombre'] + " " + json['empleado']['apellidos'],
      precio: json['precio'],
      actividades: actividades,
    );
  }
}

class Actividad {
  final int? id;
  final String? actividad;
  final String? fechaini;
  final int? fechafin;
  final String? estado;
  final int? idObra;

  Actividad({
    this.id,
    this.actividad,
    this.fechaini,
    this.fechafin,
    this.estado,
    this.idObra,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'],
      actividad: json['actividad'],
      fechaini: json['fechaini'],
      fechafin: json['fechafin'],
      estado: json['estado'],
      idObra: json['idObra'],
    );
  }
}
