import 'package:flutter/material.dart';
import 'screens/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eShop',
      theme: ThemeData(
        accentColor: Colors.black,
        primaryColor: Colors.black,
        focusColor: Colors.black,
        highlightColor: Colors.black,
        indicatorColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}
