import 'package:flutter/material.dart';
import 'package:goal_tracker/todo.dart';
import 'package:intl/intl.dart';
import 'habbit.dart';
import 'stats.dart';
import 'question.dart';
import 'flutter_calendar_carousel.dart';

class HabbitInfoPage extends StatelessWidget {
  final Habbit habbit;
  final HabbitController controller;
  const HabbitInfoPage(
      {Key key, @required this.habbit, @required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    StreakController streakController = StreakController();

    String date = DateFormat("MMM d,y").format(now);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [new Color(0xff00c2e5), new Color(0xff002476)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Container(
              height: 230,
              padding: MediaQuery.of(context).padding,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Spacer(),
                      Question(
                          "Welcome to the habit tracker page! \n\nEach square marks a different day. If you are unsuccessful tap it once and the square will turn red. If you are successful tap it twice and it will turn green!")
                    ],
                  ),
                  Text(habbit.name,
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontFamily: "PT_SANS")),
                  Text(date,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "PT_SANS")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreakCounter(
                      habbit: habbit,
                      streak: streakController,
                    ),
                  )
                ],
              ),
              color: Habbit.colors[habbit.colorNumber],
            ),
            Calender(
              habit: habbit,
              hb: controller,
              update: () {
                streakController.update();
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoListPage(
                                  habbit: habbit,
                                  habbitController: controller)));
                    },
                    child: Text(
                      "TODO",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "PT_SANS"),
                    ),
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StatsPage(
                                    habbit: habbit,
                                  )));
                    },
                    child: Text(
                      "Stats",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "PT_SANS"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int daysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }
}

class StreakCounter extends StatefulWidget {
  StreakCounter({Key key, @required this.habbit, this.streak})
      : super(key: key);
  final StreakController streak;

  final Habbit habbit;

  @override
  _StreakCounterState createState() => _StreakCounterState();
}

class StreakController extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class _StreakCounterState extends State<StreakCounter> {
  int streakcounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.streak.addListener(update);

    for (Day d in widget.habbit.days) {
      if (d.done == 2) {
        streakcounter++;
      } else {
        streakcounter = 0;
      }
    }
  }

  void update() {
    setState(() {
      for (Day d in widget.habbit.days) {
        if (d.done == 2) {
          streakcounter++;
        } else {
          streakcounter = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("${streakcounter} day streak",
        style: TextStyle(
            letterSpacing: 5,
            fontSize: 25,
            color: Colors.white,
            fontFamily: "PT_SANS"));
  }
}

class Calender extends StatelessWidget {
  final Habbit habit;
  final HabbitController hb;

  final Function update;
  const Calender({Key key, this.habit, this.hb, this.update}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500,
        height: 450,
        child: CalendarCarousel(
          headerTextStyle: TextStyle(
              color: Colors.white, fontFamily: "PT_SANS", fontSize: 30),
          leftButtonIcon: Icon(
            Icons.arrow_left,
            color: Colors.white,
            size: 30,
          ),
          rightButtonIcon:
              Icon(Icons.arrow_right, size: 30, color: Colors.white),
          weekdayTextStyle: TextStyle(
              color: Colors.white, fontFamily: "PT_SANS", fontSize: 15),
          pageSnapping: true,
          weekDayPadding: EdgeInsets.all(0),
          showIconBehindDayText: false,
          customDayBuilder: (bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day) {
            return isPrevMonthDay || isNextMonthDay
                ? Container(
                    color: Colors.grey,
                    width: 40,
                    height: 40,
                  )
                : CalanderDay(
                    date: day,
                    hb: hb,
                    onSelected: update,
                    extra: isPrevMonthDay || isNextMonthDay,
                    habit: habit,
                  );
          },
        ));
  }
}

class Day {
  int done = 0;

  int day;
  int month;
  int year;

  Day(this.day, this.month, this.year, this.done);
  Day.fromJson(Map<String, dynamic> m) {
    day = m["day"];
    month = m["month"];
    year = m["year"];

    done = m["done"];
  }

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
        "done": done,
      };
  DateTime toDateTime() {
    return DateTime(year, month, day);
  }
}

class CalanderDay extends StatefulWidget {
  const CalanderDay({
    Key key,
    this.hb,
    this.date,
    this.habit,
    this.defaultColor = Colors.grey,
    this.doneColor = Colors.green,
    this.failedColor = Colors.red,
    this.extra,
    this.onSelected,
  }) : super(key: key);
  final Habbit habit;
  final HabbitController hb;
  final Function onSelected;
  final Color defaultColor;
  final Color doneColor;
  final Color failedColor;
  final bool extra;
  final DateTime date;
  @override
  _CalanderDayState createState() => _CalanderDayState();
}

class _CalanderDayState extends State<CalanderDay> {
  Color color;
  bool disabled = false;
  int done = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (Day d in widget.habit.days) {
      if (Habbit.sameDay(d.toDateTime(), widget.date)) {
        done = d.done;
        break;
      }
    }
    disabled = DateTime.now().isBefore(widget.date);
    color = widget.defaultColor;
    setColor();
  }

  void setColor() {
    setState(() {
      if (done == 0)
        color = widget.defaultColor;
      else if (done == 1)
        color = widget.failedColor;
      else {
        color = widget.doneColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (disabled) return;
        done = done >= 2 ? 0 : done += 1;
        setColor();
        widget.hb.save();
        widget.habit.addDay(widget.date, done);
        widget.onSelected();
      },
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(10),
            color: color,
            child: Center(child: Text(widget.date.day.toString()))),
      ),
    );
  }
}
