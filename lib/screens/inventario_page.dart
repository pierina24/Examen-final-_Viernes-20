import 'package:flutter/material.dart';
import 'package:examen_final/models/producto.dart';
import 'package:examen_final/services/inventario_service.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final InventarioService inventario = InventarioService();

  bool cargando = true;
  String? error;
  String busqueda = '';
  String categoriaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  // Cargar inventario de forma asincrona
  Future<void> cargarDatos() async {
    try {
      await inventario.cargarInventario();

      if (!mounted) return;

      setState(() {
        cargando = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = e.toString();
      });
    }
  }

  Future<void> cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas salir del sistema?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  // Obtener productos segun busqueda y categoria
  List<Producto> get productosFiltrados {
    List<Producto> resultado = inventario.productos;

    if (busqueda.isNotEmpty) {
      resultado = resultado
          .where((p) => p.nombre.toLowerCase().contains(busqueda.toLowerCase()))
          .toList();
    }

    if (categoriaSeleccionada != 'Todas') {
      resultado = resultado
          .where((p) => p.categoria == categoriaSeleccionada)
          .toList();
    }

    return resultado;
  }

  // Registrar producto
  void registrarProducto(Producto producto) {
    try {
      inventario.registrarProducto(producto);

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto registrado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Modificar stock
  void modificarStock(String codigo, int cantidad) {
    try {
      if (cantidad > 0) {
        inventario.aumentarStock(codigo, cantidad);
      } else {
        inventario.disminuirStock(codigo, cantidad.abs());
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Mostrar formulario
  void mostrarFormulario() {
    final codigoController = TextEditingController();
    final nombreController = TextEditingController();
    final categoriaController = TextEditingController();
    final precioController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registrar producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.inventory_2),
                  ),
                ),
                TextField(
                  controller: categoriaController,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                TextField(
                  controller: precioController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock inicial',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final precio = double.parse(precioController.text.trim());

                  final stock = int.parse(stockController.text.trim());

                  final producto = Producto(
                    codigo: codigoController.text.trim(),
                    nombre: nombreController.text.trim(),
                    categoria: categoriaController.text.trim(),
                    precio: precio,
                    stock: stock,
                    estado: true,
                  );

                  Navigator.pop(dialogContext);
                  registrarProducto(producto);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Datos incorrectos: $e')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    ).then((_) {
      codigoController.dispose();
      nombreController.dispose();
      categoriaController.dispose();
      precioController.dispose();
      stockController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text(
          'Sistema de Inventario',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF176B45),
        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: cerrarSesion,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: mostrarFormulario,
        backgroundColor: const Color(0xFF176B45),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        cargando = true;
                      });
                      cargarDatos();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: cargarDatos,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Resumen del inventario',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  // Estadisticas
                  Row(
                    children: [
                      Expanded(
                        child: tarjetaEstadistica(
                          'Productos',
                          '${inventario.totalProductos}',
                          Icons.inventory,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: tarjetaEstadistica(
                          'Agotados',
                          '${inventario.totalAgotados}',
                          Icons.remove_shopping_cart,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: tarjetaEstadistica(
                          'Stock bajo',
                          '${inventario.totalStockBajo}',
                          Icons.warning,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Valor total
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFD9F3E5),
                        child: Icon(
                          Icons.attach_money,
                          color: Color(0xFF176B45),
                        ),
                      ),
                      title: const Text('Valor total del inventario'),
                      subtitle: Text(
                        'S/ ${inventario.valorTotalInventario.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF176B45),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Mis productos',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // Buscador
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar producto por nombre...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (valor) {
                      setState(() {
                        busqueda = valor;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // Filtro
                  DropdownButtonFormField<String>(
                    value: categoriaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por categoría',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    items:
                        [
                          'Todas',
                          ...inventario.productos
                              .map((p) => p.categoria)
                              .toSet()
                              .toList(),
                        ].map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                    onChanged: (valor) {
                      setState(() {
                        categoriaSeleccionada = valor!;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  // Lista de productos
                  if (productosFiltrados.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Text('No se encontraron productos'),
                      ),
                    ),

                  ...productosFiltrados.map((producto) {
                    final bajo = producto.stock > 0 && producto.stock < 5;

                    final agotado = producto.stock == 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.inventory_2,
                                  color: Color(0xFF176B45),
                                  size: 32,
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        producto.nombre,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Código: ${producto.codigo}'),
                                      Text(
                                        producto.categoria,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'S/ ${producto.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    Text(
                                      producto.estado ? 'ACTIVO' : 'INACTIVO',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: producto.estado
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),

                                    Text(
                                      agotado
                                          ? 'AGOTADO'
                                          : bajo
                                          ? 'STOCK BAJO'
                                          : 'NORMAL',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: agotado
                                            ? Colors.red
                                            : bajo
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Divider(),

                            Row(
                              children: [
                                const Text(
                                  'Existencias:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const Spacer(),

                                IconButton(
                                  onPressed: producto.stock > 0
                                      ? () =>
                                            modificarStock(producto.codigo, -1)
                                      : null,
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),

                                Text(
                                  '${producto.stock}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () =>
                                      modificarStock(producto.codigo, 1),
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  // Widget reutilizable para las estadisticas
  Widget tarjetaEstadistica(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(icono, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
