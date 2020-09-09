import 'package:flutter/material.dart';
import 'package:datamine/Screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Datamine',
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
