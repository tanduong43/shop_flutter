import 'package:flutter/material.dart';
import 'package:shopflutter/view/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //  home: homePage(),
      home: LoginPage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
