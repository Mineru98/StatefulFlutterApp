import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int counter = 0;

  void onPressedPlus() {
    counter += 1;
    if (counter % 10 == 0) {
      setState(() {});
    }
  }

  void onPressedMinus() {
    setState(() {
      counter -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF4EDDB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Click Count', style: TextStyle(fontSize: 30)),
              Text('$counter', style: const TextStyle(fontSize: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: onPressedPlus,
                        icon: Icon(Icons.add_box_rounded, size: 48),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: onPressedMinus,
                        icon: Icon(
                          Icons.indeterminate_check_box_rounded,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
