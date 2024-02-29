import 'package:flutter/material.dart';
import 'package:proveedores/Apis/clientes/login.dart';
import 'package:proveedores/Apis/clientes/obra.dart';
import 'package:proveedores/Pages/clientes/obras.dart';
import 'package:proveedores/Pages/login/registrarse.dart';

class ClienteLoginPage extends StatefulWidget {
  const ClienteLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ClienteLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService('http://localhost:4000/loginCli');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.PNG',
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
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

                  if (token != null) {
                    _mostrarAlerta(
                        'Login exitoso', 'Se ha logeado correctamente');
                    _irAListaObras();
                  } else {
                    _mostrarAlerta('Error', 'Login fallido.');
                  }
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _irAFormularioPersonalizado();
              },
              child: const Card(
                child: ListTile(
                  title: Text(
                    'Regístrate aquí!!',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              
            )
          ],
        ),
      ),
    );
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
                Navigator.of(context).pop(); // Cerrar la alerta
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _irAListaObras() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObrasListScreen(
          obrasService: ObrasService(),
        ),
      ),
    );
  }

  void _irAFormularioPersonalizado() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }
}


void _irACambiarContrasena(){
  Navigator.push(
    
  )
}