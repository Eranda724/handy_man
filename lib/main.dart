import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handy_man/presentation/state/mode_notifier.dart';
import 'package:handy_man/presentation/screens/main_screen.dart';
import 'package:handy_man/presentation/state/providers_notifier.dart';
import 'package:handy_man/presentation/state/bookings_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModeNotifier(prefs)),
        ChangeNotifierProvider(create: (_) => ProvidersNotifier()),
        ChangeNotifierProvider(create: (_) => BookingsNotifier(prefs)),
      ],
      child: const FixItApp(),
    ),
  );
}

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ModeNotifier>().isDarkMode;
    return MaterialApp(
      title: 'FixIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
