import 'package:construtech/main.dart';
import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/login.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Cambiar contraseña",
            style: TextStyle(color: Colors.white)),
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
                decoration:
                    const InputDecoration(labelText: "Confirme su contraseña"),
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
                    AuthService authService = AuthService();
                    // Esperar la respuesta del API
                    String? resultado = await authService.changePass(
                        _contrasenaController.text, widget.email);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Cerrar el diálogo de carga

                    if (resultado != null) {
                      _irALogin();
                      _mostrarMensajeSi();
                    } else {
                      _mostrarMensajeNo();
                    }
                  }
                },
                child: const Text(
                  'Cambiar contraseña',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _irALogin() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  void _mostrarMensajeSi() {
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
            "La contraseña no se puedo actualizar",
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
