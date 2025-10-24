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
        backgroundColor: const Color(0XFFE3F2FD),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1565C0),
          title: const Text('Spal azi ?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
        ),  
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: _showQuestion
              ? _buildQuestion()
              : _showAnimation
                ? _buildAnimation()
                : _buildDecision()
        ),
        ),
      );
      
  }

  Widget _buildQuestion(){
    return GestureDetector(
      key: const Key('question'),
      onTap: _startAnimation,
      child: _buildImageContainer('assets/images/spalmachine.png'),
    );

  }


  Widget _buildAnimation() {
    return _buildImageContainer('assets/images/Animated.gif'
      , key: const Key('animation')
      );
  }

  Widget _buildDecision() {
    return _status
      ? _buildImageContainer('assets/images/yes-machine.png',
      key: const Key('yes')
      )
      : _buildImageContainer('assets/images/no-machine.png',
      key: const Key('no')
      );
  
  }

  Widget _buildImageContainer(String path, {Key ? key}) {
    return SizedBox(
      key: key,
      width: 400,
      height: 560,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              path,
              width: 400,
              height: 560,
              fit: BoxFit.cover,
              ),
          ),
        Container(
          width: 400,
          height: 560,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0),
              width: 7,
            ),
          ),
        )
        ]
    ),
    );
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