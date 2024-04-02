import 'dart:convert';
import 'package:http/http.dart' as http;

class ObrasService {
  ObrasService();

  Future<List<ObraDetalle>> getObras(int idCli) async {
    final response = await http.get(Uri.parse(
        'https://apismovilconstru-production-be9a.up.railway.app/obrasCli/$idCli'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("obras") && responseData["obras"] is List) {
        List<dynamic> obrasData = responseData["obras"];
        List<ObraDetalle> obras =
            obrasData.map((obra) => ObraDetalle.fromJson(obra)).toList();
        return obras;
      } else {
        throw Exception(
            'La propiedad "obras" no es una lista válida en la respuesta JSON.');
      }
    } else {
      throw Exception('Error al obtener las obras');
    }
  }

  Future<String?> createObra(
      String descripcion, String fechaini, int idCli) async {
    final response = await http.post(
        Uri.parse(
            'https://apismovilconstru-production-be9a.up.railway.app/obras'),
        body: {
          "descripcion": descripcion,
          "fechaini": fechaini.toString(),
          "idCliente": idCli.toString(),
          "idEmp": "1"
        });

    if (response.statusCode == 200) {
      return "ok";
    } else {
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
  final String? idCliente;
  final String? idEmp;
  final int? precio;
  final List<Actividad> actividades;

  ObraDetalle({
    required this.idObra,
    required this.descripcion,
    required this.fechaini,
    required this.fechafin,
    required this.estado,
    this.area,
    required this.idCliente,
    required this.idEmp,
    this.precio,
    this.actividades = const [],
  });

  factory ObraDetalle.fromJson(Map<String, dynamic> json) {
    List<dynamic> detalleObraData = json['detalle_obra'] ?? [];
    List<Actividad> actividades = detalleObraData
        .map((actividad) =>
            Actividad.fromJson(actividad as Map<String, dynamic>))
        .toList();

    final cliente = json['cliente'];
    final empleado = json['empleado'];

    return ObraDetalle(
      idObra: json['idObra'],
      descripcion: json['descripcion'],
      fechaini: json['fechaini'],
      fechafin: json['fechafin'],
      estado: json['estado'],
      area: json['area'],
      idCliente: cliente != null
          ? cliente['nombre'] + " " + cliente['apellidos']
          : null,
      idEmp: empleado != null
          ? empleado['nombre'] + " " + empleado['apellidos']
          : null,
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
