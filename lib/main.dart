import 'package:flutter/material.dart';

void main() {
  runApp(const FixItApp());
}

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const Scaffold(body: Center(child: Text('FixIt'))),
    );
  }
}
