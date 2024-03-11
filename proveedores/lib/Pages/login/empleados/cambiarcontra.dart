import "package:flutter/material.dart";
import "package:construtech/Apis/empleados/login.dart";
import "package:construtech/Pages/login/empleados/loginempleado.dart";

// ignore: camel_case_types
class cambiarcontraemp extends StatefulWidget {
  final String email;
  const cambiarcontraemp({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _cambiarcontraempState createState() => _cambiarcontraempState();
}

// ignore: camel_case_types
class _cambiarcontraempState extends State<cambiarcontraemp> {
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
                      labelText: "Ingrese su contraseña nueva"),
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
                    AuthService authService = AuthService();
                    String? response = await authService.changePass(
                        _contrasenaController.text, widget.email);
                    if (response != null) {
                      _mostrarMensajeSi();
                    } else {
                      _mostrarMensajeNo();
                    }
                  },
                  child: const Text("Cambiar contraseña",
                      style: TextStyle(color: Colors.white)),
                )
              ],
            )),
      ),
    );
  }

  void _mostrarMensajeSi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Info"),
          content: const Text("Redireccionando al login de empleados"),
          actions: [
            TextButton(
              onPressed: () {
                _irALogin();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensajeNo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text(
              "Redireccionando al formulario para cambiar contraseña"),
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

  void _irALogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const EmpleadoLoginPage()),
      (route) => false,
    );
  }
}
