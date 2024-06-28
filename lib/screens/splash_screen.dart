import 'package:ernlen/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isStarted = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isStarted = true;
      });
    });
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery
            .of(context)
            .platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 300,
            child: AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _isStarted ? 1 : 0,
              child: Container(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 60,
                      ),
                      Text(
                        'Ernlen',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      Text(
                        'Some message',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            bottom: _isStarted ? 70 : -100,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black87 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: MyTheme.customLightBlue.shade200,
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                height: 50,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Image.asset('images/google.png'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Login with Google',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 20
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
