import 'package:construtech/Pages/clientes/solicitarservicio.dart';
import 'package:flutter/material.dart';
import 'package:construtech/Apis/clientes/obra.dart';
import 'package:construtech/Pages/clientes/detalleactividad.dart';
import 'package:construtech/main.dart';
import "package:construtech/Pages/clientes/cambiarinformacion.dart";

class ObrasListScreenCli extends StatefulWidget {
  final ObrasService obrasService;
  final int idCli;

  const ObrasListScreenCli({
    Key? key,
    required this.obrasService,
    required this.idCli,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ObrasListScreenState createState() => _ObrasListScreenState();
}

class _ObrasListScreenState extends State<ObrasListScreenCli> {
  late Future<List<ObraDetalle>> _obras;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _obras = widget.obrasService.getObras(widget.idCli);
    _cargarObras();
  }

  Future<void> _cargarObras() async {
    setState(() {
      _obras = widget.obrasService.getObras(widget.idCli);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarObras(); // Actualizar la lista de obras cuando cambian las dependencias
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
                      (route) => false,
                    );
                  },
                ),
              ],
            )
          : null, // Oculta la AppBar si el índice seleccionado no es 0
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Obras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi Perfil',
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
        return SolicitarServicioForm(idCli: widget.idCli);
      default:
        return const SizedBox.shrink();
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
              final obra = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(obra.descripcion!),
                  subtitle: Text('Estado: ${obra.estado}'),
                  onTap: () {
                    _mostrarDetalleObra(obra);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void _mostrarDetalleObra(ObraDetalle obra) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleObraScreen(
          obra: obra,
          idCli: widget.idCli,
        ),
      ),
    );
  }
}

class DetalleObraScreen extends StatelessWidget {
  final ObraDetalle? obra;
  final int idCli;

  const DetalleObraScreen({Key? key, required this.obra, required this.idCli})
      : super(key: key);

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
              _buildTableRow('Descripción', obra!.descripcion.toString()),
              _buildTableRow('Empleado\nencargado', obra!.idEmp.toString()),
              _buildTableRow('Cliente', obra!.idCliente.toString()),
              _buildTableRow('Fecha de \ninicio', obra!.fechaini.toString()),
              _buildTableRow('Estado', obra!.estado.toString()),
              if (obra!.fechafin == null)
                (const Text(""))
              else
                _buildTableRow(
                    'Fecha fin\n estimada', obra!.fechafin.toString()),
              if (obra!.area == null)
                (const Text(""))
              else
                _buildTableRow('Area', obra!.area.toString()),
              const SizedBox(
                height: 10,
              ),
              if (obra!.actividades.isNotEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    _mostrarActividades(context, obra!, obra!.idObra);
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
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

  void _mostrarActividades(BuildContext context, ObraDetalle obra, int idObra) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActividadesScreen(
          actividades: obra.actividades,
          idCli: idCli,
          idObra: idObra,
        ),
      ),
    );
  }
}

class ActividadesScreen extends StatelessWidget {
  final List<Actividad> actividades;
  final int idCli;
  final int idObra;

  const ActividadesScreen({
    Key? key,
    required this.actividades,
    required this.idCli,
    required this.idObra,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Actividades de la Obra',
          style: TextStyle(color: Colors.white),
        ),
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
                      idCli: idCli,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
