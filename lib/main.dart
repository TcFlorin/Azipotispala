import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Funcție separată pentru parsing JSON pe thread separat
Future<Map<String, dynamic>> parseCalendar(String jsonString) async {
  return json.decode(jsonString) as Map<String, dynamic>; 
}

Future<Map<String, dynamic>> loadOrthodoxCalendar() async {
  String jsonString = await rootBundle.loadString('assets/ORTHODOX_CALENDAR_2025.json');
  return compute(parseCalendar, jsonString);
}



Future<Map<String, dynamic>> isHolidayToday() async {
  final holidays = await loadOrthodoxCalendar();
  DateTime now = DateTime.now();
  String month = now.month.toString();
  String day = now.day.toString();
  int weekday = now.weekday; // 1 = Luni, 7 = Duminică

  if (weekday == 7)
    {
      return {'isHoliday': true, 'date': now.day.toString()};
    }

  if (!holidays.containsKey(month)) {
    return {'isHoliday': false, 'date': ''};
  }

  final dayList = holidays[month] as List<dynamic>;

  for (var holiday in dayList) {
    if (holiday['date'] == day) {
      return {
        'isHoliday': holiday['isHoliday'] == true,
        'date': holiday['date'] ?? ''
    };
  }}

  return {'isHoliday': false, 'date': ''};
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    body: Stack(
      alignment: Alignment.center,
      children: [
        // 🔹 fundal permanent
        Image.asset(
          'assets/images/background.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        // 🔹 podeaua (mereu prezentă)
        Positioned(
          bottom: 0,
          child: Image.asset(
            'assets/images/floor.png',
            width: 600,       // ajustează după design
            height: 300,      // înălțimea podelei
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
          ),
        ),
        // 🔹 conținut principal
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🟢 Titlu retro pixel-art
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 219, 152), // verde pixelat retro
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Text(
                'Spălăm azi ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PixelFont', // font pixelat (trebuie adăugat în assets)
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                  height: 1.4,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),

            // 🧺 Zona mașinii de spălat / animației / rezultatului
            SizedBox(
              width: 400,
              height: 560,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                switchInCurve: Curves.linear,
                switchOutCurve: Curves.linear,
                child: _showQuestion
                    ? _buildQuestion()
                    : _showAnimation
                        ? _buildAnimation()
                        : _buildDecision(),
              ),
            ),
          ],
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
    key: ValueKey(DateTime.now().millisecondsSinceEpoch), // 👈 forțează rebuild total
    child: Transform.scale(
      scale: 1.2575,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [

        Positioned(
          bottom: 109,
          child: Opacity(
            opacity: 1,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(1.2, 1.5, 1.0), // doar pe verticală
              child: Image.asset(
                'assets/images/foam2.gif',
                width: 320,
                height: 130,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
              ),
            ),
          ),
        ),
        Image.asset('assets/images/Animated.gif',
        width: 410,
        height: 595,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
      ),
      Positioned(
        bottom: 70,
        child: Image.asset(
          'assets/images/foam.gif',
          width: 350,
          height: 170,
          fit: BoxFit.contain, 
          filterQuality: FilterQuality.none


        )
        ),
      ],
      ),
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
            left: 40,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 219, 152), // verde pixelat retro
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                _holidayText.isNotEmpty ? '$weekday: $_holidayText' : weekday,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'PixelFont', // fontul tău pixelat
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.3,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),


        // Buton restart (opțional)
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center( 
          child: GestureDetector(
            onTap: _resetToStart,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 219, 152), // verde retro
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '↺', // simbol retro de restart
                  style: TextStyle(
                    fontFamily: 'PixelFont', // font pixelat
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
              ),
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

    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    
    setState(() {
    

      _showQuestion = false;
      _showAnimation = true;
    });

      await Future.delayed(const Duration(milliseconds: 1770));

      final today = await isHolidayToday();

      if(!mounted) return;

      final bool newStatus = !today['isHoliday'];
      final String holidayDetail = today['date'] as String;

      setState(() {
        _status = !today['isHoliday'];
        _holidayText = today['date'];
        _showAnimation = false;
        _showDecision = true;
        
      
    });
  }}