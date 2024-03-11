import "package:flutter/material.dart";
import "package:proveedores/Apis/clientes/login.dart";

import "package:proveedores/Pages/clientes/cambiarinformacion.dart";

// ignore: camel_case_types
class cambiarcontraCli extends StatefulWidget {
  final int idCli;
  const cambiarcontraCli({Key? key, required this.idCli}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _cambiarcontracliState createState() => _cambiarcontracliState();
}

// ignore: camel_case_types
class _cambiarcontracliState extends State<cambiarcontraCli> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  Future<String?> _changePassword() async {
    AuthService authService = AuthService();
    return authService.changePassEn(_contrasenaController.text, widget.idCli);
  }

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
                  } else if (value.length < 8) {
                    return "La contraseña debe tener al menos 8 caracteres";
                  } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return "La contraseña debe tener al menos una letra mayúscula";
                  } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return "La contraseña debe tener al menos una letra minúscula";
                  } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                      .hasMatch(value)) {
                    return "La contraseña debe tener al menos un carácter especial";
                  } else {
                    return null;
                  }
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
                  } else if (value != _contrasenaController.text) {
                    return "La confirmación debe coincidir con la contraseña";
                  } else {
                    return null;
                  }
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

                  // Realiza la solicitud y espera la respuesta
                  String? response = await _changePassword();

                  // Cierra el indicador de carga
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();

                  // Muestra el mensaje y redirige según la respuesta
                  if (response != null && _formKey.currentState!.validate()) {
                    _mostrarMensajeSi();
                  } else {
                    _mostrarMensajeNo();
                  }
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

  void _mostrarMensajeSi() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contraseña cambiada con éxito'),
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

  void _mostrarMensajeNo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo cambiar la contraseña'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
