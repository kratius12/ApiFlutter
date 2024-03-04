import 'package:flutter/material.dart';
import 'package:proveedores/Pages/login/clientes/logincliente.dart';
import 'package:proveedores/Pages/login/empleados/loginempleado.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.PNG',
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClienteLoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, 
              ),
              child: const Text(
                'Ingresar como cliente',
                style: TextStyle(color: Colors.white), 
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmpleadoLoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.grey, 
              ),
              child: const Text(
                'Ingresar como Empleado',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
