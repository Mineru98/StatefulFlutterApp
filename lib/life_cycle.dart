import 'package:flutter/material.dart';

class LifeCycleApp extends StatefulWidget {
  const LifeCycleApp({super.key});

  @override
  State<LifeCycleApp> createState() => _LifeCycleAppState();
}

class _LifeCycleAppState extends State<LifeCycleApp> {
  bool showTitle = true;

  void toggleShowTitle() {
    setState(() {
      showTitle = !showTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.red)),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF4EDDB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showTitle ? MyLargeTitle() : Text("Title Hidden"),
              IconButton(
                onPressed: toggleShowTitle,
                icon: const Icon(Icons.remove_red_eye),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 라이프 사이클에 대한 내용
class MyLargeTitle extends StatefulWidget {
  const MyLargeTitle({super.key});

  @override
  State<MyLargeTitle> createState() => _MyLargeTitleState();
}

class _MyLargeTitleState extends State<MyLargeTitle> {
  int count = 0;
  @override
  void dispose() {
    super.dispose();
    print("dispose!");
  }

  @override
  void initState() {
    super.initState();
    print("initState!");
  }

  @override
  Widget build(BuildContext context) {
    print("build!");
    return Text(
      'My Large Title',
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }
}
