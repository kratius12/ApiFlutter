import 'package:flutter/material.dart';

class EnviarCodigo extends StatefulWidget{
  const EnviarCodigo({super.key})
  // ignore: empty_constructor_bodies
  @override
  // ignore: library_private_types_in_public_api
  _EnviarCodioState createState()=> _EnviarCodioState();
}

class _EnviarCodioState extends State<EnviarCodigo> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController tipoDocController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController constrasenController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(

    );
  }
}