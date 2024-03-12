import 'package:flutter/material.dart';
import 'package:construtech/Apis/empleados/obra.dart';
import 'package:construtech/Pages/empleados/actualizarestado.dart';
import 'package:construtech/main.dart';
import 'package:construtech/Pages/empleados/addactividad.dart';
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
  int _selectedIndex = 0;

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
                'Lista de Obras empleados',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.power_settings_new, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
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
        return cambiarInfoScreen(idEmp: widget.idEmp);
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
        backgroundColor: Colors.grey,
        title: const Text('Detalle de la Obra', style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              Text('Descripción: ${obra.descripcion}'),
              const SizedBox(height: 10,),
              Text('Empleado encargado: ${obra.idEmp}'),
              const SizedBox(height: 10,),
              Text('Cliente: ${obra.idCliente}'),
              const SizedBox(height: 10,),
              Text('Fecha de inicio: ${obra.fechaini}'),
              const SizedBox(height: 10,),
              Text('Fecha de fin estimada: ${obra.fechafin}'),
              const SizedBox(height: 10,),
              Text('Area: ${obra.area}'),
              const SizedBox(height: 10,),
              Text('Estado: ${obra.estado}'),
              const SizedBox(height: 10,),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  late int id = obra.idObra;
                  _mostrarActividades(context, obra, id);
                },
                child: const Text('Ver Actividades', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarActividades(BuildContext context, ObraDetalle obra, int idObra) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActividadesScreen(
          actividades: obra.actividades,
          idEmp: idEmp, idObra: idObra,
        ),
      ),
    );
  }
}

class ActividadesScreen extends StatelessWidget {
  final List<Actividad> actividades;
  final int idEmp;
  final int idObra;

  const ActividadesScreen({
    Key? key,
    required this.actividades,
    required this.idEmp, required this.idObra,
    
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
                      idEmp: idEmp,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>  AddActividadForm(idEmp: idEmp, idObra: idObra, )));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

