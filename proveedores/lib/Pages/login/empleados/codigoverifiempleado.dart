import 'package:flutter/material.dart';
import "package:proveedores/Apis/empleados/login.dart";
import "package:proveedores/Pages/login/empleados/cambiarcontra.dart";

class EnviarCodigoFormEmpleado extends StatefulWidget {
  final String email;
  const EnviarCodigoFormEmpleado({Key? key, required this.email})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnviarCodigoFormState createState() => _EnviarCodigoFormState();
}

class _EnviarCodigoFormState extends State<EnviarCodigoFormEmpleado> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Codigo de verificación"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                    labelText:
                        'Ingrese el codigo de confirmación que se ha enviado al correo.'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su correo electrónico';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  AuthService authService = AuthService();
                  String? response =
                      await authService.checkcode(_codigoController.text);
                  debugPrint(response);
                  if (_formKey.currentState!.validate() && response != null) {
                    _mostrarMensajeSi();
                  } else {
                    _mostrarMensajeNp();
                  }
                },
                child: const Text(
                  'Enviar Código',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Info"),
          content: const Text(
              "Redireccionando al formulario para cambiar contraseña"),
          actions: [
            TextButton(
              onPressed: () {
                _irAcambiarContra(widget.email);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensajeNp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("No se pudo verificar el codigo"),
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

  void _irAcambiarContra(String email) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => cambiarcontraemp(email: email)));
  }
}
