import 'package:flutter/material.dart';
import 'package:proveedores/Apis/clientes/login.dart';
import 'package:proveedores/main.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
  final TextEditingController _fechaNacController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un nombre';
    }
    if (value.length < 3 || value.length > 50) {
      return 'El nombre debe tener entre 3 y 50 caracteres';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]+$').hasMatch(value)) {
      return 'El nombre no puede contener caracteres especiales ni números';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese sus apellidos';
    }
    if (value.length < 3 || value.length > 50) {
      return 'Los apellidos deben tener entre 3 y 50 caracteres';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]+$').hasMatch(value)) {
      return 'Los apellidos no pueden contener caracteres especiales ni números';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su dirección';
    }
    if (value.length < 10 || value.length > 50) {
      return 'La dirección debe tener entre 10 y 50 caracteres';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su número de teléfono';
    }
    if (value.length < 7 || value.length > 13) {
      return 'El número de teléfono debe tener entre 7 y 13 caracteres';
    }
    if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
      return 'El número de teléfono solo puede contener números y no puede iniciar en 0';
    }
    return null;
  }

  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su número de cédula';
    }
    if (value.length < 8 || value.length > 20) {
      return 'La cédula debe tener entre 8 y 20 caracteres';
    }
    if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
      return 'La cédula solo puede contener números y no puede iniciar en 0';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese una contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).*$').hasMatch(value)) {
      return 'La contraseña debe contener al menos una letra mayúscula, una letra minúscula y un número';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme su contraseña';
    }
    if (value != _passwordController.text) {
      return 'La confirmación de contraseña debe coincidir con la contraseña';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apellidosController,
                  decoration:
                      const InputDecoration(labelText: 'Ingrese sus apellidos'),
                  validator: _validateLastName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Telefono'),
                  validator: _validatePhoneNumber,
                ),
                TextFormField(
                  controller: _tipoDocController,
                  decoration:
                      const InputDecoration(labelText: 'Tipo documento'),
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
                  validator: _validateCedula,
                ),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  validator: _validateAddress,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Fecha de nacimiento"),
                  controller: _fechaNacController,
                  onTap: () async {
                    DateTime currentDate = DateTime.now();
                    DateTime initialDate = currentDate.subtract(const Duration(
                        days:
                            18 * 365)); // Restar 18 años desde la fecha actual

                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate:
                          initialDate, // Configurar lastDate como la fecha inicial
                    );

                    if (pickedDate != null) {
                      _fechaNacController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese su fecha de nacimiento';
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
                  obscureText: true,
                  validator: _validatePassword,
                ),
                TextFormField(
                  controller: _passwordConfirmController,
                  decoration: const InputDecoration(
                      labelText: 'Confirme su contraseña'),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      AuthService authService = AuthService();
                      int respuesta = await authService.checkEmail(
                          _emailController.text, null);
                      if (respuesta == 203) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("El correo ya existe")));
                      } else {
                        String? response = await authService.register(
                          _nombreController.text,
                          _apellidosController.text,
                          _emailController.text,
                          _direccionController.text,
                          _telefonoController.text,
                          _tipoDocController.text,
                          _cedulaController.text,
                          _fechaNacController.text,
                          _passwordController.text,
                        );
                        if (response != null) {
                          _mostrarMensajeSi('Registro exitoso');
                        } else {
                          _mostrarMensajeNo('No se pudo registrar el cliente');
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarMensajeSi(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensajeNo(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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
