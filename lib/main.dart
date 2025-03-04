// Flutter 및 Dart 라이브러리에서 필요한 기능을 가져옴
// 'package:flutter/material.dart'는 Flutter의 기본 위젯과 테마 등을 제공
// 'dart:math'에서 pi(π) 값을 사용하기 위해 가져옴
import 'package:flutter/material.dart';
import 'dart:math' show pi;

// 앱의 진입점(entry point)인 main() 함수
// runApp()을 호출하여 Flutter 앱을 실행
void main() {
  runApp(const App());
}

// App 클래스는 앱의 전체적인 구조를 정의하는 StatelessWidget
// 상태를 가지지 않는 위젯으로, 한 번 빌드되면 변경되지 않음
class App extends StatelessWidget {
  // 생성자에서 key를 받아 부모 위젯에 전달
  const App({super.key});

  // build 메서드는 위젯 트리를 생성하여 화면에 렌더링
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 기본 테마를 어두운 테마로 설정
      theme: ThemeData(brightness: Brightness.dark),
      // 다크 모드에서도 동일한 어두운 테마 적용
      darkTheme: ThemeData(brightness: Brightness.dark),
      // 테마 모드를 다크 모드로 고정
      themeMode: ThemeMode.dark,
      // 디버그 배너(오른쪽 상단의 "DEBUG" 표시)를 비활성화
      debugShowCheckedModeBanner: false,
      // 디버그 시 표시되는 그리드 라인을 비활성화
      debugShowMaterialGrid: false,
      // 앱의 홈 화면으로 HomePage 위젯을 설정
      home: const HomePage(),
    );
  }
}

// HomePage는 상태를 가지는 StatefulWidget
// 애니메이션처럼 변화가 필요한 UI를 위해 상태를 관리
class HomePage extends StatefulWidget {
  // 생성자에서 key를 받아 부모 위젯에 전달
  const HomePage({super.key});

  // State 객체를 생성하는 메서드
  @override
  State<HomePage> createState() => _HomePageState();
}

// HomePage의 상태를 관리하는 State 클래스
// SingleTickerProviderStateMixin을 사용하여 애니메이션 컨트롤러에 필요한 티커 제공
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // AnimationController와 Animation 객체를 선언
  // late 키워드를 사용해 나중에 초기화할 것임을 명시
  late AnimationController _controller;
  late Animation<double> _animation;

  // 위젯이 처음 생성될 때 호출되는 초기화 메서드
  @override
  void initState() {
    super.initState();
    // AnimationController 초기화
    // vsync: 애니메이션 프레임을 동기화하기 위해 현재 State 객체(this)를 사용
    // duration: 애니메이션 한 사이클이 2초 동안 실행되도록 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // Tween을 사용해 애니메이션 값의 범위를 0에서 2π(360도)로 설정
    // _controller와 연결하여 애니메이션 객체 생성
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    // 애니메이션을 무한히 반복하도록 설정
    _controller.repeat();
  }

  // 위젯이 트리에서 제거될 때 호출되는 정리 메서드
  @override
  void dispose() {
    // AnimationController를 정리하여 리소스 누수를 방지
    _controller.dispose();
    // 부모 클래스의 dispose 호출
    super.dispose();
  }

  // 위젯 트리를 빌드하는 메서드
  @override
  Widget build(BuildContext context) {
    // Scaffold는 기본적인 Material Design 구조를 제공하는 위젯
    return Scaffold(
      // Scaffold의 body 속성에 화면 중앙에 배치된 위젯 트리 정의
      body: Center(
        // AnimatedBuilder를 사용해 _controller의 값이 변경될 때마다 UI를 다시 빌드
        child: AnimatedBuilder(
          // 애니메이션이 변경될 때마다 빌드를 트리거할 애니메이션 객체 지정
          animation: _controller,
          // builder 함수는 애니메이션 값에 따라 새로운 위젯 반환
          builder: (context, child) {
            return Transform(
              // 회전 중심을 컨테이너의 중앙으로 설정
              alignment: Alignment.center,
              // Matrix4.identity()로 초기 변환 행렬 생성 후 Y축 기준으로 회전 적용
              // _animation.value는 애니메이션 진행에 따라 0에서 2π까지 변함
              transform: Matrix4.identity()..rotateY(_animation.value),
              // Transform 위젯의 자식으로 회전할 컨테이너 정의
              child: Container(
                width: 100, // 컨테이너 너비 100픽셀
                height: 100, // 컨테이너 높이 100픽셀
                // 컨테이너의 스타일을 정의
                decoration: BoxDecoration(
                  color: Colors.blue, // 배경 색상을 파란색으로 설정
                  borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 (반지름 10)
                  // 그림자 효과 추가
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.5,
                      ), // 그림자 색상 (투명도 0.5)
                      spreadRadius: 5, // 그림자 퍼짐 반경
                      blurRadius: 7, // 그림자 흐림 정도
                      offset: const Offset(0, 3), // 그림자 위치 (오른쪽 0, 아래 3)
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
