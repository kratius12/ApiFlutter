import 'package:flutter/material.dart';
import "package:proveedores/Apis/clientes/login.dart";

class EnviarCodigoFormCliente extends StatefulWidget {
  const EnviarCodigoFormCliente({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnviarCodigoFormState createState() => _EnviarCodigoFormState();
}

class _EnviarCodigoFormState extends State<EnviarCodigoFormCliente> {
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
              ElevatedButton(
                onPressed: () async {
                  AuthService authService =
                      AuthService(); // Crear instancia de AuthService
                  String? response =
                      await authService.checkcode(_codigoController.text);
                  String mesaje = "";
                  if (_formKey.currentState!.validate() && response != null) {
                    mesaje = "Codigo verificado correctamente";
                    _mostrarMensaje(mesaje, "Excelente!");
                  } else {
                    mesaje =
                        "El codigo no pudo ser verificado, pudo haber excedido los 15 minutos o es un codigo invalido";
                    _mostrarMensaje(mesaje, "Error");
                  }
                },
                child: const Text('Enviar Código'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarMensaje(String mensaje, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
