import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'customFonts.dart';
import 'habbit.dart';
import 'question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      initialRoute: "HOME",
      routes: {
        "HOME": (context) => HomePage(),
        "GOALS": (context) => HabbitPage(),
        "ABOUT": (context) => AboutPage()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [new Color(0xff00c2e5), new Color(0xff002476)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Stack(children: [
          Question(
              "Welcome to the app!\n\n If you want to learn more tap the about button. If you want to start tracking your habits tap the habit button"),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 76),
                child: Container(
                    child: Icon(IconsFont.trophy_1,
                        color: Colors.amber, size: 180)),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: QuoteText(
                  time: 7,
                  list: [
                    "You miss 100% of the shots you don't take.",
                    "Don't go gently into that goodnight,but rage at the dying of the light.",
                    "If you get 1% better every day, after a year, you'll be 365% better than you were.",
                    "Don't quit when you're tired. Quit when you're done.",
                    "How rare and beautiful it is to exist.",
                    "If you're good of something, never do it for free.",
                    "The mold of your life is in your hands to break.",
                    "The greatest adventure is what lies ahead.",
                    "Tough times never last but tough people do.",
                    "Hurrying and delaying are alike ways to resist the past.",
                    "Compare yourself to who you were yesterday, not who someone else is today.",
                    "Place your becoming above your current being."
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(26.0),
                child: Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "GOALS");
                      },
                      child: Text(
                        "Habits",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "PT_SANS"),
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "ABOUT");
                      },
                      child: Text(
                        "About",
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
        ]),
      ),
    );
  }
}

class QuoteText extends StatefulWidget {
  QuoteText({
    Key key,
    this.list,
    this.time,
  }) : super(key: key);
  final List<String> list;
  final int time;
  final Random rand = new Random();
  String getRandom() {
    return list[rand.nextInt(list.length)];
  }

  @override
  _QuoteTextState createState() => _QuoteTextState();
}

class _QuoteTextState extends State<QuoteText> {
  Timer timer;
  String text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(Duration(seconds: 4), (Timer t) {
      setState(() {
        text = widget.getRandom();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: Colors.white, fontSize: 20, fontFamily: "PT_SANS"),
      textAlign: TextAlign.center,
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<AboutCard> abouts = [
      AboutCard(
          color: Colors.cyan,
          header: "Concept",
          text:
              "Humans are beings of habit.\n\nIn most cases, the longer we have a habit going the easier it is to keep going. The issue this app is made to help with is the process of starting a new habit. For example, say you want to code once per day. Using this app you can easily create a habit profile for it and each day you can gain a small sense of pride by marking you did said habit.\n\nThat was my goal for this project, and I hope to have achieved that!  "),
      AboutCard(
          color: Colors.green,
          header: "Development",
          text:
              "This is developed using flutter and the dart programming language. The reason flutter was used because it would have allowed the app to be built for both android and ios at the same time. Unfortunately, I did not have a mac to be able to test this feature. \nDevelopment took about 2 calendar weeks. A major set back was getting the app to save data dynamically, but I was able to find a solution in time and I learned a lot from this process."),
      AboutCard(
          color: Colors.purple,
          header: "What would I do next?",
          text:
              "If I were to continue this project, there would be a lot more features I would add. The first one being a login system and being able to save data to the cloud. This would allow the user to interface with the app through multiple platforms and have the data be constant throughout using firebase. I would also add notifications to remind the user to work on their habit. I would polish everything to make the app look a little more professional."),
      AboutCard(
          color: Colors.red,
          header: "About the creator",
          text:
              "Hi my name is Julien!\n\nI am a first-generation college student attending the University of Central Missouri in the fall.\n\nI will be a freshman majoring in computer science. I have always loved to make things, whether it be games, music, or now apps, it fills me with a lot of joy to see something I have an idea of, being born. In the future, I hope to take my computer science skills and use them to help people in the same way that technologies have helped me. So even if it's something as simple as a habit tracker, it helps at least one person, I would have done my job."),
    ];
    // TODO: implement build
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
            "About",
            style: TextStyle(fontFamily: "PT_SANS"),
          ),
        ),
        Text(
          "This app was made as a project for a schoolarship by Julien Goolsby",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "PT_SANS", fontSize: 30, color: Colors.white),
        ),
        Container(
          width: 400,
          height: 480,
          child: PageView.builder(
              controller: PageController(viewportFraction: 0.7),
              scrollDirection: Axis.horizontal,
              itemCount: abouts.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: abouts[i].color,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  abouts[i].header,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: "PT_SANS"),
                                ),
                              ),
                              Text(
                                abouts[i].text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: "PT_SANS"),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ]),
    ));
  }
}

class AboutCard {
  String text;
  String header;
  Color color;

  AboutCard({this.text, this.header, this.color});
}
