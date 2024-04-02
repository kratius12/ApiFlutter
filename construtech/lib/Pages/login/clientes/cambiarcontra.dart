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
  bool _cambiandoContrasena = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          "Cambiar contraseña",
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
                onPressed: _cambiandoContrasena ? null : _cambiarContrasena,
                child: _cambiandoContrasena
                    ? CircularProgressIndicator()
                    : const Text(
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

  Future<void> _cambiarContrasena() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cambiandoContrasena = true;
      });

      AuthService authService = AuthService();
      int? response = await authService.changePass(
          _contrasenaController.text, widget.email);

      setState(() {
        _cambiandoContrasena = false;
      });

      if (response == 1) {
        _mostrarMensajeSi("Info", "Contraseña cambiada correctamente!");
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        _mostrarMensajeNo();
      }
    }
  }

  void _mostrarMensajeSi(String titulo, String mensaje) {
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
              "Contraseña cambiada correctamente!",
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
            "La contraseña no pudo ser actualizada",
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
}
