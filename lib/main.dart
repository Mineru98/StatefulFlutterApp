import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<GlobalKey<State>> _screenKeys = [
    GlobalKey<State>(),
    GlobalKey<State>(),
  ];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      AnimationScreen1(key: _screenKeys[0]),
      AnimationScreen2(key: _screenKeys[1]),
    ]);
  }

  void _handlePageChange(int index) {
    // 이전 페이지의 애니메이션 중지
    if (_currentPage == 0) {
      final state = _screenKeys[0].currentState as _AnimationScreen1State?;
      state?._stopAnimation();
    } else if (_currentPage == 1) {
      final state = _screenKeys[1].currentState as _AnimationScreen2State?;
      state?._stopAnimation();
    }

    setState(() {
      _currentPage = index;
    });

    // 새 페이지의 애니메이션 시작
    if (index == 0) {
      final state = _screenKeys[0].currentState as _AnimationScreen1State?;
      state?._startAnimation();
    } else if (index == 1) {
      final state = _screenKeys[1].currentState as _AnimationScreen2State?;
      state?._startAnimation();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _screens.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _currentPage == index
                                ? Colors.blueAccent
                                : Colors.grey,
                      ),
                      onPressed: () {
                        _pageController.jumpToPage(index);
                      },
                      child: Text('Animation ${index + 1}'),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _handlePageChange,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class AnimationScreen1 extends StatefulWidget {
  const AnimationScreen1({super.key});

  @override
  State<AnimationScreen1> createState() => _AnimationScreen1State();
}

class _AnimationScreen1State extends State<AnimationScreen1>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2.0),
    ).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
    );

    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
        );
        _flipController
          ..reset()
          ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value + -(pi / 2.0),
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut,
          ),
        );
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });

    // 1초 후에 애니메이션 시작
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _counterClockwiseRotationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  void _stopAnimation() {
    _counterClockwiseRotationController.stop();
    _flipController.stop();
  }

  void _startAnimation() {
    _counterClockwiseRotationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _counterClockwiseRotationController,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..rotateZ(_counterClockwiseRotationAnimation.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _flipController,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.centerRight,
                      transform:
                          Matrix4.identity()..rotateY(_flipAnimation.value),
                      child: ClipPath(
                        clipper: const HalfCircleClipper(side: CircleSide.left),
                        child: Container(
                          color: const Color(0xff0057b7),
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.centerLeft,
                      transform:
                          Matrix4.identity()..rotateY(_flipAnimation.value),
                      child: ClipPath(
                        clipper: const HalfCircleClipper(
                          side: CircleSide.right,
                        ),
                        child: Container(
                          color: const Color(0xffffd700),
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AnimationScreen2 extends StatefulWidget {
  const AnimationScreen2({super.key});

  @override
  State<AnimationScreen2> createState() => _AnimationScreen2State();
}

class _AnimationScreen2State extends State<AnimationScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _stopAnimation() {
    _controller.stop();
  }

  void _startAnimation() {
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(_animation.value),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
