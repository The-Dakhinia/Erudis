import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/list_chapters.dart';
import '../util/theme.dart';
import 'content_page.dart'; // Import the ContentPage widget

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _texts = ListChapter.listChapters;
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) > Duration(seconds: 3)) {
          currentBackPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press again to exit'),
              duration: Duration(seconds: 3),
            ),
          );
          return false;
        }
        exit(1);
        return true;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        appBar: AppBar(
          backgroundColor:
          isDarkMode ? Colors.orange.shade900 : Colors.orange.shade400,
          leading: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: isDarkMode ? Colors.white : Colors.black),
            onSelected: (String result) {
              if (result == 'Logout') {
                // Handle login action
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Logout',
                child: Text(
                  'Logout',
                  style:
                  TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          title: Text(
            'Name',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: _texts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentPage(index: index.toString()),
                      ),
                    );
                  },
                  child: Card(
                    shadowColor: isDarkMode ? Colors.white : Colors.black,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: isDarkMode
                        ? MyTheme.customLightBlue.shade700
                        : MyTheme.customLightBlue.shade300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (index % 2 == 0) ...[
                            Container(
                              color: Colors.grey.withOpacity(0.3),
                              child: Center(child: Text("picture")),
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 200,
                              child: Hero(
                                tag: index.toString(),
                                child: Text(
                                  _texts[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              width: 200,
                              child: Hero(
                                tag: index.toString(),
                                child: Text(
                                  _texts[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              color: Colors.grey.withOpacity(0.3),
                              child: Center(child: Text("picture")),
                              height: 100,
                              width: 100,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
