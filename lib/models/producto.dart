class Producto {
  final String codigo;
  final String nombre;
  final String categoria;
  final double precio;
  final int stock;
  final bool estado;

  //Constructor

  Producto({
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    this.estado = true,
  });

  // Metodo para actualizar los datos del producto
  Producto copyWith({
    String? codigo,
    String? nombre,
    String? categoria,
    double? precio,
    int? stock,
    bool? estado,
  }) {
    return Producto(
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      estado: estado ?? this.estado,
    );
  }
}
