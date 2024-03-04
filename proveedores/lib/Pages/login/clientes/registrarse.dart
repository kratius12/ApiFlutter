import 'package:flutter/material.dart';
import 'package:proveedores/Apis/clientes/login.dart';

class RegistrationPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const RegistrationPage({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _tipoDocController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration:
                    const InputDecoration(labelText: 'Ingrese su nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _apellidosController,
                decoration:
                    const InputDecoration(labelText: 'Ingrese sus apellidos'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Telefono'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese su número de telefono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tipoDocController,
                decoration: const InputDecoration(labelText: 'Tipo documento'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un tipo de documento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cedula'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un número de documento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su dirección de residencia';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese su correo electronico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordConfirmController,
                decoration:
                    const InputDecoration(labelText: 'Confirme su contraseña'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor confirme su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    AuthService authService =
                        AuthService(); // Crear instancia de AuthService
                    String? response = await authService.register(
                        _nombreController.text,
                        _apellidosController.text,
                        _emailController.text,
                        _direccionController.text,
                        _telefonoController.text,
                        _tipoDocController.text,
                        _cedulaController.text,
                        _passwordController.text);
                    if (response != null) {
                      _mostrarMensaje('Registro exitoso');
                    } else {
                      _mostrarMensaje('No se pudo regisrar el cliente');
                    }
                  }
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mensaje'),
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
}
