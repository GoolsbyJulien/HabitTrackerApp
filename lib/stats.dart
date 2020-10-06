import 'package:flutter/material.dart';
import 'habbit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsPage extends StatelessWidget {
  final Habbit habbit;

  const StatsPage({Key key, this.habbit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff00c2e5), Color(0xff002476)])),
      child: Column(children: [
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Stats",
            style: TextStyle(fontFamily: "PT_SANS"),
          ),
        ),
        Progress(title: "Habit Success Rate", value: habbit.cal()),
        Progress(title: "Todo Completion", value: habbit.calTODO())
      ]),
    ));
  }
}

class Progress extends StatelessWidget {
  const Progress({Key key, @required this.value, this.title}) : super(key: key);

  final double value;
  final String title;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      height: 200,
      child: CircularPercentIndicator(
        backgroundColor: Colors.red,
        progressColor: Colors.green,
        animation: true,
        animationDuration: 30000,
        lineWidth: 10,
        header: Text(
          title,
          style: TextStyle(
              fontFamily: "PT_SANS", color: Colors.white, fontSize: 20),
        ),
        startAngle: 0,
        reverse: true,
        radius: 150,
        center: Text(
          "${(value * 100).floor()}%",
          style: TextStyle(
              fontFamily: "PT_SANS", color: Colors.white, fontSize: 30),
        ),
        percent: value,
      ),
    );
  }
}
