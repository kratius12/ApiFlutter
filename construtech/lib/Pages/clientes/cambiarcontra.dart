import "package:construtech/Pages/clientes/cambiarinformacion.dart";
import "package:flutter/material.dart";
import "package:construtech/Apis/clientes/login.dart";
import "package:construtech/main.dart";

class CambiarContraCli extends StatefulWidget {
  final int idCli;
  const CambiarContraCli({Key? key, required this.idCli}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CambiarContraCliState createState() => _CambiarContraCliState();
}

class _CambiarContraCliState extends State<CambiarContraCli> {
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
        backgroundColor: Colors.grey,
        title: const Text(
          "Cambiar contraseña",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
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
                  // Validar el formulario
                  if (_formKey.currentState!.validate()) {
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

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();

                    // Muestra el mensaje y redirige según la respuesta
                    if (response != null) {
                      _mostrarMensajeSi();
                    } else {
                      _mostrarMensajeNo();
                    }
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
              "Contraseña actualizada con exito!",
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

    // Redirige al cambiarInfoScreen
    Navigator.pop(
      context,
      MaterialPageRoute(
        builder: (context) => cambiarInfoScreen(
          idCli: widget.idCli,
        ),
      ),
    );
  }

  void _mostrarMensajeNo() {
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
              "No se pudo actualizar la contraseña!",
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
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      ),
    );
  }
}
