import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadOrthodoxCalendar() async {
  String jsonString = await rootBundle.loadString('assets/ORTHODOX_CALENDAR_2025.json');
  return json.decode(jsonString);
}



Future<Map<String, dynamic>> isHolidayToday() async {
  final holidays = await loadOrthodoxCalendar();
  DateTime now = DateTime.now();
  String month = now.month.toString();
  String day = now.day.toString();

  if (!holidays.containsKey(month)) {
    return {'isHoliday': false, 'date': ''};
  }

  final dayList = holidays[month] as List<dynamic>;

  for (var holiday in dayList) {
    if (holiday['date'] == day) {
      return {
        'isHoliday': holiday['isHoliday'] == true,
        'text': holiday['date'] ?? ''
    };
  }}

  return {'isHoliday': false, 'date': ''};
}


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
  String _holidayText = '';
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
  }Widget _buildContent() {
  DateTime now = DateTime.now();
  String weekday = ['Luni','Marți','Miercuri','Joi','Vineri','Sâmbătă','Duminică'][now.weekday - 1];

  String? displayText = _showDecision && _holidayText.isNotEmpty ? '$weekday: $_holidayText' : '';

  String imagePath;
  if (_showQuestion) {
    imagePath = 'assets/images/spalmachine.png';
  } else if (_showAnimation) {
    imagePath = 'assets/images/Animated.gif';
  } else {
    imagePath = _status ? 'assets/images/yes-machine.png' : 'assets/images/no-machine.png';
  }

  return SizedBox(
    width: 400,
    height: 560 + 60, // imagine + spațiu pentru text
    child: Column(
      children: [
        SizedBox(
          width: 400,
          height: 560,
          child: _buildImageContainer(imagePath),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60, // spațiu fix pentru text
          child: Center(
            child: Text(
              displayText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
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

  void _startAnimation() async {
    setState(() {

      _showQuestion = false;
      _showAnimation = true;
    });
      await Future.delayed(const Duration(seconds: 2));

      final today = await isHolidayToday();

      setState(() {
        _status = !today['isHoliday'];
        _holidayText = today['text'];
        _showAnimation = false;
        _showDecision = true;
        
      
    });
  }}