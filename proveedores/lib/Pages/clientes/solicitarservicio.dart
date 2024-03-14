import "package:flutter/material.dart";
import "package:construtech/Apis/clientes/obra.dart";
import "package:construtech/main.dart";
import 'package:construtech/Pages/clientes/obras.dart';
import 'package:intl/intl.dart';

class SolicitarServicioForm extends StatefulWidget {
  final int idCli;
  const SolicitarServicioForm({super.key, required this.idCli});

  @override
  // ignore: library_private_types_in_public_api
  _SolicitarServicioFormState createState() => _SolicitarServicioFormState();
}

class _SolicitarServicioFormState extends State<SolicitarServicioForm> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final fechaController = TextEditingController();
  final tipoServController = TextEditingController();
  final telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitar cita", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey,
        actions: [
                IconButton(
                  icon:
                      const Icon(Icons.power_settings_new, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ), (route)=> false
                    );
                  },
                ),
              ],
      ),
      
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('', style: TextStyle(color: Colors.indigo)),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 1),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Seleccione una fecha para la visita',
                        ),
                        controller: fechaController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2300),
                          );
                          if (pickedDate != null) {
                            fechaController.text = pickedDate.toString();
                          }
                          if (pickedDate != null) {
                            fechaController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese la fecha de la visita';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: tipoServController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText:
                              "Ingrese una descripción del servicio que desea solicitar",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese la descripción del servicio';
                          } else if (value.length < 3) {
                            return 'La descripción debe tener al menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ObrasService obrasService = ObrasService();
                              Future<String?> solicitar =
                                  obrasService.createObra(
                                tipoServController.text,
                                fechaController.text,
                                widget.idCli,
                              );

                              if (await solicitar == "ok") {
                                _irAListaObras(widget.idCli);
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
                                        "Servicio solicitado con éxito!",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
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
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Guardar'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _irAListaObras(idCli) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ObrasListScreenCli(
          idCli: idCli,
          obrasService: ObrasService(),
        ),
      ),
    );
  }
}
