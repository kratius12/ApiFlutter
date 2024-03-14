import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/login.dart';
import 'package:construtech/Pages/login/empleados/cambiarcontra.dart';

class EnviarCodigoFormEmpleado extends StatefulWidget {
  final String email;
  const EnviarCodigoFormEmpleado({Key? key, required this.email})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnviarCodigoFormState createState() => _EnviarCodigoFormState();
}

class _EnviarCodigoFormState extends State<EnviarCodigoFormEmpleado> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoController = TextEditingController();

  late Future<String?> _checkCodeFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCodeFuture = Future<String?>.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          "Codigo de verificación",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(
                      labelText:
                          'Ingrese el codigo de confirmación que se ha enviado al correo.',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingrese su correo electrónico';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _isLoading ? null : _enviarCodigo,
                    child: const Text(
                      'Enviar Código',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _enviarCodigo() async {
    setState(() {
      _isLoading = true;
    });
    final authService = AuthService();
    _checkCodeFuture = authService.checkcode(_codigoController.text);
    try {
      final response = await _checkCodeFuture;
      if (_formKey.currentState!.validate() && response != null) {
        _irAVerificarCodigo(widget.email);
        _mostrarMensajeOk();
      } else {
        _mostrarMensajeNo();
      }
    } catch (e) {
      _mostrarMensajeNo();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _mostrarMensajeOk() {
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
              "Codigo verificado correctamente!",
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

  void _mostrarMensajeNo() {
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
            "El codigo no pudo ser verificado es \n invalido o ha exedido los 15 minutos",
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

  void _irAVerificarCodigo(String email) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => cambiarcontraemp(
                  email: email,
                )));
  }
}
