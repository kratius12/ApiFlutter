import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/obra.dart';
import 'package:construtech/Pages/empleados/listar.dart';

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
  String _selectedEstado = '';

  @override
  void initState() {
    super.initState();
    _estadoController = TextEditingController(text: widget.actividad.estado);
    _selectedEstado = widget.actividad.estado ?? '';
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
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Estado de la actividad'),
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
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text("Guardando..."),
                            ],
                          ),
                        );
                      },
                    );
                    String? response;
                    ObrasService obrasService = ObrasService();
                    response = await obrasService.updateActividad(
                      widget.actividad.id as int,
                      _selectedEstado,
                    );

                    if (response == "OK") {
                      _irAListarObras();
                      _mostrarAlertaSI();
                    } else {
                      _mostrarAlertaNO();
                    }
                  },
                  child: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  )),
            )
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
              "Actividad actualizada con exito!",
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

  void _irAListarObras() {
    ObrasService obrasService = ObrasService();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ObrasListScreenEmp(
                  idEmp: widget.idEmp,
                  obrasService: obrasService,
                )),
        (route) => false);
  }
}
