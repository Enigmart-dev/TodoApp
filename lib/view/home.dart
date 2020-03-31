import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/cardlist.dart';
import 'package:todo_app/view/add_todo_view.dart';

class TodoHome extends StatelessWidget {
  final String title;

  TodoHome({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: TodoList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
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

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardList>(builder: (context, cardlist, _) {
      return FutureBuilder<bool>(
        future: Future.delayed(
            Duration(seconds: 1), () => cardlist.initTodoListFromDb()),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return cardlist.todoList.length > 0
                ? ListView.builder(
                    itemCount: cardlist.todoList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
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
                                            Text(
                                              cardlist.todoList[index].title +
                                                  " id: ${cardlist.todoList[index].id}, index: $index",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          cardlist.todoList[index]?.description,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: MoreButton(index: index),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ));
                    })
                : Center(
                    child: Text("No Todo inserted yet"),
                  );
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

class MoreButton extends StatefulWidget {
  final int index;

  MoreButton({Key key, this.index}) : super(key: key);

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
                  final model = Provider.of<CardList>(context, listen: false);
                  model.deleteTodo(widget.index);
                  print("Index deleted: ${widget.index}");
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
