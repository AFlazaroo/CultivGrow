class Categoria {
  final int? id;
  final String nombre;
  final String descripcion;
  final String icono;

  Categoria({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      icono: map['icono'] as String,
    );
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? icono,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
    );
  }
}

