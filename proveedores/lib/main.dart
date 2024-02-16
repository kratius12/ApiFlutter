import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProveedorList(),
    );
  }
}

class Proveedor {
  final String idProv;
  final String nombre;
  final String direccion;
  final String nit;
  final String tipo;
  final String estado;
  final String email;
  final String telefono;

  Proveedor({
    required this.idProv,
    required this.nombre,
    required this.direccion,
    required this.nit,
    required this.tipo,
    required this.estado,
    required this.email,
    required this.telefono,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProv: json['idProv'].toString(),
      nombre: json['nombre'].toString(),
      direccion: json['direccion'].toString(),
      nit: json['nit'].toString(),
      tipo: json['tipo'].toString(),
      estado: json['estado'].toString(),
      email: json['email'].toString(),
      telefono: json['telefono'].toString(),
    );
  }
}

class ProveedorList extends StatefulWidget {
  const ProveedorList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProveedorListState createState() => _ProveedorListState();
}

class _ProveedorListState extends State<ProveedorList> {
  List<Proveedor> proveedores = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:4000/provs'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        proveedores =
            jsonResponse.map((data) => Proveedor.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Proveedores'),
      ),
      body: ListView.builder(
        itemCount: proveedores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(proveedores[index].nombre),
            subtitle: Text(proveedores[index].tipo),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProveedorDetail(proveedor: proveedores[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarProveedor(),
            ),
          ).then((value) => fetchData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProveedorDetail extends StatelessWidget {
  final Proveedor proveedor;

  const ProveedorDetail({super.key, required this.proveedor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(proveedor.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id Proveedor: ${proveedor.idProv}'),
            Text('Nombre: ${proveedor.nombre}'),
            Text('Dirección: ${proveedor.direccion}'),
            Text('NIT: ${proveedor.nit}'),
            Text('Tipo: ${proveedor.tipo}'),
            Text('Estado: ${proveedor.estado}'),
            Text('Email: ${proveedor.email}'),
            Text('Teléfono: ${proveedor.telefono}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarProveedor(
                  proveedor:
                      proveedor), // Pasar el proveedor a la pantalla de edición
            ),
          ).then((value) => Navigator.pop(context));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class AgregarProveedor extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController nitController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  AgregarProveedor({super.key});

  Future<void> agregarProveedor(BuildContext context) async {
    final Map<String, dynamic> data = {
      'nombre': nombreController.text,
      'direccion': direccionController.text,
      'nit': nitController.text,
      'tipo': tipoController.text,
      'estado': estadoController.text,
      'email': emailController.text,
      'telefono': telefonoController.text,
    };

    final response = await http.post(
      Uri.parse('http://localhost:4000/newProv'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar el proveedor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: direccionController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: nitController,
              decoration: const InputDecoration(labelText: 'NIT'),
            ),
            TextField(
              controller: tipoController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: estadoController,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                agregarProveedor(context);
              },
              child: const Text('Agregar Proveedor'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditarProveedor extends StatelessWidget {
  final Proveedor proveedor;
  final TextEditingController nombreController;
  final TextEditingController direccionController;
  final TextEditingController nitController;
  final TextEditingController tipoController;
  final TextEditingController estadoController;
  final TextEditingController emailController;
  final TextEditingController telefonoController;

  EditarProveedor({Key? key, required this.proveedor})
      : nombreController = TextEditingController(text: proveedor.nombre),
        direccionController = TextEditingController(text: proveedor.direccion),
        nitController = TextEditingController(text: proveedor.nit),
        tipoController = TextEditingController(text: proveedor.tipo),
        estadoController = TextEditingController(text: proveedor.estado),
        emailController = TextEditingController(text: proveedor.email),
        telefonoController = TextEditingController(text: proveedor.telefono),
        super(key: key);

  Future<void> actualizarProveedor(BuildContext context) async {
    final Map<String, dynamic> data = {
      'nombre': nombreController.text,
      'direccion': direccionController.text,
      'nit': nitController.text,
      'tipo': tipoController.text,
      'estado': estadoController.text,
      'email': emailController.text,
      'telefono': telefonoController.text,
    };

    final response = await http.put(
      Uri.parse('http://localhost:4000/prov/${proveedor.idProv}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el proveedor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: direccionController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: nitController,
              decoration: const InputDecoration(labelText: 'NIT'),
            ),
            TextField(
              controller: tipoController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: estadoController,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                actualizarProveedor(context);
              },
              child: const Text('Actualizar Proveedor'),
            ),
          ],
        ),
      ),
    );
  }
}
