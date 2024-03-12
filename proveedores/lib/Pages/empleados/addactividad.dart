import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/obra.dart';
import 'package:construtech/Pages/empleados/listar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddActividadForm extends StatefulWidget {
  final int idEmp;
  final int idObra;

  const AddActividadForm({Key? key, required this.idEmp, required this.idObra})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetalleActividadFormState createState() => _DetalleActividadFormState();
}

class _DetalleActividadFormState extends State<AddActividadForm> {
  // ignore: non_constant_identifier_names
  TextEditingController ActividadController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController FechaIniController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController FechFinController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController EstadoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Agregar actividad',
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
              readOnly: false,
              controller: ActividadController,
            ),
            TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Seleccione la fecha de inicio de la actividad',
                        ),
                        controller: FechaIniController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2300),
                          );

                          if (pickedDate != null) {
                            FechaIniController.text = pickedDate.toString();
                          }
                          if (pickedDate != null) {
                            FechaIniController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese la fecha de inicio de la visita';
                          }
                          return null;
                        },
                      ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Dias estimados'),
              controller: FechFinController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Estado de la actividad'),
              onChanged: (String? newValue) {
                setState(() {
                  EstadoController.text = newValue!;
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
            //
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: ()  async{
                    ObrasService obrasService = ObrasService();
                    int? response = await  obrasService.createActividad(
                        ActividadController.text,
                        FechaIniController.text ,
                        FechFinController.text,
                        EstadoController.text,
                        widget.idEmp,
                        widget.idObra
                        );

                    if (response == 1) {
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
          content: const Text('No se pudo agregar la actividad'),
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
          content: const Text('Se agregó la actividad correctamente'),
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
