import "package:flutter/material.dart";
import 'package:construtech/Apis/empleados/login.dart';
import 'package:construtech/Pages/login/empleados/codigoverifiempleado.dart';

class EnviarCodigoPageEmp extends StatefulWidget {
  const EnviarCodigoPageEmp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnviarCodigoPageState createState() => _EnviarCodigoPageState();
}

class _EnviarCodigoPageState extends State<EnviarCodigoPageEmp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<String?> _enviarCodigo() async {
    return AuthService().enviarCodigo(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Enviar Código de Verificación',
          style: TextStyle(color: Colors.white),
        ),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Mostrar la carga mientras se espera la respuesta del API
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    // Esperar la respuesta del API
                    String? resultado = await _enviarCodigo();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Cerrar el diálogo de carga

                    if (resultado != null) {
                      _irAVerificarCodigo(_emailController.text);
                      _mostrarMensajeOk();
                    } else {
                      _mostrarMensajeNo();
                    }
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

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  void _mostrarMensajeOk() {
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
              "Codigo enviado correctamente!",
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

  void _mostrarMensajeNo() {
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
            "El codigo no pudo ser enviado",
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

  void _irAVerificarCodigo(String email) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnviarCodigoFormEmpleado(
                  email: email,
                )));
  }
}
