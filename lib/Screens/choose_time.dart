import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, Event;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class ChooseTime extends StatefulWidget {
  const ChooseTime({Key? key}) : super(key: key);

  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  DateTime _currentDate = DateTime.now();
  final DateTime _currentDate2 = DateTime.now();
  String? _selectedTime; 

 List<DropdownMenuItem<String>> getDropdownTimes() {
    List<DropdownMenuItem<String>> times = [];
    TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
    DateFormat formatter = DateFormat('h:mm a');
    for (int i = 0; i < 96; i++) {
      final DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute);
      times.add(DropdownMenuItem(
        value: formatter.format(dateTime),
        child: Text(formatter.format(dateTime), style: const TextStyle(color: Colors.white)), // Items text color
      ));
      time = (time.minute + 15) >= 60 ? TimeOfDay(hour: time.hour + 1, minute: (time.minute + 15) % 60) : time.replacing(minute: time.minute + 15);
    }
    return times;
  }
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Navigates back to the previous screen
            },
          ),
          title: const Text('Choose a Date & Time'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Mada',
            fontWeight: FontWeight.bold,
            
            fontSize: 24,
          ),
          backgroundColor: Colors.transparent, // Make AppBar background transparent
          elevation: 0, // Removes shadow
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF88F37F), 
                  Color(0xFF88F37F),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              // borderRadius: BorderRadius.circular(30), // Rounded corners
            ),
          ),
        ),
         body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    calendarCarousel, // Display the calendar
                    const SizedBox(height: 20), // Spacing before the dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Time',
                        labelStyle: const TextStyle(color: Colors.white), 
                        border: OutlineInputBorder(),
                         enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Border color
                        ),
                      ),
                      value: _selectedTime,
                      items: getDropdownTimes(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTime = value;
                        });
                      },
                       dropdownColor: Color(0xFF0C2219), // Dropdown menu background color
                    ),
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
                     Navigator.of(context).pushNamed('/homePage');
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
