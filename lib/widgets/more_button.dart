import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/moor_database.dart';
import 'package:todo_app/view/add_todo_view.dart';

class MoreButton extends StatefulWidget {
  final Task task;

  MoreButton({Key key, this.task}) : super(key: key);

  @override
  _MoreButtonState createState() => _MoreButtonState();
}

class _MoreButtonState extends State<MoreButton> {
  bool isTouched = false;

  @override
  Widget build(BuildContext context) {
    return isTouched
        ? Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.delete, size: 22),
          onPressed: () {
            final database = Provider.of<AppDatabase>(context, listen: false);
            database.deleteTask(widget.task);
            setState(() {
              isTouched = !isTouched;
            });
          },
        ),
        IconButton(
          icon: widget.task.completed ? Icon(Icons.close, size: 22) : Icon(Icons.check, size: 22),
          onPressed: () {
            final database = Provider.of<AppDatabase>(context, listen: false);
            widget.task.completed = !widget.task.completed; 
            database.updateTask(widget.task);
            setState(() {
              isTouched = !isTouched;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            final database = Provider.of<AppDatabase>(context, listen: false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTodoView(
                task: widget.task,
                textController: TextEditingController(
                  text: widget.task.title,
                ),
                descriptionController: TextEditingController(
                  text: widget.task.description,
                ),
              )),
            );
            database.updateTask(widget.task);
            setState(() {
              isTouched = !isTouched;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_drop_down, size: 22),
          onPressed: (){
            setState(() {
              isTouched = !isTouched;
            });
          },
        )
      ],
    )
        : IconButton(
        iconSize: 25,
        icon: Icon(Icons.more_vert, size: 22),
        onPressed: () {
          setState(() {
            isTouched = !isTouched;
          });
        });
  }
}