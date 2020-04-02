import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/moor_database.dart';

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
      children: <Widget>[
        IconButton(
          iconSize: 22,
          icon: Icon(Icons.delete),
          onPressed: () {
            final database = Provider.of<AppDatabase>(context, listen: false);
            database.deleteTask(widget.task);
            setState(() {
              isTouched = !isTouched;
            });
          },
        ),
        IconButton(
          iconSize: 22,
          icon: Icon(Icons.edit),
          onPressed: () {
            isTouched = !isTouched;
          },
        )
      ],
    )
        : IconButton(
        iconSize: 25,
        icon: Icon(Icons.more_vert),
        onPressed: () {
          setState(() {
            isTouched = !isTouched;
          });
        });
  }
}