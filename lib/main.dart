import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  bool _showQuestion = true; // false - ecranul initial
  bool _showAnimation = false; // false - ecranul initial
  bool _showDecision  = false; // false - ecranul initial
  bool _status  = false; // True - DA, False - NU

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spal azi ?'),
        ),
        body: Center(
          child: _showQuestion
            ? _buildQuestion()
            : _showAnimation
              ? _buildAnimation()
              : _buildDecision()
        ),
      );
  }

  Widget _buildQuestion(){
    return GestureDetector(
      onTap: _startAnimation,
      child: Image.asset('assets/images/spalmachine.png'),
    );

  }


  Widget _buildAnimation() {
    return Image.asset('assets/images/Animated.gif');
  }

  Widget _buildDecision() {
    return _status
      ? Image.asset('assets/images/yes-machine.png')
      : Image.asset('assets/images/no-machine.png');
  
  }

  void _startAnimation() {
    setState(() {

      _showQuestion = false;
      _showAnimation = true;

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _status = (DateTime .now().second % 2 == 0);
          _showAnimation = false;
          _showDecision = true;
        });
      });
    });
  }}