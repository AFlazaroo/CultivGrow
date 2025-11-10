import 'package:flutter/foundation.dart';
import '../models/cultivo.dart';
import '../services/database_service.dart';

class CultivoController with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Cultivo> _cultivos = [];
  Cultivo? _cultivoSeleccionado;
  bool _isLoading = false;
  String? _error;

  List<Cultivo> get cultivos => _cultivos;
  Cultivo? get cultivoSeleccionado => _cultivoSeleccionado;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCultivos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cultivos = await _databaseService.getAllCultivos();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar cultivos: $e';
      _cultivos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCultivosByCategoria(int categoriaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cultivos = await _databaseService.getCultivosByCategoria(categoriaId);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar cultivos: $e';
      _cultivos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCultivoById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cultivoSeleccionado = await _databaseService.getCultivoById(id);
      _error = null;
    } catch (e) {
      _error = 'Error al cargar cultivo: $e';
      _cultivoSeleccionado = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCultivoSeleccionado(Cultivo? cultivo) {
    _cultivoSeleccionado = cultivo;
    notifyListeners();
  }
}

