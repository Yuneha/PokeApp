import 'package:flutter/material.dart';
import 'package:poke_project/screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poke App',
      theme: ThemeData(
        fontFamily: 'Pokemon',
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const HomePage(),
    );
  }
}
