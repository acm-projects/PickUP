import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;

class chooseTime extends StatelessWidget {
  const chooseTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0C2219),
        appBar: AppBar(
          title: const Text('Choose a Time'),
          titleTextStyle: const TextStyle(
            color: Colors.black, 
            fontFamily: 'Mada', 
            fontWeight: FontWeight.bold, 
            fontSize: 24,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Navigates back to the previous screen
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF80E046), // Green color
                  Color(0xFF88F37F), // Lighter green color
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // Add your column content here
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter, // Aligns the button to the bottom center
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 30),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    // Add your onPressed event here
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF80E046),
                          Color(0xFF88F37F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: const Text(
                      'Create Game',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//CALENDAR CODE VVVVVV

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _currentDate = DateTime.now();
  final DateTime _currentDate2 = DateTime.now();
  //List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];

  @override
  Widget build(BuildContext context) {
    /// Example with custom icon
    final calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        setState(() => _currentDate = date);
        //print(tz.TZDateTime.parse(Location.getTimeZone(), date.toIso8601String()).add(const Duration(hours: 7)));
        //if AM then regular if PM then double
      },
      weekendTextStyle: const TextStyle(
        color: Colors.black,
      ),
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: 'Choose Your Start Date',
      weekFormat: true,
      height: 200.0,
      selectedDateTime: _currentDate2,
      showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      weekdayTextStyle: const TextStyle(color: Colors.black),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
      ),
      todayTextStyle: const TextStyle(
        color: Colors.blue,
      ),
      markedDateIconBuilder: (event) {
        return event.icon ?? const Icon(Icons.help_outline);
      },
      minSelectedDate: _currentDate.subtract(const Duration(days: 1)),
      maxSelectedDate: _currentDate.add(const Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.grey,
      markedDateMoreShowTotal:
          true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: calendarCarousel,
              ), // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Container(
                margin: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              const HourMinuteDropdowns(), //
            ],
          ),
        ));
  }
}

class HourMinuteDropdowns extends StatefulWidget {
  const HourMinuteDropdowns({super.key});

  @override
  _HourMinuteDropdownsState createState() => _HourMinuteDropdownsState();
}

class _HourMinuteDropdownsState extends State<HourMinuteDropdowns> {
  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            value: selectedHour % 12,
            iconSize: 0,
            onChanged: (int? newValue) {
              setState(() {
                selectedHour = newValue!;
                print(selectedHour);
              });
            },
            items: List.generate(12, (hour) {
              print(selectedHour);
              return DropdownMenuItem<int>(
                value: hour,
                child: Text('${hour + 1}'),
              );
            }),
          ),
          const SizedBox(height: 10),
          DropdownButton<int>(
            value: selectedMinute,
            iconSize: 0,
            onChanged: (int? newValue) {
              setState(() {
                selectedMinute = newValue!;
              });
            },
            items: List.generate(60, (minute) {
              return DropdownMenuItem<int>(
                value: minute,
                child: Text('$minute'.padLeft(2, '0')),
              );
            }),
          ),
        ],
      ),
    );
  }
}