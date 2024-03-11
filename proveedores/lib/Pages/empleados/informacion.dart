import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:proveedores/Apis/empleados/login.dart';
import 'dart:convert';
import "package:proveedores/main.dart";
import 'package:proveedores/Pages/empleados/listar.dart';
import 'package:proveedores/Pages/empleados/cambiarinformacion.dart';
import "package:proveedores/Apis/empleados/obra.dart";

class EmployeeForm extends StatefulWidget {
  final int idEmp;
  const EmployeeForm({super.key, this.parentContext, required this.idEmp});
  final BuildContext? parentContext;

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  // Define controladores para cada campo
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _tipoDocController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData(); // Llamada al método para obtener datos del API
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://apismovilconstru.onrender.com/empleado/${widget.idEmp}'));

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, decodifica el cuerpo JSON de la respuesta.
      Map<String, dynamic> apiData = json.decode(response.body);

      // Actualiza los controladores con los datos del API
      _nombreController.text = apiData["nombre"];
      _apellidosController.text = apiData["apellidos"];
      _direccionController.text = apiData["direccion"];
      _emailController.text = apiData["email"];
      _telefonoController.text = apiData["telefono"];
      _cedulaController.text = apiData["cedula"];
      _tipoDocController.text = apiData["tipoDoc"];
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción.
      throw Exception('Error al cargar los datos del cliente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Empleado'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/LogoBlanco.png'))),
              child: Text(""),
            ),
            ListTile(
              title: const Text('Obras', style: TextStyle(color: Colors.white)),
              onTap: () {
                ObrasService obrasService = ObrasService();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ObrasListScreenEmp(
                            obrasService: obrasService, idEmp: widget.idEmp)),
                    (route) => false);
              },
            ),
            ListTile(
              title: const Text(
                'Cambiar la información de usuario',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => cambiarInfoScreen(
                              idEmp: widget.idEmp,
                            ))));
              },
            ),
            const SizedBox(
              height: 500,
            ),
            ListTile(
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese los apellidos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Por favor, ingrese un email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
              ),
              TextFormField(
                controller: _tipoDocController,
                decoration:
                    const InputDecoration(labelText: 'Tipo de Documento'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  AuthService authService = AuthService();
                  String? response = await authService.updateEmp(
                    _nombreController.text,
                    _direccionController.text,
                    _emailController.text,
                    _telefonoController.text,
                    _cedulaController.text,
                    _tipoDocController.text,
                    _apellidosController.text,
                    widget.idEmp,
                  );
                  if (response != null) {
                    _irACambiarInfo();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Usuario actualizado con exito!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 2000),
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 12, 195, 106),
                    ));
                  } else {
                    _mostrarAlerta("Error",
                        "No se pudo actualizar la información del usuario");
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _irACambiarInfo() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => cambiarInfoScreen(
                idEmp: widget.idEmp,
              )),
      (route) => false,
    );
  }
}
