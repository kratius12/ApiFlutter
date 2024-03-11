import 'package:flutter/material.dart';
import 'package:proveedores/Apis/empleados/obra.dart';
import 'package:proveedores/Pages/empleados/listar.dart';

class DetalleActividadForm extends StatefulWidget {
  final int idEmp;
  final Actividad actividad;

  const DetalleActividadForm(
      {Key? key, required this.actividad, required this.idEmp})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetalleActividadFormState createState() => _DetalleActividadFormState();
}

class _DetalleActividadFormState extends State<DetalleActividadForm> {
  late TextEditingController _estadoController;
  String _selectedEstado = ''; // Variable para almacenar el estado seleccionado

  @override
  void initState() {
    super.initState();
    _estadoController = TextEditingController(text: widget.actividad.estado);
    _selectedEstado =
        widget.actividad.estado ?? ''; // Establece el estado inicial
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
        title: const Text('Detalle de Actividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Actividad'),
              initialValue: widget.actividad.actividad,
              readOnly: true,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Fecha de inicio'),
              initialValue: widget.actividad.fechaini,
              readOnly: true,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Fecha fin'),
              initialValue: widget.actividad.fechafin?.toString(),
              readOnly: true,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Estado'),
              value: _selectedEstado,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEstado = newValue!;
                });
              },
              items: ['En curso', 'En revisión', 'Terminada']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                String? response;
                ObrasService obrasService = ObrasService();

                response = await obrasService.updateActividad(
                  widget.actividad.id as int,
                  _selectedEstado,
                );

                if (response == "OK") {
                  _mostrarAlertaSI();
                } else {
                  _mostrarAlertaNO();
                }
              },
              child: const Text("Editar"),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAlertaNO() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('No se pudo editar la actividad'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAlertaSI() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: const Text('Se editó la actividad correctamente'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ObrasService obrasService = ObrasService();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ObrasListScreenEmp(
                              idEmp: widget.idEmp,
                              obrasService: obrasService,
                            )),
                    (route) => false);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
