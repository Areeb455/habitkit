import 'package:flutter/material.dart';
import 'package:habitkit/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open a box
  await Hive.openBox("Habit_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        // Light Theme
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold), // Example title
          titleMedium: TextStyle(color: Colors.black, fontSize: 18), // Medium title
          bodyLarge: TextStyle(color: Colors.black), // Large body text
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ),
      darkTheme: ThemeData(
        // Dark Theme
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), // Example title
          titleMedium: TextStyle(color: Colors.white, fontSize: 18), // Medium title
          bodyLarge: TextStyle(color: Colors.white), // Large body text
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch based on system settings
    );
  }
}
