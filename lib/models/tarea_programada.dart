import 'tipo_tarea.dart';

class TareaProgramada {
  final int? id;
  final int cultivoGestionadoId;
  final TipoTarea tipoTarea;
  final String descripcion;
  final int intervaloHoras;
  final DateTime fechaInicio;
  final DateTime? ultimaEjecucion;
  final DateTime? proximaEjecucion;
  final bool activa;

  TareaProgramada({
    this.id,
    required this.cultivoGestionadoId,
    required this.tipoTarea,
    required this.descripcion,
    required this.intervaloHoras,
    required this.fechaInicio,
    this.ultimaEjecucion,
    this.proximaEjecucion,
    this.activa = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cultivo_gestionado_id': cultivoGestionadoId,
      'tipo_tarea': tipoTarea.toString(),
      'descripcion': descripcion,
      'intervalo_horas': intervaloHoras,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'ultima_ejecucion': ultimaEjecucion?.toIso8601String(),
      'proxima_ejecucion': proximaEjecucion?.toIso8601String(),
      'activa': activa ? 1 : 0,
    };
  }

  factory TareaProgramada.fromMap(Map<String, dynamic> map) {
    return TareaProgramada(
      id: map['id'] as int?,
      cultivoGestionadoId: map['cultivo_gestionado_id'] as int,
      tipoTarea: tipoTareaFromString(map['tipo_tarea'] as String),
      descripcion: map['descripcion'] as String,
      intervaloHoras: map['intervalo_horas'] as int,
      fechaInicio: DateTime.parse(map['fecha_inicio'] as String),
      ultimaEjecucion: map['ultima_ejecucion'] != null
          ? DateTime.parse(map['ultima_ejecucion'] as String)
          : null,
      proximaEjecucion: map['proxima_ejecucion'] != null
          ? DateTime.parse(map['proxima_ejecucion'] as String)
          : null,
      activa: (map['activa'] as int) == 1,
    );
  }

  TareaProgramada copyWith({
    int? id,
    int? cultivoGestionadoId,
    TipoTarea? tipoTarea,
    String? descripcion,
    int? intervaloHoras,
    DateTime? fechaInicio,
    DateTime? ultimaEjecucion,
    DateTime? proximaEjecucion,
    bool? activa,
  }) {
    return TareaProgramada(
      id: id ?? this.id,
      cultivoGestionadoId: cultivoGestionadoId ?? this.cultivoGestionadoId,
      tipoTarea: tipoTarea ?? this.tipoTarea,
      descripcion: descripcion ?? this.descripcion,
      intervaloHoras: intervaloHoras ?? this.intervaloHoras,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      ultimaEjecucion: ultimaEjecucion ?? this.ultimaEjecucion,
      proximaEjecucion: proximaEjecucion ?? this.proximaEjecucion,
      activa: activa ?? this.activa,
    );
  }
}

