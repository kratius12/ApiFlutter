import 'package:flutter/material.dart';

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
          title: const Text('Interfaz Flutter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  
                },
                child:const  Column(
                  children: [
                    Text("Ingresar"),
                    Text("Empleado"),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Espacio entre los botones
              ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón de "Ingresar Cliente"
                  print("Ingresar Cliente");
                },
                child: const Column(
                  children: [
                    Text("Ingresar"),
                    Text("Cliente"),
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
