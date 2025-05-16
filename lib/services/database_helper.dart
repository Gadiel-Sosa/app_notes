import 'package:app_notes/models/notes_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//* Clase que maneja toda la lógica de la base de datos
class DatabaseHelper {
  //* Creamos una instancia única (singleton) de DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  //* Referencia privada a la base de datos (se inicializa cuando se accede)
  static Database? _database;
  //* Constructor que devuelve siempre la misma instancia

  factory DatabaseHelper() => _instance;
  //* Constructor interno privado para evitar múltiples instancias
  DatabaseHelper._internal();
  //* Getter que retorna la base de datos, y la inicializa si aún no existe

  Future<Database> get database async {
    if (_database != null) return _database!;
    //* Si no existe la base de datos, la inicializamos
    _database = await _initDatabase();
    return _database!;
  }
  //* Método para inicializar la base de datos

  Future<Database> _initDatabase() async {
    //* Obtenemos la ruta del dispositivo y le añadimos el nombre del archivo
    String path = join(await getDatabasesPath(), 'my_notes.db');
    //* Abrimos o creamos la base de datos en esa ruta
    //* Si es nueva, se ejecuta la función _onCreate
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }
  //* Método que se ejecuta la primera vez que se crea la base de datos

  Future<void> _onCreate(Database db, int version) async {
    //* Ejecutamos una sentencia SQL para crear la tabla 'notes'
    await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT, //* ID único de cada nota
          title TEXT, //* Título de la nota
          content TEXT, //* Contenido de la nota
          color TEXT,  //* Color guardado como texto
          dateTime TEXT //* Fecha y hora como texto
          )
        
        ''');
  }
  //* Método para insertar una nueva nota en la base de datos

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(
      'notes',
      note.toMap(),
    ); //* Convierte la nota a un mapa y la guarda
  }
  //* Método para obtener todas las notas de la base de datos

  Future<List<Note>> getNotes() async {
    final db = await database;
    //* Consultamos todas las filas de la tabla 'notes'
    final List<Map<String, dynamic>> maps = await db.query('notes');
    //* Convertimos cada mapa (fila) en un objeto Note
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }
  //* Método para actualizar una nota existente

  Future<int> updateNote(Note note) async {
    final db = await database;
    //* Actualizamos la nota donde el id coincida
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
  //* Método para eliminar una nota según su id

  Future<int> deleteNote(int id) async {
    //* Eliminamos la fila cuyo id coincida
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
