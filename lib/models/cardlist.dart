import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/utils/database_helper.dart';

class CardList with ChangeNotifier {
  List<TodoTask> todoList = [];

  Future<bool> initTodoListFromDb() async {
    Database db = await DatabaseHelper.instance.database;
    int countNonNull = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT() FROM $tableTodo'));

    print("initTodoList.count == $countNonNull");
    print("todoList.isEmpty == ${todoList.isEmpty}");
    print("todoList elements : $todoList");
    if(countNonNull != null && countNonNull > 0 && todoList.isEmpty) {
      List<Map<String, dynamic>> list = await db.query(tableTodo);
      todoList = new List<TodoTask>.from(
        List.generate(list.length, (i) {
          return TodoTask.fromMap(list[i]);
        })
      );
      return true;
    }
    return false;
  }

  void addTodo(TodoTask task) async{
    todoList.add(task);
    DatabaseHelper db = DatabaseHelper.instance;
    db.insert(task);
    notifyListeners();
  }

  void deleteTodo(int index) async {
    todoList.removeAt(index);
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteTodoFromDb(todoList[index].id);
    notifyListeners();
  }
}

class TodoTask {
  int _id;
  String _title;
  String _description;
  bool _done;

  TodoTask(this._id, this._title, this._description, this._done);

  TodoTask.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    _title = map[columnTitle];
    _description = map[columnDescription];
    _done = (map[columnDone] == 1) ? true : false;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnTitle : _title,
      columnDescription : _description,
      columnDone : _done
    };
    if(_id != null) {
      map[columnId] = _id;
    }
    return map;
  }

  set done(bool value) {
    _done = value;
  }

  int get id => _id;

  String get description => _description;

  String get title => _title;

}