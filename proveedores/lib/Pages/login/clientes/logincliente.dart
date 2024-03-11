import 'package:flutter/material.dart';
import 'package:proveedores/Apis/clientes/login.dart';
import 'package:proveedores/Apis/clientes/obra.dart';
import 'package:proveedores/Pages/clientes/obras.dart';
import 'package:proveedores/Pages/login/clientes/registrarse.dart';
import 'package:proveedores/Pages/login/clientes/codigo.dart';

class ClienteLoginPage extends StatefulWidget {
  const ClienteLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ClienteLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

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
          title: const Text('Login cliente'),
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => validateRequired(value),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    validator: (value) => validateRequired(value),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? token = await authService.loginUser(
                            usernameController.text,
                            passwordController.text,
                          );
                          int? response =
                              authService.getUserIdFromToken(token!);
                          print(token);

                          _irAListaObras(response);
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
                  Card(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _irAFormularioPersonalizado();
                          },
                          child: const ListTile(
                            title: Text(
                              'Regístrate aquí!!',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _irACambiarContrasena();
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
        ));
  }

  void _irAListaObras(idCli) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObrasListScreen(
          idCli: idCli,
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

  void _irACambiarContrasena() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EnviarCodigoPage()));
  }
}
