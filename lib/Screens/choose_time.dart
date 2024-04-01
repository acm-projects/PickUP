import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, Event;
import 'package:timezone/timezone.dart' as tz;

class ChooseTime extends StatefulWidget {
  const ChooseTime({Key? key}) : super(key: key);

  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  DateTime _currentDate = DateTime.now();
  final DateTime _currentDate2 = DateTime.now();

   @override
  Widget build(BuildContext context) {
    final calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        setState(() => _currentDate = date);
      },
      weekendTextStyle: const TextStyle(
        color: Colors.white, // Change weekend text to white
      ),
      headerTextStyle: const TextStyle(
        color: Colors.white, // Change header text to white
        fontSize: 20.0, // Optional: Adjust the font size as needed
      ),
      weekdayTextStyle: const TextStyle(
        color: Colors.white, // Change weekday text to white
      ),
      iconColor: Colors.white, // Change arrow icons color to white
      daysTextStyle: const TextStyle(
        color: Colors.white, // Change default days text to white
      ),
      todayTextStyle: const TextStyle(
        color: Colors.white, // Change today text style to white
      ),
      todayButtonColor: Colors.transparent, // Keep today's background transparent or adjust as needed
      selectedDayTextStyle: const TextStyle(
        color: Colors.white, // Change selected day text to white
      ),
      prevDaysTextStyle: const TextStyle(
        color: Colors.white, // Change previous days text to white
      ),
      nextDaysTextStyle: const TextStyle(
        color: Colors.white, // Change next days text to white
      ),
      thisMonthDayBorderColor: Colors.grey, // Adjust as needed
      weekFormat: false,
      height: 420.0,
      selectedDateTime: _currentDate2,
      todayBorderColor: Colors.grey,
      markedDateMoreShowTotal: true, // null for not showing hidden events indicator
      // More customization options and properties can be added as needed
    );


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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // Add your column content here
                  children: [
                    const SizedBox(height: 20), // For spacing
                    calendarCarousel, // Display the calendar
                  ],
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
      ),
    );
  }
}
