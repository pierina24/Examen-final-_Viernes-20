import 'package:flutter/material.dart';
import 'package:examen_final/screens/login_page.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Inventario',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B45)),
        useMaterial3: true,
      ),

      home: const LoginPage(),
    );
  }
}
