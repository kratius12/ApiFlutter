import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/obra.dart';
import 'package:construtech/Pages/empleados/listar.dart';
import "package:construtech/Apis/empleados/login.dart";
import "package:construtech/Pages/login/empleados/codigo.dart";

class EmpleadoLoginPage extends StatefulWidget {
  const EmpleadoLoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<EmpleadoLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  bool isLoading = false;

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty || value == "") {
      return 'Campo requerido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login empleado'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Logo.PNG',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => validateRequired(value),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Contraseña'),
                      validator: (value) => validateRequired(value),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  String? token = await authService.loginUser(
                                    usernameController.text,
                                    passwordController.text,
                                  );

                                  setState(() {
                                    isLoading = false;
                                  });

                                  if (token != null) {
                                    int? response =
                                        authService.getUserIdFromToken(token);
                                    _mostrarAlerta();
                                    _irAListaObras(response);
                                  } else {
                                    _mostrarAlertaNo();
                                  }
                                }
                              },
                        child: const Text(
                          "Ingresar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _irACambiarContra();
                            },
                            child: const ListTile(
                              title: Text(
                                'Cambiar contraseña',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  void _mostrarAlerta() {
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
              "Haz ingresado con exito!",
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

  void _mostrarAlertaNo() {
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
            "Credenciales de ingreso incorrectas",
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

  void _irAListaObras(int? response) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ObrasListScreenEmp(
          obrasService: ObrasService(),
          idEmp: response!,
        ),
      ),
      (route) => false,
    );
  }

  void _irACambiarContra() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnviarCodigoPageEmp(),
      ),
    );
  }
}
