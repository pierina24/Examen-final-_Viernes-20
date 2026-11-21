import 'package:examen_final/models/producto.dart';
import 'package:flutter/material.dart';

class InventarioService {
  // Lista donde almacenaremos los productos
  final List<Producto> _productos = [];

  // Obtener todos los productos
  List<Producto> get productos => List.unmodifiable(_productos);

  //Registrar un producto
  void registrarProducto(Producto producto) {
    if (producto.codigo.trim().isEmpty) {
      throw ArgumentError('El código es obligatorio');
    }

    if (producto.nombre.trim().isEmpty) {
      throw ArgumentError('El nombre es obligatorio');
    }

    if (producto.precio < 0 || producto.stock < 0) {
      throw ArgumentError('El precio y stock no pueden ser negativos');
    }

    // Verificar que no exista otro producto con el mismo código
    bool existe = _productos.any(
      (p) => p.codigo.toLowerCase() == producto.codigo.toLowerCase(),
    );

    if (existe) {
      throw Exception('El código del producto ya existe');
    }

    _productos.add(producto);
  }

  //Aumentar el stock
  void aumentarStock(String codigo, int cantidad) {
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad debe ser mayor que cero');
    }

    int index = _productos.indexWhere((p) => p.codigo == codigo);

    if (index == -1) {
      throw Exception('Producto no encontrado');
    }

    Producto producto = _productos[index];

    _productos[index] = producto.copyWith(stock: producto.stock + cantidad);
  }

  //Disminuir el stock
  void disminuirStock(String codigo, int cantidad) {
    if (cantidad <= 0) {
      throw ArgumentError('La cantidad debe ser mayor que cero');
    }

    int index = _productos.indexWhere((p) => p.codigo == codigo);

    if (index == -1) {
      throw Exception('Producto no encontrado');
    }

    Producto producto = _productos[index];

    if (producto.stock < cantidad) {
      throw Exception('No hay suficiente stock disponible');
    }

    _productos[index] = producto.copyWith(stock: producto.stock - cantidad);
  }

  void activarProducto(String codigo) {
    int index = _productos.indexWhere((p) => p.codigo == codigo);

    if (index == -1) {
      throw Exception('Productp no encontrado');
    }

    _productos[index] = _productos[index].copyWith(estado: true);
  }

  void desactivarProducto(String codigo) {
    int index = _productos.indexWhere((p) => p.codigo == codigo);

    if (index == -1) {
      throw Exception('Producto no encontrado');
    }

    _productos[index] = _productos[index].copyWith(estado: false);
  }

  // Buscar productos por nombre
  List<Producto> buscarProducto(String nombre) {
    return _productos.where((producto) {
      return producto.nombre.toLowerCase().contains(nombre.toLowerCase());
    }).toList();
  }

  //  Filtrar productos por categoría
  List<Producto> filtrarPorCategoria(String categoria) {
    return _productos.where((producto) {
      return producto.categoria.toLowerCase() == categoria.toLowerCase();
    }).toList();
  }

  //Obtener productos activos
  List<Producto> get productosActivos {
    return _productos.where((p) => p.estado).toList();
  }

  // Obtener productos desactivos
  List<Producto> get productoDesactivos {
    return productos.where((p) => p.estado).toList();
  }

  //  Identificar productos con stock bajo
  List<Producto> get productosStockBajo {
    return _productos
        .where((producto) => producto.stock > 0 && producto.stock < 5)
        .toList();
  }

  //  Identificar productos agotados
  List<Producto> get productosAgotados {
    return _productos.where((producto) => producto.stock == 0).toList();
  }

  // Calcular valor total del inventario
  double get valorTotalInventario {
    return _productos.fold(
      0.0,
      (total, producto) => total + (producto.precio * producto.stock),
    );
  }

  // Estadísticas del inventario
  int get totalProductos => _productos.length;

  int get totalAgotados => productosAgotados.length;

  int get totalStockBajo => productosStockBajo.length;

  // Simular carga de inventario con Future y async/await
  Future<void> cargarInventario() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (_productos.isEmpty) {
        registrarProducto(
          Producto(
            codigo: 'P001',
            nombre: 'Arroz',
            categoria: 'Abarrotes',
            precio: 4.50,
            stock: 10,
          ),
        );

        registrarProducto(
          Producto(
            codigo: 'P002',
            nombre: 'Azúcar',
            categoria: 'Abarrotes',
            precio: 3.80,
            stock: 3,
          ),
        );

        registrarProducto(
          Producto(
            codigo: 'P003',
            nombre: 'Aceite',
            categoria: 'Abarrotes',
            precio: 8.50,
            stock: 0,
          ),
        );

        registrarProducto(
          Producto(
            codigo: 'P004',
            nombre: 'Leche',
            categoria: 'Lácteos',
            precio: 4.20,
            stock: 8,
          ),
        );
      }
    } catch (e) {
      throw Exception('Error al cargar el inventario: $e');
    }
  }
}
