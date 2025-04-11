import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/light_mode.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar DB
  await HabitDatabase.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HabitDatabase()..readHabits()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}
