import 'package:flutter_test/flutter_test.dart';
import 'package:examen_final/models/producto.dart';

void main() {
  test('Debe crear un producto correctamente', () {
    final producto = Producto(
      codigo: 'P001',
      nombre: 'Arroz',
      categoria: 'Alimentos',
      precio: 4.50,
      stock: 20,
    );

    expect(producto.codigo, 'P001');
    expect(producto.nombre, 'Arroz');
    expect(producto.precio, 4.50);
    expect(producto.stock, 20);
  });
}
