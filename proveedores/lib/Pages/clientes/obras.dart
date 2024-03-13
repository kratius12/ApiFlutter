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
  late Future<List<Obra>> _obras;
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
              title: const Text('Lista de Obras', style: TextStyle(color: Colors.white),),
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
        return SolicitarServicioForm(idCli: widget.idCli,);
      default:
        return Container();
    }
  }

  Widget _buildObrasList() {
    return FutureBuilder<List<Obra>>(
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
                ),
              );
            },
          );
        }
      },
    );
  }
}
