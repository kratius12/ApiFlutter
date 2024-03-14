import "package:flutter/material.dart";
import "package:construtech/Pages/clientes/cambiarcontra.dart";
import "package:construtech/Pages/clientes/informacion.dart";
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
        backgroundColor: Colors.grey,
        title: const Text(
          "Cambiar Información",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Logo.PNG", height: 200),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CambiarContraCli(
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
                backgroundColor: Colors.grey,
              ),
              child: const Text(
                'Cambiar Información perfil',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
