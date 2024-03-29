import 'package:construtech/main.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import "package:construtech/Apis/clientes/login.dart";

class CambiarInfoForm extends StatefulWidget {
  final int idCli;
  const CambiarInfoForm({super.key, required this.idCli});

  @override
  CambiarInfoFormState createState() => CambiarInfoFormState();
}

class CambiarInfoFormState extends State<CambiarInfoForm> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController tipoDocController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fechaNacController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  late bool isLoading = false; // Inicializar isLoading como false

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://apismovilconstru.onrender.com/cliente/${widget.idCli}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> apiData = json.decode(response.body);

      nombreController.text = apiData["nombre"];
      apellidosController.text = apiData["apellidos"];
      tipoDocController.text = apiData["tipoDoc"];
      cedulaController.text = apiData["cedula"];
      direccionController.text = apiData["direccion"];
      emailController.text = apiData["email"];
      fechaNacController.text = apiData["fecha_nac"];
      telefonoController.text = apiData["telefono"];
    } else {
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
        title: const Text(
          'Información personal',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          formulario(),
          if (isLoading) // Mostrar el indicador de carga si isLoading es true
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  List<String> dropdownItems = ['CC', 'CE', 'PS'];
  Widget formulario() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              DropdownButtonFormField<String>(
                value: dropdownItems.contains(tipoDocController.text)
                    ? tipoDocController.text
                    : dropdownItems.first,
                onChanged: (newValue) {
                  setState(() {
                    tipoDocController.text = newValue!;
                  });
                },
                items:
                    dropdownItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Tipo de Documento',
                ),
              ),
              TextFormField(
                controller: cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
              ),
              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Fecha de nacimiento"),
                controller: fechaNacController,
                onTap: () async {
                  DateTime currentDate = DateTime.now();
                  DateTime initialDate =
                      currentDate.subtract(const Duration(days: 18 * 365));

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(1900),
                    lastDate: initialDate,
                  );

                  if (pickedDate != null) {
                    fechaNacController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
              ),
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  setState(() {
                    isLoading =
                        true; // Mostrar indicador de carga al presionar el botón
                  });
                  AuthService authService = AuthService();
                  String? response = await authService.updateUser(
                      widget.idCli,
                      nombreController.text,
                      apellidosController.text,
                      tipoDocController.text,
                      cedulaController.text,
                      direccionController.text,
                      emailController.text,
                      fechaNacController.text,
                      telefonoController.text);
                  setState(() {
                    isLoading =
                        false; // Ocultar indicador de carga después de obtener la respuesta del servidor
                  });
                  if (response != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    _mostrarMensajeSi();
                  } else {
                    // ignore: use_build_context_synchronously
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
                            "El usuario no pudo ser actualizado",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
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
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    ));
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

  void _mostrarMensajeSi() {
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
  }
}
