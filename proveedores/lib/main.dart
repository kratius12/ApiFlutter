import 'package:flutter/material.dart';
import 'package:proveedores/Pages/login/logincliente.dart';
import 'package:proveedores/Pages/login/loginempleado.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un tipo de ingreso'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClienteLoginPage()),
                );
              },
              child: const Text('Ingresar como Cliente'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmpleadoLoginPage()),
                );
              },
              child: const Text('Ingresar como Empleado'),
            ),
          ],
        ),
      ),
    );
  }
}
