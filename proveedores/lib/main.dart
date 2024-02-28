import 'package:flutter/material.dart';
import 'package:proveedores/Pages/login/logincliente.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    BuildContext = LoginScreen()
                  );
                },
                child: const Column(
                  children: [
                    Text("Ingresar Empleado"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push()
                },
                child: const Column(
                  children: [
                    Text("Ingresar Cliente"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
