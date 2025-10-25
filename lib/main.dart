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
        backgroundColor: const Color.fromARGB(255, 57, 189, 103),
        title: const Text(
          'Spăl azi ???',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PixelFont', fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // fundal permanent
          Image.asset(
            'assets/images/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // conținutul principal
          Center(
            child: SizedBox(
              width: 400,
              height: 560,
              child: AnimatedSwitcher(
                duration: Duration.zero,  // instant
                child: _showQuestion
                    ? _buildQuestion()
                    : _showAnimation
                        ? _buildAnimation()
                        : _buildDecision(),
              )
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMachine(String path, {Key ? key})
  {
    return Image.asset(
      
      path,
      width: 300,
      height: 400,
      fit: BoxFit.contain,
    );
  }

  Widget _buildQuestion(){
    return GestureDetector(
      key: const Key('question'),
      onTap: _startAnimation,
      child: _buildMachine('assets/images/spalmachine.png'),
    );

  }


  Widget _buildAnimation() {
  return Center(
    key: const Key('animation'),
    child: Image.asset(
      'assets/images/Animated.gif',
      width: 300,
      height: 400,
      fit: BoxFit.contain, // 🔹 asigură proporții corecte
    ),
  );
}
  Widget _buildDecision() {
  DateTime now = DateTime.now();
  String weekday = [
    'Luni',
    'Marți',
    'Miercuri',
    'Joi',
    'Vineri',
    'Sâmbătă',
    'Duminică'
  ][now.weekday - 1];

  return SizedBox(
    key: const Key('decision'),
    width: 400,
    height: 560,
    child: Stack(
      alignment: Alignment.center,
      children: [
        _buildMachine(
          _status
              ? 'assets/images/yes-machine.png'
              : 'assets/images/no-machine.png',
          key: const Key('machine'),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Text(
            _holidayText.isNotEmpty
                ? '$weekday: $_holidayText'
                : weekday,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28, // font mai mare
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'PixelFont', // font monospace / pixelat
              backgroundColor: Colors.transparent, // fără fundal
              letterSpacing: 1.2,
            ),
          ),
        ),

        // Buton restart (opțional)
        Positioned(
          bottom: 50,
          left: 10,
          right: 10,
          child: ElevatedButton(
            onPressed: _resetToStart,
            child: const Text("Restart"),
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
        ]
    ),
    );
  }

  void _resetToStart() {
  setState(() {
    _showQuestion = true;
    _showAnimation = false;
    _showDecision = false;
    _status = false;
    _holidayText = '';
  });
}

  void _startAnimation() async {
    setState(() {

      _showQuestion = false;
      _showAnimation = true;
    });
      await Future.delayed(const Duration(milliseconds: 1500));

      final today = await isHolidayToday();

      if(!mounted) return;

      setState(() {
        _status = !today['isHoliday'];
        _holidayText = today['text'];
        _showAnimation = false;
        _showDecision = true;
        
      
    });
  }}