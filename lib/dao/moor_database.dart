import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(
      min: 1,
      max: 20,
  )();
  TextColumn get description => text().withLength(
    min: 1,
    max: 40
  )();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(
    path: 'db.sqlite',
    logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  Future insertTask(Task task) => into(tasks).insert(task);
  Future updateTask(Task task) => update(tasks).replace(task);
  Future deleteTask(Task task) => delete(tasks).delete(task);
}