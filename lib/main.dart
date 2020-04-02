import 'package:flutter/material.dart';
import 'package:todo_app/database/moor_database.dart';
import 'package:todo_app/view/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primaryColor: Colors.blue[900],
          accentColor: Colors.blueAccent,
          brightness: Brightness.dark,
          fontFamily: 'HindSiliguri',
        ),
        home: TodoHome(title: 'Todo Application')
        ),
    );
  }
}


