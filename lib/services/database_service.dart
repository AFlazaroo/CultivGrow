import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/categoria.dart';
import '../models/cultivo.dart';
import '../models/cultivo_gestionado.dart';
import '../models/tarea_programada.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cultivos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de categorías
    await db.execute('''
      CREATE TABLE categorias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        icono TEXT NOT NULL
      )
    ''');

    // Tabla de cultivos
    await db.execute('''
      CREATE TABLE cultivos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        imagen TEXT,
        temporada TEXT NOT NULL,
        dias_cosecha INTEGER NOT NULL,
        clima TEXT NOT NULL,
        suelo TEXT NOT NULL,
        riego TEXT NOT NULL,
        cuidados TEXT NOT NULL,
        plagas TEXT NOT NULL,
        fertilizacion TEXT NOT NULL,
        FOREIGN KEY (categoria_id) REFERENCES categorias (id)
      )
    ''');

    // Tabla de cultivos gestionados
    await db.execute('''
      CREATE TABLE cultivos_gestionados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cultivo_id INTEGER NOT NULL,
        nombre_personalizado TEXT,
        fecha_siembra TEXT NOT NULL,
        ubicacion TEXT,
        notas TEXT,
        FOREIGN KEY (cultivo_id) REFERENCES cultivos (id)
      )
    ''');

    // Tabla de tareas programadas
    await db.execute('''
      CREATE TABLE tareas_programadas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cultivo_gestionado_id INTEGER NOT NULL,
        tipo_tarea TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        intervalo_horas INTEGER NOT NULL,
        fecha_inicio TEXT NOT NULL,
        ultima_ejecucion TEXT,
        proxima_ejecucion TEXT,
        activa INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (cultivo_gestionado_id) REFERENCES cultivos_gestionados (id)
      )
    ''');

    // Insertar datos iniciales
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insertar categorías
    final categorias = [
      Categoria(
        nombre: 'Hortalizas',
        descripcion: 'Verduras y hortalizas de consumo común',
        icono: '🥬',
      ),
      Categoria(
        nombre: 'Tubérculos',
        descripcion: 'Raíces y tubérculos comestibles',
        icono: '🥔',
      ),
      Categoria(
        nombre: 'Frutas',
        descripcion: 'Frutales y árboles frutales',
        icono: '🍎',
      ),
      Categoria(
        nombre: 'Hierbas',
        descripcion: 'Hierbas aromáticas y medicinales',
        icono: '🌿',
      ),
    ];

    for (var categoria in categorias) {
      await db.insert('categorias', categoria.toMap());
    }

    // Insertar algunos cultivos de ejemplo
    final cultivos = [
      Cultivo(
        categoriaId: 1, // Hortalizas
        nombre: 'Tomate',
        descripcion: 'Planta de tomate, fruto muy popular en la cocina',
        temporada: 'Primavera - Verano',
        diasCosecha: 90,
        clima: 'Templado, entre 18-25°C',
        suelo: 'Suelo bien drenado, rico en materia orgánica',
        riego: 'Riego moderado, evitar encharcamiento',
        cuidados: 'Tutorado necesario, poda de brotes laterales',
        plagas: 'Mosca blanca, araña roja, pulgones',
        fertilizacion: 'Fertilizante rico en potasio cada 15 días',
      ),
      Cultivo(
        categoriaId: 1, // Hortalizas
        nombre: 'Lechuga',
        descripcion: 'Hoja verde muy utilizada en ensaladas',
        temporada: 'Todo el año',
        diasCosecha: 60,
        clima: 'Fresco, entre 15-20°C',
        suelo: 'Suelo húmedo y rico en nitrógeno',
        riego: 'Riego frecuente pero moderado',
        cuidados: 'Proteger del sol intenso, cosechar hojas externas',
        plagas: 'Caracoles, babosas, pulgones',
        fertilizacion: 'Abono orgánico al inicio del cultivo',
      ),
      Cultivo(
        categoriaId: 2, // Tubérculos
        nombre: 'Papa',
        descripcion: 'Tubérculo básico en la alimentación',
        temporada: 'Primavera - Otoño',
        diasCosecha: 120,
        clima: 'Templado-frío, entre 12-20°C',
        suelo: 'Suelo suelto y bien drenado',
        riego: 'Riego regular, más frecuente en floración',
        cuidados: 'Aporcar las plantas, controlar malezas',
        plagas: 'Gusano de alambre, pulgón, escarabajo de la papa',
        fertilizacion: 'Fertilizante rico en fósforo y potasio',
      ),
      Cultivo(
        categoriaId: 2, // Tubérculos
        nombre: 'Zanahoria',
        descripcion: 'Raíz anaranjada rica en vitamina A',
        temporada: 'Otoño - Invierno',
        diasCosecha: 90,
        clima: 'Templado, entre 15-20°C',
        suelo: 'Suelo suelto, sin piedras, profundo',
        riego: 'Riego constante pero moderado',
        cuidados: 'Raleo de plántulas, evitar suelo compactado',
        plagas: 'Mosca de la zanahoria, nematodos',
        fertilizacion: 'Fertilizante bajo en nitrógeno',
      ),
    ];

    for (var cultivo in cultivos) {
      await db.insert('cultivos', cultivo.toMap());
    }
  }

  // Métodos para Categorías
  Future<List<Categoria>> getAllCategorias() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categorias');
    return List.generate(maps.length, (i) => Categoria.fromMap(maps[i]));
  }

  Future<Categoria?> getCategoriaById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categorias',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Categoria.fromMap(maps.first);
  }

  // Métodos para Cultivos
  Future<List<Cultivo>> getAllCultivos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cultivos');
    return List.generate(maps.length, (i) => Cultivo.fromMap(maps[i]));
  }

  Future<List<Cultivo>> getCultivosByCategoria(int categoriaId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cultivos',
      where: 'categoria_id = ?',
      whereArgs: [categoriaId],
    );
    return List.generate(maps.length, (i) => Cultivo.fromMap(maps[i]));
  }

  Future<Cultivo?> getCultivoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cultivos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Cultivo.fromMap(maps.first);
  }

  // Métodos para Cultivos Gestionados
  Future<int> insertCultivoGestionado(CultivoGestionado cultivo) async {
    final db = await database;
    return await db.insert('cultivos_gestionados', cultivo.toMap());
  }

  Future<List<CultivoGestionado>> getAllCultivosGestionados() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cultivos_gestionados');
    final List<CultivoGestionado> cultivos = [];
    
    for (var map in maps) {
      final cultivoId = map['cultivo_id'] as int;
      final cultivo = await getCultivoById(cultivoId);
      cultivos.add(CultivoGestionado.fromMap(map, cultivo: cultivo));
    }
    
    return cultivos;
  }

  Future<CultivoGestionado?> getCultivoGestionadoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cultivos_gestionados',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    final map = maps.first;
    final cultivoId = map['cultivo_id'] as int;
    final cultivo = await getCultivoById(cultivoId);
    return CultivoGestionado.fromMap(map, cultivo: cultivo);
  }

  Future<int> updateCultivoGestionado(CultivoGestionado cultivo) async {
    final db = await database;
    return await db.update(
      'cultivos_gestionados',
      cultivo.toMap(),
      where: 'id = ?',
      whereArgs: [cultivo.id],
    );
  }

  Future<int> deleteCultivoGestionado(int id) async {
    final db = await database;
    // Eliminar tareas asociadas primero
    await db.delete(
      'tareas_programadas',
      where: 'cultivo_gestionado_id = ?',
      whereArgs: [id],
    );
    return await db.delete(
      'cultivos_gestionados',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para Tareas Programadas
  Future<int> insertTareaProgramada(TareaProgramada tarea) async {
    final db = await database;
    return await db.insert('tareas_programadas', tarea.toMap());
  }

  Future<List<TareaProgramada>> getTareasByCultivoGestionado(int cultivoGestionadoId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tareas_programadas',
      where: 'cultivo_gestionado_id = ?',
      whereArgs: [cultivoGestionadoId],
    );
    return List.generate(maps.length, (i) => TareaProgramada.fromMap(maps[i]));
  }

  Future<List<TareaProgramada>> getAllTareasActivas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tareas_programadas',
      where: 'activa = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => TareaProgramada.fromMap(maps[i]));
  }

  Future<int> updateTareaProgramada(TareaProgramada tarea) async {
    final db = await database;
    return await db.update(
      'tareas_programadas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  Future<int> deleteTareaProgramada(int id) async {
    final db = await database;
    return await db.delete(
      'tareas_programadas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

