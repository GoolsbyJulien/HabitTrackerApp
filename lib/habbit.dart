import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'todo.dart';
import 'habbit_info.dart';
import 'question.dart';

class HabbitPage extends StatelessWidget {
  final HabbitController controller = HabbitController();

  Widget build(BuildContext context) {
    return Scaffold(
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
          actions: <Widget>[
            Question(
                "Welcome to the habit page!\n\nIf you haven't already, tap the add button to add your first habit. When creating your habit, you can choose a color, an icon, and a name. Tap on the habit card to go to the next page")
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Habits", style: TextStyle(fontFamily: "PT_SANS")),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Container(
            width: 1300,
            height: 315,
            child: HabbitList(controller: controller),
          ),
        ),
        FlatButton(
            onPressed: () {
              Habbit p = new Habbit();

              showDialog(
                  context: context,
                  builder: (BuildContext c) {
                    return NewHabbitPage(
                      person: p,
                      onReady: () {
                        controller.addObject(p);
                      },
                    );
                  });
            },
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontFamily: "PT_SANS"),
            )),
        FlatButton(
            onPressed: () {
              controller.clear();
            },
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ))
      ]),
    ));
  }
}

class HabbitList extends StatefulWidget {
  const HabbitList({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final HabbitController controller;

  @override
  _HabbitListState createState() => _HabbitListState();
}

class _HabbitListState extends State<HabbitList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(update);
    load();
  }

  void update() {
    setState(() {});
  }

  int currentIndex = 0;
  void load() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    if (s.getString("HABBITS") == null) return;

