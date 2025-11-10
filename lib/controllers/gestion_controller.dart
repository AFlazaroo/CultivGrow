import 'package:flutter/foundation.dart';
import '../models/cultivo_gestionado.dart';
import '../services/database_service.dart';

class GestionController with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<CultivoGestionado> _cultivosGestionados = [];
  CultivoGestionado? _cultivoGestionadoSeleccionado;
  bool _isLoading = false;
  String? _error;

  List<CultivoGestionado> get cultivosGestionados => _cultivosGestionados;
  CultivoGestionado? get cultivoGestionadoSeleccionado => _cultivoGestionadoSeleccionado;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCultivosGestionados() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cultivosGestionados = await _databaseService.getAllCultivosGestionados();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar cultivos gestionados: $e';
      _cultivosGestionados = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCultivoGestionado(CultivoGestionado cultivo) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.insertCultivoGestionado(cultivo);
      await loadCultivosGestionados();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error al agregar cultivo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCultivoGestionado(CultivoGestionado cultivo) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.updateCultivoGestionado(cultivo);
      await loadCultivosGestionados();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error al actualizar cultivo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCultivoGestionado(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteCultivoGestionado(id);
      await loadCultivosGestionados();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error al eliminar cultivo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadCultivoGestionadoById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cultivoGestionadoSeleccionado = await _databaseService.getCultivoGestionadoById(id);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar cultivo gestionado: $e';
      _cultivoGestionadoSeleccionado = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCultivoGestionadoSeleccionado(CultivoGestionado? cultivo) {
    _cultivoGestionadoSeleccionado = cultivo;
    notifyListeners();
  }
}

