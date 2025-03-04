import 'package:ernlen/firebase_options.dart';
import 'package:ernlen/screens/home_page.dart';
import 'package:ernlen/screens/splash_screen.dart';
import 'package:ernlen/util/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black, // Set primary color to black
        ),
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashScreen(),
        MyRoute.homeRoute : (context) => HomeScreen(),
      }
    );
  }
}