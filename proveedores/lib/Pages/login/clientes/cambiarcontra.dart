import "package:flutter/material.dart";
import "package:construtech/Apis/clientes/login.dart";

import "package:construtech/main.dart";

// ignore: camel_case_types
class cambiarcontraCli extends StatefulWidget {
  final String email;
  const cambiarcontraCli({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _cambiarcontraCliState createState() => _cambiarcontraCliState();
}

// ignore: camel_case_types
class _cambiarcontraCliState extends State<cambiarcontraCli> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Ingrese su contraseña nueva",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor ingrese su contraseña nueva";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmarController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirme su contraseña",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Por favor confirme su contraseña nueva";
                  }
                  if (value != _contrasenaController.text) {
                    return "La confirmación debe coincidir con la contraseña";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  // Muestra el indicador de carga durante la solicitud
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16.0),
                            Text("Cambiando contraseña..."),
                          ],
                        ),
                      );
                    },
                    barrierDismissible: false,
                  );
                  AuthService authService = AuthService();
                  int? response = await authService.changePass(
                      _contrasenaController.text, widget.email);
                  if (response == 2) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                  _mostrarMensajeSi(
                      "Info", "Redireccionando a la pagina principal");

                  // ignore: use_build_context_synchronously
                },
                child: const Text(
                  "Cambiar contraseña",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarMensajeSi(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
