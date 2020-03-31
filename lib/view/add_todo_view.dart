import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/cardlist.dart';

final _textController = TextEditingController();
final _descriptionController = TextEditingController();

class AddTodoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a new Todo"),
        ),
        resizeToAvoidBottomPadding: true,
        body: Consumer<CardList>(builder: (context, cardlist, _) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a title'
                      ),
                      controller: _textController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a description'
                      ),
                      maxLines: null,
                      controller: _descriptionController,
                    ),
                  ],
                ),
              ),
              BottomButtons(cardlist: cardlist),
            ],
          );
        }
        )
    );
  }
}

class BottomButtons extends StatelessWidget {
  final CardList cardlist;
  BottomButtons({Key key, @required this.cardlist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 18.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
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
                      TodoTask newTask = TodoTask(
                          cardlist.todoList.length,
                          _textController.text,
                          _descriptionController.text,
                          false,
                      );
                      cardlist.addTodo(newTask);
                      _textController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: .7)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            InkWell(
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
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
                      _textController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: .7)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
