import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: library_prefixes
import 'dart:io' as ioInstance;

import 'package:todo_app/models/task.dart';

class DBHelper {
  static Database? db;

  Future<Database?> get database async {
    if (db != null) {
      return db!;
    }
    db = await initializeDatabase();
    return db!;
  }

  initializeDatabase() async {
    ioInstance.Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}todo.db';
    var todoDatabase = await openDatabase(path, version: 1, onCreate: createDb);
    return todoDatabase;
  }

  createDb(Database todoDB, int version) async {
    await todoDB.execute(
      "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT, date TEXT NOT NULL, time TEXT NOT NULL, status INTEGER )",
    );
  }

// Fetch Operation: Get all task objects from database
  Future<List<Task>> getTasks() async {
    Database? db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM tasks",
    );
    return rawQueryResult.map((e) => Task.fromMap(e)).toList();
  }

  // Future<List<Task>> getTasks() async {
  //   Database? db = await database;
  //   if (db == null) {
  //     // handle the error, e.g. throw an exception or return an empty list
  //     return [];
  //   }
  //   final List<Map<String, Object?>> queryResult = await db.query('tasks');
  //   return queryResult.map((e) => Task.fromMap(e)).toList();
  // }

  Future<Task> insert(Task task) async {
    Database? db = await database;
    await db!.insert('tasks', task.toMap());
    return task;
  }

  Future<int> update(Task task) async {
    Database? db = await database;
    return await db!.update(
      'tasks',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    Database? db = await database;
    return await db!.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}