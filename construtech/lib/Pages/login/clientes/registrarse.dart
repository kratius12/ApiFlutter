import 'package:flutter/material.dart';
import 'package:construtech/Apis/clientes/login.dart';
import 'package:construtech/main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ ]+$').hasMatch(value)) {
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

  List<String> dropdownItems = [
    'Cedula de ciudadania',
    'Cedula de extranjeria',
    'Pasaporte'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Registrarse',
          style: TextStyle(color: Colors.white),
        ),
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
                DropdownButtonFormField<String>(
                  value: dropdownItems.contains(_tipoDocController.text)
                      ? _tipoDocController.text
                      : dropdownItems.first,
                  onChanged: (newValue) {
                    setState(() {
                      _tipoDocController.text = newValue!;
                    });
                  },
                  items: dropdownItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Documento',
                  ),
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
                  validator: _validateEmail,
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
                        Object? emailExists =
                            await _checkEmailExists(_emailController.text);
                        Object? docExists = await _checkDocExists(
                            _cedulaController.text, _tipoDocController.text);
                        if (emailExists != null) {
                          // ignore: use_build_context_synchronously
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
                                  "El email ingresado ya está asociado a \notro usuario",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 2000),
                            width: 300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 0, 0),
                          ));
                        } else if (docExists != null) {
                          // ignore: use_build_context_synchronously
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
                                  "El número y tipo de documento ya \nestán asociados a otro usuario",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 2000),
                            width: 300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 0, 0),
                          ));
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
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                                    "Te haz registrado con exito!",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(milliseconds: 2000),
                              width: 300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 12, 195, 106),
                            ));
                          } else {
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
                                    "Error al registrar el usuario",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ],
                              ),
                              duration: const Duration(milliseconds: 2000),
                              width: 300,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 0, 0),
                            ));
                          }
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

  Future<Object?> _checkEmailExists(String email) async {
    // Llamar a la API para verificar si el correo electrónico ya existe
    final response = await http.get(Uri.parse(
        'https://apismovilconstru-production-be9a.up.railway.app/checkEmail/$email/0'));
    if (response.statusCode == 200) {
      return null;
    } else {
      // ignore: use_build_context_synchronously
      return "nada";
    }
  }

  Future<Object?> _checkDocExists(String cedula, String tipoDoc) async {
    // Llamar a la API para verificar si el tipo de documento y la cédula ya están registrados
    final response = await http.get(Uri.parse(
        'https://apismovilconstru-production-be9a.up.railway.app/checkDoc/$cedula/$tipoDoc/null'));
    if (response.statusCode == 200) {
      return null;
    } else {
      // ignore: use_build_context_synchronously
      return "nada";
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un correo electrónico';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor, ingrese un correo electrónico válido';
    }
    return null;
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
