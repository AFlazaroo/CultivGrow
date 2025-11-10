enum TipoTarea {
  riego,
  fertilizacion,
  pesticida,
  poda,
  cosecha,
  otros,
}

extension TipoTareaExtension on TipoTarea {
  String get nombre {
    switch (this) {
      case TipoTarea.riego:
        return 'Riego';
      case TipoTarea.fertilizacion:
        return 'Fertilización';
      case TipoTarea.pesticida:
        return 'Pesticida';
      case TipoTarea.poda:
        return 'Poda';
      case TipoTarea.cosecha:
        return 'Cosecha';
      case TipoTarea.otros:
        return 'Otros';
    }
  }

  String get icono {
    switch (this) {
      case TipoTarea.riego:
        return '💧';
      case TipoTarea.fertilizacion:
        return '🌱';
      case TipoTarea.pesticida:
        return '🧪';
      case TipoTarea.poda:
        return '✂️';
      case TipoTarea.cosecha:
        return '🌾';
      case TipoTarea.otros:
        return '📋';
    }
  }

}

TipoTarea tipoTareaFromString(String value) {
  // El valor viene como "TipoTarea.riego" desde la base de datos
  final enumName = value.split('.').last;
  return TipoTarea.values.firstWhere(
    (e) => e.toString().split('.').last == enumName,
    orElse: () => TipoTarea.otros,
  );
}

