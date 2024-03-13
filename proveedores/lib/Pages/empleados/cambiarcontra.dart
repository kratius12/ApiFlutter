import "package:construtech/main.dart";
import "package:flutter/material.dart";
import "package:construtech/Apis/empleados/login.dart";

import "package:construtech/Pages/empleados/cambiarinformacion.dart";

// ignore: camel_case_types
class cambiarcontraEmp extends StatefulWidget {
  final int idEmp;
  const cambiarcontraEmp({Key? key, required this.idEmp}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _cambiarcontraEmpState createState() => _cambiarcontraEmpState();
}

// ignore: camel_case_types
class _cambiarcontraEmpState extends State<cambiarcontraEmp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  Future<String?> _changePassword() async {
    AuthService authService = AuthService();
    return authService.changePassEn(_contrasenaController.text, widget.idEmp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Cambiar contraseña", style: TextStyle(color:Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ), (route)=>false
              );
            },
          ),
        ],
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

                  // Realiza la solicitud y espera la respuesta
                  String? response = await _changePassword();

                  // Cierra el indicador de carga
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();

                  // Muestra el mensaje y redirige según la respuesta
                  if (response != null) {
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
    Navigator.pop(
      context,
      MaterialPageRoute(
          builder: (context) => cambiarInfoScreen(
                idEmp: widget.idEmp,
              )),
      // (route) => false,
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
