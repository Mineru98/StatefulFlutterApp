import 'package:examapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE7626C),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF232B55)),
        ),
        cardColor: const Color(0xFFF4EDDB),
      ),
      home: HomeScreen(),
    );
  }
}
