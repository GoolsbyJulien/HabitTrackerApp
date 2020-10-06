import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String text;

  const Question(
    this.text, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
          onPressed: () {
            showDialog(
                context: context,
                child: SimpleDialog(
                  backgroundColor: Colors.blue,
                  title: Icon(Icons.insert_emoticon,color: Colors.white,),
                  children: <Widget>[
                    Center(
                      child: Text(text,textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20,
                            fontFamily: "PT_SANS",
                            color: Colors.white,
                          )),
                    )
                  ,Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("Close"),),
                  ) ],
                ));
          },
          child: Text(
            "?",
            style: TextStyle(fontSize: 30, color: Colors.white),
          )),
    );
  }
}
