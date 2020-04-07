import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/moor_database.dart';
import 'package:todo_app/view/add_todo_view.dart';
import 'package:todo_app/widgets/more_button.dart';

class TodoHome extends StatelessWidget {
  final String title;

  TodoHome({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        child: TodoList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoView()),
          );
        },
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDatabase>(builder: (context, db, _) {
      return StreamBuilder<List<Task>>(
        stream: db.watchAllTasks(),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          final tasks = snapshot.data;

          if (snapshot.hasData) {
            return tasks.length > 0
                ? ReorderableListView(
                scrollDirection: Axis.vertical,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final Task item = tasks.removeAt(oldIndex);
                    tasks.insert(newIndex, item);
                  });
                },
                padding: EdgeInsets.only(top: 10, bottom: 10),
                children: List.generate(tasks.length, (index) {
                  return TaskItem(
                    index: index,
                    tasks: tasks,
                    key: Key('$index'),
                  );
                }))
                : Center(child: Text("No todos inserted yet"));
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              );
            }
          }
        },
      );
    });
  }
}

class TaskItem extends StatefulWidget {

  final int index;
  final Key key;
  final List<Task> tasks;

  TaskItem({
    this.index,
    this.tasks,
    this.key
  });

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: <Widget>[
            Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              child: Image.asset(
                                'res/images/dot.png',
                                height: 7,
                                width: 7,
                              )),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              widget.tasks[widget.index].title,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: widget.tasks[widget.index].completed
                                      ?
                                  TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationThickness: 2.5,
                                  decorationColor: Colors.black
                              ),
                            ),
                          ),
                          SizedBox(width: 140),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.tasks[widget.index]?.description,
                        style: TextStyle(
                            fontSize: 16,
                            decoration: widget.tasks[widget.index].completed
                                ?
                            TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 2.5,
                            decorationColor: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: MoreButton(task: widget.tasks[widget.index]),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
          ],
        ));
  }
}

