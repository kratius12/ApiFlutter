import 'package:flutter/material.dart';
import "package:construtech/Apis/clientes/obra.dart";
import "package:construtech/main.dart";
import "package:construtech/Pages/clientes/solicitarservicio.dart";
import "package:construtech/Pages/clientes/cambiarinformacion.dart";

class ObrasListScreen extends StatefulWidget {
  final ObrasService obrasService;
  final int idCli;

  const ObrasListScreen({
    Key? key, // Use Key? key instead of super.key
    required this.obrasService,
    required this.idCli,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ObrasListScreenState createState() => _ObrasListScreenState();
}

class _ObrasListScreenState extends State<ObrasListScreen> {
  late Future<List<Obra>> _obras;

  get idCli => widget.idCli;

  @override
  void initState() {
    super.initState();
    _obras = widget.obrasService.getObras(widget.idCli);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Obras clientes'),
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
              title: const Text('Cambiar información de usuario',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => cambiarInfoScreen(idCli: idCli),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Solicitar cita',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SolicitarServicioForm(
                        idCli: widget.idCli,
                      ),
                    ));
              },
            ),
            const SizedBox(
              height: 440,
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
      body: FutureBuilder<List<Obra>>(
        future: _obras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Text(snapshot.data![index].descripcion),
                  subtitle: Text('Estado: ${snapshot.data![index].estado}'),
                ));
              },
            );
          }
        },
      ),
    );
  }
}
