import 'package:flutter/foundation.dart';
import '../models/categoria.dart';
import '../services/database_service.dart';

class CategoryController with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  String? _error;

  List<Categoria> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategorias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categorias = await _databaseService.getAllCategorias();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar categorías: $e';
      _categorias = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Categoria?> getCategoriaById(int id) async {
    try {
      return await _databaseService.getCategoriaById(id);
    } catch (e) {
      _error = 'Error al obtener categoría: $e';
      notifyListeners();
      return null;
    }
  }
}

