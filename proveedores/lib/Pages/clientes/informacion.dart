import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import "package:construtech/Apis/clientes/login.dart";
import "package:construtech/Pages/clientes/cambiarinformacion.dart";

class CambiarInfoForm extends StatefulWidget {
  final int idCli;
  const CambiarInfoForm({super.key, required this.idCli});

  @override
  CambiarInfoFormState createState() => CambiarInfoFormState();
}

class CambiarInfoFormState extends State<CambiarInfoForm> {
  // Controladores para los campos del formulario
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController tipoDocController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fechaNacController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Llamada al método para obtener datos del API
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://apismovilconstru.onrender.com/cliente/${widget.idCli}'));

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, decodifica el cuerpo JSON de la respuesta.
      Map<String, dynamic> apiData = json.decode(response.body);

      // Actualiza los controladores con los datos del API
      nombreController.text = apiData["nombre"];
      apellidosController.text = apiData["apellidos"];
      tipoDocController.text = apiData["tipoDoc"];
      cedulaController.text = apiData["cedula"];
      direccionController.text = apiData["direccion"];
      emailController.text = apiData["email"];
      fechaNacController.text = apiData["fecha_nac"];
      telefonoController.text = apiData["telefono"];
    } else {
      // Si la solicitud no fue exitosa, lanza una excepción.
      throw Exception('Error al cargar los datos del cliente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Información personal'),
        ),
        body: SingleChildScrollView(
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
                  TextFormField(
                    controller: tipoDocController,
                    decoration:
                        const InputDecoration(labelText: 'Tipo de documento'),
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
                      DateTime initialDate = currentDate.subtract(
                          const Duration(
                              days: 18 *
                                  365)); // Restar 18 años desde la fecha actual

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(1900),
                        lastDate:
                            initialDate, // Configurar lastDate como la fecha inicial
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
                      _mostrarMensajeSi();
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
                      if (response != null) {
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
                          backgroundColor:
                              const Color.fromARGB(255, 12, 195, 106),
                        ));
                      } else {
                        _mostrarAlerta(
                            "Error", "No se pudo actualizar el usuario");
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
        ));
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
                Navigator.of(context).pop(); // Cerrar la alerta
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensajeSi() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario actualizado con exito!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Redirige al HomePage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => cambiarInfoScreen(
                idCli: widget.idCli,
              )),
      (route) => false,
    );
  }
}
