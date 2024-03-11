import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/obra.dart';
import 'package:construtech/Pages/empleados/listar.dart';
import "package:construtech/Apis/empleados/login.dart";
import "package:construtech/Pages/login/empleados/codigo.dart";

class EmpleadoLoginPage extends StatefulWidget {
  const EmpleadoLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<EmpleadoLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  late Future<String?> loginFuture;
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty || value == "") {
      return 'Campo requerido';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    loginFuture = Future.value(null); // Inicializar con un valor nulo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login empleado'),
        ),
        body: SingleChildScrollView(
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
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              // Validar campos antes de iniciar la transición de carga
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  // Iniciar la transición de carga
                                  loginFuture = authService.loginUser(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                                });

                                loginFuture.then((token) {
                                  if (token != null) {
                                    int? response =
                                        authService.getUserIdFromToken(token);
                                    _mostrarAlerta('Login exitoso',
                                        'Se ha logeado correctamente');
                                    _irAListaObras(response);
                                  } else {
                                    // Mostrar alerta en caso de credenciales inválidas
                                    _mostrarAlerta('Error de autenticación',
                                        'Credenciales inválidas');
                                  }
                                });
                              }
                            },
                            child: const Text(
                              "Ingresar",
                              style: TextStyle(color: Colors.white),
                            ),
                            // Resto del código...
                          )),
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
                ))));
  }

  void _mostrarAlerta(String titulo, String mensaje) {
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

  void _irAListaObras(int? response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObrasListScreenEmp(
          obrasService: ObrasService(),
          idEmp: response!,
        ),
      ),
    );
  }

  void _irACambiarContra() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EnviarCodigoPageEmp(),
        ));
  }
}
