import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/cardlist.dart';

const String tableTodo = "todos";
const String columnId = "_id";
const String columnTitle = "_title";
const String columnDescription = "_description";
const String columnDone = "_done";

class DatabaseHelper {
  static final _databaseName = "todo_database.db";
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableTodo (
                $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnTitle TEXT NOT NULL,
                $columnDescription INTEGER NOT NULL,
                $columnDone INTEGER NOT NULL
              )
              '''); // in SQLite Boolean values are stored as integers 0(false) 1(true)
  }

  // Database helper methods:

  Future<int> insert(TodoTask task) async {
    final db = await database;
    int id = await db.insert(tableTodo, task.toMap());
    return id;
  }

  Future<TodoTask> queryWord(int id) async {
    final db = await database;
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnTitle, columnDescription, columnDone],
        where: '$columnId = ?',
        whereArgs: [id]
    );
    if (maps.length > 0) {
      return TodoTask.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteTodoFromDb(int id) async {
    final db = await database;
    await db.delete(
        tableTodo,
        where: '$columnId = ?',
        whereArgs: [id]
    );
  }

  Future<void> updateTodo(TodoTask task) async {
    final db = await database;
    await db.update(
      tableTodo,
      task.toMap(),
      where: "$columnId = ?",
      whereArgs: [task.id],
    );
  }
}