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
  bool isLoading = false;
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
                      Center(
                        child: GestureDetector(
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
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
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
          builder: (context) => ObrasListScreenCli(
            idCli: response!,
            obrasService: ObrasService(),
          ),
        ),
        (route) => false);
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
