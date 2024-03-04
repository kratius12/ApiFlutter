import 'package:flutter/material.dart';
import "package:proveedores/Apis/clientes/obra.dart";
class ObrasListScreenEmp extends StatefulWidget {
  final ObrasService obrasService;

  const ObrasListScreenEmp({super.key, required this.obrasService});

  @override
  // ignore: library_private_types_in_public_api
  _ObrasListScreenState createState() => _ObrasListScreenState();
}

class _ObrasListScreenState extends State<ObrasListScreenEmp> {
  late Future<List<Obra>> _obras;

  @override
  void initState() {
    super.initState();
    _obras = widget.obrasService.getObras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Obras empleados'),
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
                return ListTile(
                  title: Text(snapshot.data![index].descripcion),
                  subtitle: Text('Estado: ${snapshot.data![index].estado}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
