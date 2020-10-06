import 'package:flutter/material.dart';
import 'package:goal_tracker/question.dart';
import 'habbit.dart';

class Controller with ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class TodoListPage extends StatelessWidget {
  final Habbit habbit;
  const TodoListPage({Key key, this.habbit, this.habbitController})
      : super(key: key);
  final HabbitController habbitController;
  @override
  Widget build(BuildContext context) {
    final Controller con = new Controller();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Todo t = new Todo();

            showDialog(
                context: context,
                builder: (BuildContext c) {
                  return NewTodoPage(
                    person: t,
                    onReady: () {
                      habbit.addTodo(t);

                      habbitController.save();
                      con.update();
                    },
                  );
                });
          },
          child: Icon(Icons.add),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [new Color(0xff00c2e5), new Color(0xff002476)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Column(children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text("${habbit.name} todolist ",
                    style: TextStyle(fontFamily: "PT_SANS")),
              actions: <Widget>[Question("Welcome to the todo page!\n\n This page is local to each habit. Press the + icon in the bottom right-hand corner to add a task to the todo list of this habit!")],),
              TodoList(
                habbit: habbit,
                controller: con,
                habbitController: habbitController,
              )
            ])));
  }
}

class TodoList extends StatefulWidget {
  const TodoList(
      {Key key, @required this.habbit, this.controller, this.habbitController})
      : super(key: key);

  final Habbit habbit;
  final Controller controller;
  final HabbitController habbitController;
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(update);
  }

  void update() {
    setState(() {
      widget.habbitController.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 700,
      child: ListView.builder(
          itemCount: widget.habbit.todos.length,
          itemBuilder: (cpntext, i) {
            return Opacity(
              opacity: widget.habbit.todos[i].done ? 0.7 : 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Habbit.colors[widget.habbit.colorNumber],
                    ),
                    child: Row(children: [
                      Text(widget.habbit.todos[i].name,
                          style: TextStyle(
                              fontFamily: "PT_SANS",
                              color: Colors.white,
                              fontSize: 25)),
                      Spacer(),
                      Checkbox(
                          value: widget.habbit.todos[i].done,
                          onChanged: (f) {
                            setState(() {
                              widget.habbit.todos[i].done = f;

                              widget.habbitController.save();
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.habbit.removeTodo(i);
                              widget.habbitController.save();
                            });
                          })
                    ])),
              ),
            );
          }),
    );
  }
}

class Todo {
  String name = "Task";

  bool done = false;

  Todo({this.name = "Task"});

  Todo.fromJson(Map<String, dynamic> m) {
    name = m["name"];

    done = m["done"];
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "done": done,
      };
}

class NewTodoPage extends Dialog {
  final Todo person;
  final Function onReady;
  NewTodoPage({this.person, this.onReady});
  final TextEditingController nameText = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
      title: Text(
        "New Daily Task",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff006FAB),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: TextField(
            controller: nameText,
                          maxLength: 18,

            decoration: InputDecoration(
              counter: Offstage(),
                hintText: "Name",
                hintStyle:
                    TextStyle(color: Color.fromARGB(100, 255, 255, 255))),
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
            onPressed: () {
              person.name = nameText.text.isEmpty ? "Task": nameText.text;
              onReady();
              Navigator.pop(context);
            },
            child: Text("Create",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: "PT_SANS",
                )))
      ],
    );
  }
}
