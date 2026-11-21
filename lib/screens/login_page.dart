import 'package:flutter/material.dart';

import 'inventario_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();

  bool ocultarPassword = true;
  bool cargando = false;

  // Credenciales de prueba
  final String usuarioCorrecto = 'admin';
  final String passwordCorrecta = '123456';

  void iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      cargando = true;
    });

    // Simular validacion del inicio de sesion
    await Future.delayed(const Duration(seconds: 1));

    final usuario = usuarioController.text.trim();
    final password = passwordController.text;

    if (!mounted) return;

    if (usuario == usuarioCorrecto && password == passwordCorrecta) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InventarioPage()),
      );
    } else {
      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o contraseña incorrectos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Form(
            key: _formKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono principal
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9F3E5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    size: 65,
                    color: Color(0xFF176B45),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'SISTEMA DE INVENTARIO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF176B45),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Control y administración de productos',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 35),

                // Tarjeta del login
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(22),

                    child: Column(
                      children: [
                        const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Usuario
                        TextFormField(
                          controller: usuarioController,
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingrese su usuario';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Contraseña
                        TextFormField(
                          controller: passwordController,
                          obscureText: ocultarPassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                ocultarPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  ocultarPassword = !ocultarPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese su contraseña';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 25),

                        // Boton ingresar
                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            onPressed: cargando ? null : iniciarSesion,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF176B45),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            child: cargando
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'INGRESAR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Sistema de Inventario - Examen Final',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
