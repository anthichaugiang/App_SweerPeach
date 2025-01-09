import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/screens/comic/comment_view.dart';
import 'package:sweet_peach_fe/screens/index.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: IndexController(),

    );
  }
}

