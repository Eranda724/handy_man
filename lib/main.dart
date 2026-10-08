import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handy_man/presentation/state/mode_notifier.dart';
import 'package:handy_man/presentation/screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ModeNotifier())],
      child: const FixItApp(),
    ),
  );
}

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixIt',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const MainScreen(),
    );
  }
}
