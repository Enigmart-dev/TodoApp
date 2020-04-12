import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/moor_database.dart';

class AddTodoView extends StatefulWidget {

  //if it's not null, it means it's modifying an already existing task
  Task task;

  TextEditingController textController;
  TextEditingController descriptionController;

  AddTodoView({
    Key key,
    this.task,
    this.textController,
    this.descriptionController
  }) : super(key: key);

  @override
  _AddTodoViewState createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {

  @override
  void initState() {
    super.initState();
    if(widget.textController == null) widget.textController = TextEditingController();
    if(widget.descriptionController == null) widget.descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a new Todo"),
        ),
        resizeToAvoidBottomPadding: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Enter a title'),
                    controller: widget.textController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a description'),
                    maxLines: null,
                    controller: widget.descriptionController,
                  ),
                ],
              ),
            ),
            BottomButtons(
              task: widget.task == null ? null : widget.task,
              textController: widget.textController,
              descriptionController: widget.descriptionController,
            ),
          ],
        ));
  }
}

class BottomButtons extends StatelessWidget {

  final Task task;
  final TextEditingController textController;
  final TextEditingController descriptionController;

  const BottomButtons({
    Key key,
    this.textController,
    this.descriptionController,
    this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 28.0, right: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x000000).withOpacity(.3),
                          offset: Offset(0.0, 8.0),
                          blurRadius: 8.0)
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      textController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text("Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: .7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x000000).withOpacity(.3),
                          offset: Offset(0.0, 8.0),
                          blurRadius: 8.0)
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final tasks =
                      Provider.of<AppDatabase>(context, listen: false);


                      if(task == null) {
                        tasks.insertTask(Task(
                          title: textController.text,
                          description: descriptionController.text,
                          completed: false,
                        ));
                      } else {
                        tasks.updateTask(Task(
                          id: task.id,
                          title: textController?.text,
                          description: descriptionController?.text,
                          completed: task.completed
                        ));
                      }

                      textController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text("Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: .7)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
