import 'package:flutter/material.dart';
import 'package:construtech/Apis/clientes/login.dart';
import 'package:construtech/Apis/clientes/obra.dart';
import 'package:construtech/Pages/clientes/obras.dart';
import 'package:construtech/Pages/login/clientes/registrarse.dart';
import 'package:construtech/Pages/login/clientes/codigo.dart';

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
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  validator: (value) => validateRequired(value),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          // Iniciar la transición de carga
                          loginFuture = authService.loginUser(
                            usernameController.text,
                            passwordController.text,
                          );
                        });

                        // Continuar con la lógica después de recibir la respuesta del API
                        loginFuture.then((token) {
                          if (token != null) {
                            int? response =
                                authService.getUserIdFromToken(token);
                            _mostrarAlerta(
                                'Login exitoso', 'Se ha logeado correctamente');
                            _irAListaObras(response);
                          } else {
                            // Mostrar ventana de alerta en caso de credenciales inválidas
                            _mostrarSnackbar('Credenciales incorrectas');
                          }
                        });
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
      ),
    );
  }

  // Función para mostrar un Snackbar
  void _mostrarSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
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
        builder: (context) => ObrasListScreen(
          idCli: response!,
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
