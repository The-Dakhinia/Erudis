import 'package:ernlen/util/route.dart';
import 'package:flutter/material.dart';
import 'package:ernlen/screens/quiz.dart';
import 'package:ernlen/util/dummy.dart'; // Assuming MyText.text is defined here
import '../models/list_chapters.dart';

class ContentPage extends StatefulWidget {
  final String? index;

  const ContentPage({Key? key, this.index}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final List<String> _texts = ListChapter.listChapters;

  @override
  Widget build(BuildContext context) {
    // Ensure index is parsed as int
    final int idd = int.parse(widget.index!);

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed(MyRoute.homeRoute);
        return false;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),
                ),
              ),
              child: widget.index != null
                  ? Hero(
                      tag: widget.index.toString(),
                      child: Text(
                        _texts[idd],
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const Text('No Index'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              MyText.text,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              overflow: TextOverflow.clip,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QuizPage(index: widget.index.toString())));
          },
          child: Text(
            "Start Quiz",
            textAlign: TextAlign.center,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }
}
