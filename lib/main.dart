import 'package:flutter/material.dart';
import 'package:marvel_comics_app/screens/MainScreen.dart';
import 'package:marvel_comics_app/screens/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.brown[50]),
      ),
      home: SplashPage(
          duration: 3, goToPage: const MainScreen(title: 'Characters')),
    );
  }
}
