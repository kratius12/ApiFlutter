import 'package:flutter/material.dart';
import 'package:construtech/Apis/clientes/obra.dart';
import 'package:construtech/main.dart';
import 'package:construtech/Pages/clientes/solicitarservicio.dart';
import 'package:construtech/Pages/clientes/cambiarinformacion.dart';

class ObrasListScreen extends StatefulWidget {
  final ObrasService obrasService;
  final int idCli;

  const ObrasListScreen({
    Key? key,
    required this.obrasService,
    required this.idCli,
  }) : super(key: key);

  @override
  _ObrasListScreenState createState() => _ObrasListScreenState();
}

class _ObrasListScreenState extends State<ObrasListScreen> {
  late Future<List<ObraDetalle>> _obras;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _obras = widget.obrasService.getObras(widget.idCli);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.grey,
              title: const Text(
                'Lista de Obras',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon:
                      const Icon(Icons.power_settings_new, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                  },
                ),
              ],
            )
          : null, // Oculta el AppBar si el índice seleccionado no es 0
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Obras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Solicitar cita',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildObrasList();
      case 1:
        return cambiarInfoScreen(idCli: widget.idCli);
      case 2:
        return SolicitarServicioForm(
          idCli: widget.idCli,
        );
      default:
        return Container();
    }
  }

  Widget _buildObrasList() {
    return FutureBuilder<List<ObraDetalle>>(
      future: _obras,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                  onTap: () {
                    _mostrarObra(snapshot.data![index]);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void _mostrarObra(ObraDetalle obra) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DetalleObraScreen(idCli: widget.idCli, obra: obra)));
  }
}

class DetalleObraScreen extends StatefulWidget {
  final ObraDetalle obra;
  final int idCli;

  const DetalleObraScreen({
    Key? key,
    required this.idCli, required this.obra,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetalleObraScreen createState() => _DetalleObraScreen();
}
class _DetalleObraScreen extends State<DetalleObraScreen>{
  late ObraDetalle obra; // Definir una variable obra para acceder a las propiedades de la obra

  @override
  void initState() {
    super.initState();
    obra = widget.obra; // Asignar el valor de widget.obra a la variable obra en el initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Detalle de la Obra',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              _buildTableRow('Descripción', obra.descripcion.toString()),
              _buildTableRow('Empleado\nencargado', obra.idEmp.toString()),
              _buildTableRow('Cliente', obra.idCliente.toString()),
              _buildTableRow('Fecha de \ninicio', obra.fechaini.toString()),
              _buildTableRow('Estado', obra.estado.toString()),
              if (obra.fechafin == null)
                (const Text(""))
              else
                _buildTableRow(
                    'Fecha fin\n estimada', obra.fechafin.toString()),
              if (obra.area == null)
                (const Text(""))
              else
                _buildTableRow('Area', obra.area.toString()),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  // late int id = obra.idObra;
                  // _mostrarActividades(context, obra, id);
                },
                child: const Text(
                  'Ver Actividades',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 19),
            ),
          ),
        ],
      ),
    );
  }

  // void _mostrarActividades(BuildContext context, ObraDetalle obra, int idObra) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ActividadesScreen(
  //         actividades: obra.actividades,
  //         idEmp: idEmp,
  //         idObra: idObra,
  //       ),
  //     ),
  //   );
  // }
}
