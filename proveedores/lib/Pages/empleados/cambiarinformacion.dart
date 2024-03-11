import "package:flutter/material.dart";
import "package:construtech/Apis/empleados/obra.dart";
import "package:construtech/Pages/empleados/cambiarcontra.dart";
import "package:construtech/Pages/empleados/informacion.dart";
import "package:construtech/main.dart";
import "package:construtech/Pages/empleados/listar.dart";

// ignore: camel_case_types
class cambiarInfoScreen extends StatefulWidget {
  final int idEmp;
  const cambiarInfoScreen({super.key, required this.idEmp});
  @override
  // ignore: library_private_types_in_public_api
  _CambiarInfoScreen createState() => _CambiarInfoScreen();
}

class _CambiarInfoScreen extends State<cambiarInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar Información"),
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
                ObrasService obrasService = ObrasService();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ObrasListScreenEmp(
                            obrasService: obrasService, idEmp: widget.idEmp)),
                    (route) => false);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => cambiarcontraEmp(
                              idEmp: widget.idEmp,
                            )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Cambiar Contraseña',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeForm(
                              idEmp: widget.idEmp,
                            )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Cambiar Información de Usuario',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
