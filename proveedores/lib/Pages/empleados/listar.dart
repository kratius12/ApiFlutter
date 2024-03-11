import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/obra.dart';
import 'package:construtech/Pages/empleados/actualizarestado.dart';
import 'package:construtech/main.dart';
import "package:construtech/Pages/empleados/cambiarinformacion.dart";

class ObrasListScreenEmp extends StatefulWidget {
  final ObrasService obrasService;
  final int idEmp;

  const ObrasListScreenEmp({
    Key? key,
    required this.obrasService,
    required this.idEmp,
  }) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _ObrasListScreenState createState() => _ObrasListScreenState();
}

class _ObrasListScreenState extends State<ObrasListScreenEmp> {
  late Future<List<ObraDetalle>> _obras;

  @override
  void initState() {
    super.initState();
    _obras = widget.obrasService.getObras(widget.idEmp);
    _cargarObras();
  }

  Future<void> _cargarObras() async {
    setState(() {
      _obras = widget.obrasService.getObras(widget.idEmp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Obras empleados'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/LogoBlanco.png'))),
              child: Text(""),
            ),
            ListTile(
              title: const Text('Obras', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Cambiar la información de usuario',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => cambiarInfoScreen(
                              idEmp: widget.idEmp,
                            ))));
              },
            ),
            const SizedBox(
              height: 500,
            ),
            ListTile(
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<ObraDetalle>>(
        future: _obras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              // ignore: avoid_print
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data![index].descripcion!),
                    subtitle: Text('Estado: ${snapshot.data![index].estado}'),
                    onTap: () {
                      _mostrarDetalleObra(snapshot.data![index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarDetalleObra(ObraDetalle obra) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleObraScreen(
          obra: obra,
          idEmp: widget.idEmp,
        ),
      ),
    );
  }
}

class DetalleObraScreen extends StatelessWidget {
  final ObraDetalle obra;
  final int idEmp;

  const DetalleObraScreen({Key? key, required this.obra, required this.idEmp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Obra'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Descripción: ${obra.descripcion}'),
              Text('Empleado encargado: ${obra.idEmp}'),
              Text('Cliente: ${obra.idCliente}'),
              Text('Fecha de inicio: ${obra.fechaini}'),
              Text('Fecha de fin estimada: ${obra.fechafin}'),
              Text('Area: ${obra.area}'),
              Text('Estado: ${obra.estado}'),
              ElevatedButton(
                onPressed: () {
                  _mostrarActividades(context, obra);
                },
                child: const Text('Ver Actividades'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarActividades(BuildContext context, ObraDetalle obra) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActividadesScreen(
          actividades: obra.actividades,
          idEmp: idEmp,
        ),
      ),
    );
  }
}

class ActividadesScreen extends StatelessWidget {
  final List<Actividad> actividades;
  final int idEmp;

  const ActividadesScreen(
      {Key? key, required this.actividades, required this.idEmp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades de la Obra'),
      ),
      body: ListView.builder(
        itemCount: actividades.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(actividades[index].actividad!),
              subtitle: Text(
                'Fecha inicio: ${actividades[index].fechaini}, Estado: ${actividades[index].estado}',
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleActividadForm(
                        actividad: actividades[index],
                        idEmp: idEmp,
                      ),
                    ));
              },
            ),
          );
        },
      ),
    );
  }
}
