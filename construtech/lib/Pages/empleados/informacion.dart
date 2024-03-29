import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:construtech/Apis/empleados/login.dart';
import 'dart:convert';
import "package:construtech/main.dart";
import 'package:construtech/Pages/empleados/cambiarinformacion.dart';

class EmployeeForm extends StatefulWidget {
  final int idEmp;
  const EmployeeForm({Key? key, this.parentContext, required this.idEmp})
      : super(key: key);
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
  String? _tipoDocValue; // Nuevo controlador para el tipo de documento
  bool isLoading = false; // Estado para controlar la carga

  @override
  void initState() {
    super.initState();
    fetchData(); // Llamada al método para obtener datos del API
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Mostrar carga mientras se obtiene la información
    });

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
      _tipoDocValue =
          apiData["tipoDoc"]; // Asigna el valor del tipo de documento
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción.
      throw Exception('Error al cargar los datos del cliente');
    }

    setState(() {
      isLoading = false; // Ocultar carga después de obtener la información
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Información de perfil",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () {
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
      body:
          isLoading ? const Center(child: CircularProgressIndicator()) : buildForm(),
    );
  }

  Widget buildForm() {
    return Padding(
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
            DropdownButtonFormField<String>(
              value: _tipoDocValue,
              onChanged: (newValue) {
                setState(() {
                  _tipoDocValue = newValue;
                });
              },
              items: <String>['CC', 'CE', 'PS']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Tipo de Documento',
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: isLoading ? null : _guardarInfo,
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _guardarInfo() async {
    setState(() {
      isLoading = true; // Mostrar carga mientras se procesa la solicitud
    });

    AuthService authService = AuthService();
    String? response = await authService.updateEmp(
      _nombreController.text,
      _direccionController.text,
      _emailController.text,
      _telefonoController.text,
      _cedulaController.text,
      _tipoDocValue!, // Utiliza el valor seleccionado del dropdown
      _apellidosController.text,
      widget.idEmp,
    );

    setState(() {
      isLoading = false; // Ocultar carga después de obtener la respuesta
    });

    if (response != null) {
      _irACambiarInfo();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
                "Usuario actualizado con éxito!",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 2000),
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          backgroundColor: const Color.fromARGB(255, 12, 195, 106),
        ),
      );
    } else {
      _mostrarAlerta();
    }
  }

  void _mostrarAlerta() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.cancel,
            color: Colors.black,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "No se ha podido actualizar la información de perfil",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 2000),
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    ));
  }

  void _irACambiarInfo() {
    Navigator.pop(
      context,
      MaterialPageRoute(
          builder: (context) => cambiarInfoScreen(
                idEmp: widget.idEmp,
              )),
    );
  }
}
