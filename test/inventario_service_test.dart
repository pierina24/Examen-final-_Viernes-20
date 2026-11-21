import 'package:flutter_test/flutter_test.dart';
import 'package:examen_final/models/producto.dart';
import 'package:examen_final/services/inventario_service.dart';

void main() {
  late InventarioService inventario;

  setUp(() {
    inventario = InventarioService();
  });

  test('Registrar un producto correctamente', () {
    final producto = Producto(
      codigo: 'P001',
      nombre: 'Arroz',
      categoria: 'Abarrotes',
      precio: 4.50,
      stock: 10,
    );

    inventario.registrarProducto(producto);

    expect(inventario.totalProductos, 1);
    expect(inventario.productos.first.nombre, 'Arroz');
  });

  test('Aumentar el stock', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Arroz',
        categoria: 'Abarrotes',
        precio: 4.50,
        stock: 10,
      ),
    );

    inventario.aumentarStock('P001', 5);

    expect(inventario.productos.first.stock, 15);
  });

  test('Disminuir el stock', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Arroz',
        categoria: 'Abarrotes',
        precio: 4.50,
        stock: 10,
      ),
    );

    inventario.disminuirStock('P001', 3);

    expect(inventario.productos.first.stock, 7);
  });

  test('Calcular el valor total del inventario', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Arroz',
        categoria: 'Abarrotes',
        precio: 4.50,
        stock: 10,
      ),
    );

    expect(inventario.valorTotalInventario, 45.0);
  });

  test('Buscar productos por nombre', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Arroz',
        categoria: 'Abarrotes',
        precio: 4.50,
        stock: 10,
        estado: true,
      ),
    );
  });

  test('Filtrar productos por categoria', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Arroz',
        categoria: 'Abarrotes',
        precio: 4.50,
        stock: 10,
      ),
    );

    inventario.registrarProducto(
      Producto(
        codigo: 'P002',
        nombre: 'Leche',
        categoria: 'Lacteos',
        precio: 4.20,
        stock: 8,
      ),
    );

    final resultado = inventario.filtrarPorCategoria('Abarrotes');

    expect(resultado.length, 1);
    expect(resultado.first.nombre, 'Arroz');
  });

  test('Identificar productos con stock bajo', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Azucar',
        categoria: 'Abarrotes',
        precio: 3.80,
        stock: 3,
      ),
    );

    expect(inventario.totalStockBajo, 1);
  });

  test('No permitir stock negativo', () {
    inventario.registrarProducto(
      Producto(
        codigo: 'P001',
        nombre: 'Arroz',
        categoria: 'Abarrotes',
        precio: 4.50,
        stock: 2,
      ),
    );

    expect(() => inventario.disminuirStock('P001', 5), throwsException);
  });

  test('Cargar inventario con Future', () async {
    await inventario.cargarInventario();

    expect(inventario.totalProductos, 4);
    expect(inventario.totalAgotados, 1);
    expect(inventario.totalStockBajo, 1);
    expect(inventario.valorTotalInventario, 90.0);
  });
}
