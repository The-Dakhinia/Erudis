import 'dart:ffi';

import 'package:ernlen/screens/content_page.dart';
import 'package:ernlen/util/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  final String index;

  const QuizPage({super.key, required this.index});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> questions = [
    Question('What is the capital of France?',
        ['Paris', 'London', 'Berlin', 'Madrid'], 0),
    Question('What is 2 + 2?', ['3', '4', '5', '6'], 1),
    Question('Who wrote "To be, or not to be"?',
        ['Shakespeare', 'Hemingway', 'Tolkien', 'Orwell'], 0),
    Question('', ['', '', '', ''], 0),
  ];

  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int coins = 0;
  late Timer _timer;
  int _start = 300;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _showResult2(false);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showResult1(int selectedOption) {
    bool opt = false;
    if (questions[currentQuestionIndex].correctOptionIndex == selectedOption) {
      correctAnswers++;
      coins++;
      opt = true;
    }
    if (opt == true)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Correct answer"),
            content: Text("You earned $coins coins!"),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (currentQuestionIndex < questions.length - 1)
                      Navigator.of(context).pop();
                    else
                      _showResult2(true);
                  },
                  child: Text("Okay"))
            ],
          );
        },
      );
    else
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Wrong answer"),
            content: Text("You earned $coins coins!"),
            actions: [
              TextButton(
                  onPressed: () {
                    if (currentQuestionIndex < questions.length - 1)
                      Navigator.of(context).pop();
                    else
                      _showResult2(true);
                  },
                  child: Text("Okay"))
            ],
          );
        },
      );

    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length - 1)
      setState(() {
        currentQuestionIndex;
      });
  }

  void _showResult2(bool opt) {
    if (opt == true)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You have reached the end question"),
            content: Text("You earned $coins coins! Thank You"),
            actions: [
              TextButton(
                  onPressed: () {
                    dispose();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContentPage(
                              index: widget.index.toString(),
                            )));
                  },
                  child: Text("Okay"))
            ],
          );
        },
      );
    else
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Times up!!"),
            content: Text("You earned $coins coins!"),
            actions: [
              TextButton(
                  onPressed: () {
                    dispose();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContentPage(
                              index: widget.index.toString(),
                            )));
                  },
                  child: Text("Okay"))
            ],
          );
        },
      );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          leading: Icon(Icons.star),
          title: Row(
            children: [
              Text("Coins earned: $coins"),
              SizedBox(width: 2),
              Icon(Icons.attach_money),
            ],
          ),
          backgroundColor:
              isDarkMode ? Colors.orange.shade900 : Colors.orange.shade400,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text("Time: ${_formatTime(_start)}"),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Text(
                    questions[currentQuestionIndex].questionText,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 29,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
              Divider(
                thickness: 3,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              ...questions[currentQuestionIndex]
                  .options
                  .asMap()
                  .entries
                  .map((entry) {
                int idx = entry.key;
                String val = entry.value;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () => _showResult1(idx),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? MyTheme.customLightBlue.shade700
                            : MyTheme.customLightBlue.shade400,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.8),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            val,
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("End Quiz"),
                  content: Text("Are you sure you want to end the quiz?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        dispose();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ContentPage(index: widget.index)));
                      },
                      child: Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No"),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.stop),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  Question(this.questionText, this.options, this.correctOptionIndex);
}
