import 'package:flutter/foundation.dart';
import '../models/tarea_programada.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class TimerController with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  List<TareaProgramada> _tareas = [];
  List<TareaProgramada> _tareasPendientes = [];
  bool _isLoading = false;
  String? _error;

  List<TareaProgramada> get tareas => _tareas;
  List<TareaProgramada> get tareasPendientes => _tareasPendientes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTareasByCultivo(int cultivoGestionadoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tareas = await _databaseService.getTareasByCultivoGestionado(cultivoGestionadoId);
      _updateTareasPendientes();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar tareas: $e';
      _tareas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllTareasActivas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tareas = await _databaseService.getAllTareasActivas();
      _updateTareasPendientes();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar tareas: $e';
      _tareas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateTareasPendientes() {
    final ahora = DateTime.now();
    _tareasPendientes = _tareas.where((tarea) {
      if (!tarea.activa) return false;
      if (tarea.proximaEjecucion == null) return true;
      return tarea.proximaEjecucion!.isBefore(ahora) || 
             tarea.proximaEjecucion!.isAtSameMomentAs(ahora);
    }).toList();
  }

  Future<bool> addTarea(TareaProgramada tarea, String cultivoNombre) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Calcular próxima ejecución
      final proximaEjecucion = tarea.fechaInicio.add(Duration(hours: tarea.intervaloHoras));
      final tareaConFecha = tarea.copyWith(proximaEjecucion: proximaEjecucion);

      final id = await _databaseService.insertTareaProgramada(tareaConFecha);
      final tareaCreada = tareaConFecha.copyWith(id: id);

      // Programar notificación
      await _notificationService.scheduleTaskNotification(
        tareaCreada,
        cultivoNombre,
      );

      await loadTareasByCultivo(tarea.cultivoGestionadoId);
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error al agregar tarea: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTarea(TareaProgramada tarea, String cultivoNombre) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.updateTareaProgramada(tarea);
      await _notificationService.updateTaskNotification(tarea, cultivoNombre);
      await loadTareasByCultivo(tarea.cultivoGestionadoId);
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error al actualizar tarea: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTarea(int id, int cultivoGestionadoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteTareaProgramada(id);
      await _notificationService.cancelTaskNotification(id);
      await loadTareasByCultivo(cultivoGestionadoId);
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error al eliminar tarea: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> marcarTareaCompletada(TareaProgramada tarea, String cultivoNombre) async {
    final ahora = DateTime.now();
    final proximaEjecucion = ahora.add(Duration(hours: tarea.intervaloHoras));

    final tareaActualizada = tarea.copyWith(
      ultimaEjecucion: ahora,
      proximaEjecucion: proximaEjecucion,
    );

    return await updateTarea(tareaActualizada, cultivoNombre);
  }

  Future<void> calcularProximasEjecuciones() async {
    final ahora = DateTime.now();
    for (var tarea in _tareas) {
      if (!tarea.activa) continue;
      
      if (tarea.proximaEjecucion == null || 
          tarea.proximaEjecucion!.isBefore(ahora)) {
        // Calcular nueva próxima ejecución basada en la última ejecución o fecha de inicio
        final fechaBase = tarea.ultimaEjecucion ?? tarea.fechaInicio;
        var proximaEjecucion = fechaBase.add(Duration(hours: tarea.intervaloHoras));
        
        // Si ya pasó, calcular la siguiente basada en el intervalo
        while (proximaEjecucion.isBefore(ahora)) {
          proximaEjecucion = proximaEjecucion.add(Duration(hours: tarea.intervaloHoras));
        }

        final tareaActualizada = tarea.copyWith(proximaEjecucion: proximaEjecucion);
        await _databaseService.updateTareaProgramada(tareaActualizada);
      }
    }
    notifyListeners();
  }
}

