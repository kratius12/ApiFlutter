import 'dart:convert';
import 'package:http/http.dart' as http;

class ObrasService {
  ObrasService();

  Future<List<Obra>> getObras(int idEmp) async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/obrasEmp/$idEmp'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Verifica si la propiedad "obras" existe y es una lista
      if (responseData.containsKey("obras") && responseData["obras"] is List) {
        List<dynamic> obrasData = responseData["obras"];

        List<Obra> obras =
            obrasData.map((obra) => Obra.fromJson(obra["obras"])).toList();
        print(obras);
        return obras;
      } else {
        throw Exception(
            'La propiedad "obras" no es una lista válida en la respuesta JSON.');
      }
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

  Obra({
    required this.descripcion,
    required this.estado,
    this.area,
    this.fechaini,
    this.precio,
    this.fechafin,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      descripcion: json['descripcion'] ?? '',
      fechaini: json['fechaini'] ?? '',
      area: json['area'] ?? '',
      precio: json['precio'] ?? 0,
      estado: json['estado'] ?? '',
      fechafin: json['fechafin'] ?? '',
    );
  }
}
