import 'cultivo.dart';

class CultivoGestionado {
  final int? id;
  final int cultivoId;
  final String nombrePersonalizado;
  final DateTime fechaSiembra;
  final String ubicacion;
  final String notas;
  final Cultivo? cultivo;

  CultivoGestionado({
    this.id,
    required this.cultivoId,
    this.nombrePersonalizado = '',
    required this.fechaSiembra,
    this.ubicacion = '',
    this.notas = '',
    this.cultivo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cultivo_id': cultivoId,
      'nombre_personalizado': nombrePersonalizado,
      'fecha_siembra': fechaSiembra.toIso8601String(),
      'ubicacion': ubicacion,
      'notas': notas,
    };
  }

  factory CultivoGestionado.fromMap(Map<String, dynamic> map, {Cultivo? cultivo}) {
    return CultivoGestionado(
      id: map['id'] as int?,
      cultivoId: map['cultivo_id'] as int,
      nombrePersonalizado: map['nombre_personalizado'] as String? ?? '',
      fechaSiembra: DateTime.parse(map['fecha_siembra'] as String),
      ubicacion: map['ubicacion'] as String? ?? '',
      notas: map['notas'] as String? ?? '',
      cultivo: cultivo,
    );
  }

  CultivoGestionado copyWith({
    int? id,
    int? cultivoId,
    String? nombrePersonalizado,
    DateTime? fechaSiembra,
    String? ubicacion,
    String? notas,
    Cultivo? cultivo,
  }) {
    return CultivoGestionado(
      id: id ?? this.id,
      cultivoId: cultivoId ?? this.cultivoId,
      nombrePersonalizado: nombrePersonalizado ?? this.nombrePersonalizado,
      fechaSiembra: fechaSiembra ?? this.fechaSiembra,
      ubicacion: ubicacion ?? this.ubicacion,
      notas: notas ?? this.notas,
      cultivo: cultivo ?? this.cultivo,
    );
  }

  DateTime get fechaCosechaEstimada {
    if (cultivo != null) {
      return fechaSiembra.add(Duration(days: cultivo!.diasCosecha));
    }
    return fechaSiembra;
  }

  int get diasRestantes {
    final ahora = DateTime.now();
    final diferencia = fechaCosechaEstimada.difference(ahora);
    return diferencia.inDays;
  }
}

