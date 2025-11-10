class Cultivo {
  final int? id;
  final int categoriaId;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String temporada;
  final int diasCosecha;
  final String clima;
  final String suelo;
  final String riego;
  final String cuidados;
  final String plagas;
  final String fertilizacion;

  Cultivo({
    this.id,
    required this.categoriaId,
    required this.nombre,
    required this.descripcion,
    this.imagen = '',
    required this.temporada,
    required this.diasCosecha,
    required this.clima,
    required this.suelo,
    required this.riego,
    required this.cuidados,
    required this.plagas,
    required this.fertilizacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria_id': categoriaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'temporada': temporada,
      'dias_cosecha': diasCosecha,
      'clima': clima,
      'suelo': suelo,
      'riego': riego,
      'cuidados': cuidados,
      'plagas': plagas,
      'fertilizacion': fertilizacion,
    };
  }

  factory Cultivo.fromMap(Map<String, dynamic> map) {
    return Cultivo(
      id: map['id'] as int?,
      categoriaId: map['categoria_id'] as int,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      imagen: map['imagen'] as String? ?? '',
      temporada: map['temporada'] as String,
      diasCosecha: map['dias_cosecha'] as int,
      clima: map['clima'] as String,
      suelo: map['suelo'] as String,
      riego: map['riego'] as String,
      cuidados: map['cuidados'] as String,
      plagas: map['plagas'] as String,
      fertilizacion: map['fertilizacion'] as String,
    );
  }

  Cultivo copyWith({
    int? id,
    int? categoriaId,
    String? nombre,
    String? descripcion,
    String? imagen,
    String? temporada,
    int? diasCosecha,
    String? clima,
    String? suelo,
    String? riego,
    String? cuidados,
    String? plagas,
    String? fertilizacion,
  }) {
    return Cultivo(
      id: id ?? this.id,
      categoriaId: categoriaId ?? this.categoriaId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      temporada: temporada ?? this.temporada,
      diasCosecha: diasCosecha ?? this.diasCosecha,
      clima: clima ?? this.clima,
      suelo: suelo ?? this.suelo,
      riego: riego ?? this.riego,
      cuidados: cuidados ?? this.cuidados,
      plagas: plagas ?? this.plagas,
      fertilizacion: fertilizacion ?? this.fertilizacion,
    );
  }
}

