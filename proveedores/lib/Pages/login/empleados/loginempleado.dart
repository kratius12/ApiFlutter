import 'package:flutter/material.dart';
import 'package:proveedores/Apis/empleados/obra.dart';
import 'package:proveedores/Pages/empleados/listar.dart';
import "package:proveedores/Apis/empleados/login.dart";
import "package:proveedores/Pages/login/empleados/codigo.dart";

class EmpleadoLoginPage extends StatefulWidget {
  const EmpleadoLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<EmpleadoLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login empleado'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.PNG',
                height: 200,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    String? token = await authService.loginUser(
                      usernameController.text,
                      passwordController.text,
                    );
                    int? response = authService.getUserIdFromToken(token!);
                    _mostrarAlerta(
                        'Login exitoso', 'Se ha logeado correctamente');
                    _irAListaObras(response);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Ingresar',
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
        )));
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
