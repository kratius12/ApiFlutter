import 'package:flutter/material.dart';
import 'package:construtech/Apis/clientes/obra.dart';

class DetalleActividadForm extends StatefulWidget {
  final int idCli;
  final Actividad actividad;

  const DetalleActividadForm(
      {Key? key, required this.actividad,  required this.idCli})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetalleActividadFormState createState() => _DetalleActividadFormState();
}

class _DetalleActividadFormState extends State<DetalleActividadForm> {
  late TextEditingController _estadoController;

  @override
  void initState() {
    super.initState();
    _estadoController = TextEditingController(text: widget.actividad.estado);
  }

  @override
  void dispose() {
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Detalle de Actividad',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Descripción'),
              initialValue: widget.actividad.actividad,
              readOnly: true,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Fecha de inicio'),
              initialValue: widget.actividad.fechaini,
              readOnly: true,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Dias estimados'),
              initialValue: widget.actividad.fechafin?.toString(),
              readOnly: true,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Estado'),
              initialValue: widget.actividad.estado,
              readOnly: true,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
