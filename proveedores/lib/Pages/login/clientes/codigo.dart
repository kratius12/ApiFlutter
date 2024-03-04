import "package:flutter/material.dart";
import 'package:proveedores/Apis/clientes/login.dart';
import 'package:proveedores/Pages/login/clientes/codigoverificliente.dart';

class EnviarCodigoPage extends StatefulWidget {
  const EnviarCodigoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnviarCodigoPageState createState() => _EnviarCodigoPageState();
}

class _EnviarCodigoPageState extends State<EnviarCodigoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Código de Verificación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su correo electrónico';
                  } else if (!isValidEmail(value)) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String? resultado =
                      await AuthService().enviarCodigo(_emailController.text);
                  if (_formKey.currentState!.validate()) {
                    String mensaje = "";
                    if (resultado != null) {
                      mensaje = "Código enviado exitosamente.";
                      _mostrarMensajeOk('Info', mensaje);
                    } else {
                      mensaje = "No se pudo enviar el código de verificación.";
                      _mostrarMensaje('Error', mensaje);
                    }
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

  bool isValidEmail(String email) {
    // Puedes usar una expresión regular o cualquier lógica que prefieras
    // para validar la estructura del correo electrónico.
    // Este es solo un ejemplo básico.
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  void _mostrarMensaje(String titulo, String mensaje) {
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

  void _mostrarMensajeOk(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EnviarCodigoFormCliente()));
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