    print(s.getString("HABBITS"));
    json
        .decode(s.getString("HABBITS"))
        .forEach((map) => widget.controller.addObject(Habbit.fromJson(map)));
  }

  @override
  Widget build(BuildContext context) {
    List<Habbit> habbits = widget.controller.habbits;

    return PageView.builder(
        controller: PageController(viewportFraction: 0.6),
        scrollDirection: Axis.horizontal,
        itemCount: habbits.length,
        onPageChanged: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HabbitInfoPage(
                            habbit: habbits[i],
                            controller: widget.controller,
                          )));
            },
            child: Opacity(
              opacity: i == currentIndex ? 1 : 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: habbits[i].getColor(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                habbits[i].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: "PT_SANS"),
                              ),
                            ),
                            Container(
                              width: 30,
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext c) {
                                          return AlertDialog(
                                            title: Text(
                                                "Are you sure you want to remove?"),
                                            actions: <Widget>[
                                              RaisedButton(
                                                color: Colors.blue,
                                                textColor: Colors.white,
                                                child: Text("Yes"),
                                                onPressed: () {
                                                  widget.controller.delete(i);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              RaisedButton(
                                                color: Colors.red,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No"),
                                              )
                                            ],
                                          );
                                        });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Icon(
                        habbits[i].getIcon(),
                        size: 100,
                        color: Colors.white,
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class HabbitController with ChangeNotifier {
  /*
       color: 

  */

  Random r = Random();
  List<Habbit> habbits = [];
  void save() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    s.setString("HABBITS", json.encode(habbits));
  }

  void clear() {
    habbits.clear();
    save();
    notifyListeners();
  }

  void add(String name, Color color, IconData icon) {
    habbits.add(Habbit(
        name: name, colorNumber: r.nextInt(3), iconNumber: r.nextInt(2)));
    notifyListeners();
    save();
  }

  void delete(int index) {
    habbits.removeAt(index);
    notifyListeners();
    save();
  }

  void addObject(Habbit h) {
    habbits.add(h);
    notifyListeners();
    save();
  }
}

class Habbit {
  String name;

  int colorNumber = 0;

  int iconNumber = 0;

  int weekGoal = 7;

  int doneInWeek = 0;

  int streak = 0;

  bool doneForDay;

  List<Todo> todos = [];
  List<Day> days = [];

  static List<Color> colors = [
    Color(0xff00BA7A),
    Colors.orange,
    Color(0xff1E94DD),
    Colors.red,
    Colors.pink
  ];
  static List<IconData> icons = [
    Icons.directions_run,
    Icons.access_alarm,
    Icons.book,
    Icons.access_alarm,
    Icons.wb_sunny,
    Icons.add_call,
    Icons.wb_sunny
  ];

  Habbit({this.name = "Name", this.colorNumber = 1, this.iconNumber = 1});

  void doForDay() {
    if (doneForDay) {
      return;
    }
    streak++;
    doneInWeek++;
  }

  int today() {
    for (int i = 0; i < days.length; i++) {
      if (sameDay(days[i].toDateTime(), DateTime.now())) return i;
    }
    return 0;
  }

  void newWeek() {
    doneInWeek = 0;
  }

  void newDay() {
    doneForDay = false;
  }

  double cal() {
    int numberDone = 0;
    int number = 0;
    for (Day d in days) {
      if (d.done > 0) {
        number++;
        if (d.done == 2) {
          numberDone++;
        }
      }
    }
    if (number == 0 || numberDone == 0) {
      return 0;
    }

    return (numberDone / number) ?? 0;
  }

  double calTODO() {
    if (todos.isEmpty) {
      return 0;
    }
    int numberDone = 0;
    for (Todo d in todos) {
      if (d.done) {
        numberDone++;
      }
    }

    return (numberDone / todos.length) ?? 0;
  }

  Habbit.fromJson(Map<String, dynamic> m) {
    colorNumber = m['color'];
    name = m['name'];
    iconNumber = m['icon'];
    streak = m['streak'];
    weekGoal = m['weekGoal'];
    doneInWeek = m['doneInWeek'];
    doneForDay = m['doneForDay'];

    print(m);
    if (m["TODO"] != null)
      json.decode(m["TODO"]).forEach((map) => addTodo(Todo.fromJson(map)));
    if (m["DAYS"] != null)
      json.decode(m["DAYS"]).forEach((map) => days.add(Day.fromJson(map)));
  }
  void addTodo(Todo t) {
    todos.add(t);
  }

  void addDay(DateTime d, int done) {
    for (int i = 0; i < days.length; i++) {
      if (sameDay(d, days[i].toDateTime())) {
        days.removeAt(i);
      }
    }
    days.add(Day(d.day, d.month, d.year, done));

    days.sort((a, b) => a.toDateTime().compareTo(b.toDateTime()));

    print(days);
  }

  static bool sameDay(DateTime d1, DateTime d2) {
    return d1.difference(d2).inDays == 0 && d2.day == d1.day;
  }

  void removeTodo(int i) {
    todos.removeAt(i);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        'color': colorNumber,
        'icon': iconNumber,
        'TODO': json.encode(todos),
        'DAYS': json.encode(days)
      };

  Color getColor() {
    return colors[colorNumber];
  }

  IconData getIcon() {
    return icons[iconNumber];
  }
}

class NewHabbitPage extends Dialog {
  final Habbit person;
  final Function onReady;
  NewHabbitPage({this.person, this.onReady});
  final TextEditingController nameText = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    PageController colorList = PageController(viewportFraction: 0.6);
    PageController iconList = PageController(viewportFraction: 0.6);

    return SimpleDialog(
      backgroundColor: Color(0xff006FAB),
      children: <Widget>[
        Center(
            child: TextField(
          maxLength: 14,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "PT_SANS",
          ),
          controller: nameText,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Enter name",
             hintStyle:TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
            counter: Offstage(),
            border: InputBorder.none,
          ),
        )),
        Container(
          width: 500,
          height: 100,
          child: PageView.builder(
              controller: iconList,
              scrollDirection: Axis.horizontal,
              itemCount: Habbit.icons.length,
              itemBuilder: (context, i) {
                return Icon(
                  Habbit.icons[i],
                  size: 100,
                  color: Colors.white,
                );
              }),
        ),
        Container(
          width: 500,
          height: 100,
          child: PageView.builder(
              controller: colorList,
              scrollDirection: Axis.horizontal,
              itemCount: Habbit.colors.length,
              itemBuilder: (context, i) {
                return Card(
                  color: Habbit.colors[i],
                );
              }),
        ),
        FlatButton(
            onPressed: () {
              person.colorNumber = colorList.page.floor();
              person.iconNumber = iconList.page.floor();
            person.name=  person.name.isEmpty? "Habit": nameText.text;
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
