import "package:flutter/material.dart";
import "package:construtech/Pages/clientes/cambiarcontra.dart";
import "package:construtech/Pages/clientes/informacion.dart";
import "package:construtech/Pages/clientes/solicitarservicio.dart";
import "package:construtech/main.dart";

// ignore: camel_case_types
class cambiarInfoScreen extends StatefulWidget {
  final int idCli;
  const cambiarInfoScreen({super.key, required this.idCli});
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
                    builder: (context) =>
                        cambiarInfoScreen(idCli: widget.idCli),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => cambiarcontraCli(
                            idCli: widget.idCli,
                          )),
                );
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
                      builder: (context) => CambiarInfoForm(
                            idCli: widget.idCli,
                          )),
                );
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
