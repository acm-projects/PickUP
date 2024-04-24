import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:pickup/classes/location.dart';
import 'package:pickup/classes/game.dart';
import 'package:timezone/timezone.dart' as tz;

class ChooseTime extends StatefulWidget {
  const ChooseTime({super.key});

  @override
  _ChooseTimeState createState() => _ChooseTimeState();
}

class _ChooseTimeState extends State<ChooseTime> {
  DateTime _currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  bool _isPM = false; // false for AM, true for PM

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime currentTime = DateTime.now().add(const Duration(minutes: 16));
    int hour = currentTime.hour % 12;

    if (hour == 0) {
      hour = 12; // 0 and 12 should map to 12 in 12-hour format
    }

    _hourController.text = hour.toString();
    _minuteController.text = (currentTime.minute).toString();
    _isPM = currentTime.hour - 12 >= 0;
  }

  @override
  Widget build(BuildContext context) {
    final calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        setState(() => _currentDate = date);
        print(date);
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
      todayButtonColor: Colors
          .transparent, // Keep today's background transparent or adjust as needed
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
      showOnlyCurrentMonthDate: true,
      minSelectedDate: _currentDate,
      maxSelectedDate: _currentDate.add(const Duration(days: 62)),
      height: 420.0,
      selectedDateTime: _currentDate,
      todayBorderColor: Colors.grey,
      markedDateMoreShowTotal:
          true, // null for not showing hidden events indicator
      // More customization options and properties can be added as needed
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A3E2F),
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(20), // Reduced height of the AppBar
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF80F37F), Color(0xFF80E046)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Positioned(
                  top: 15, // Adjust the top value to move it upwards as needed
                  left: 5,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 48), // Adjust based on IconButton's size
                    alignment: Alignment.center,
                    child: Text(
                      'Create a Date & Time',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top:
                      10, // Adjust the top value to move the button upwards as needed
                  left: 4,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _hourController,
                            decoration: const InputDecoration(
                              labelText: 'Hour',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _minuteController,
                            decoration: const InputDecoration(
                              labelText: 'Minute',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // Toggle switch for AM/PM
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isPM ? 'PM' : 'AM',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            Switch(
                              value: _isPM,
                              onChanged: (value) {
                                setState(() {
                                  _isPM = value;
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment
                    .bottomCenter, // Aligns the button to the bottom center
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 30),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      DateTime date = _currentDate;

                      int hour = int.parse(_hourController.text);

                      date = date.add(Duration(
                          hours: hour +
                              (_isPM ? 12 : 0) +
                              (hour % 12 == 0 ? -12 : 0),
                          minutes: int.parse(_minuteController.text)));

                      Game.currentGame.startTime = tz.TZDateTime.parse(
                          Location.getTimeZone(), date.toIso8601String());

                      if (date
                          .subtract(const Duration(minutes: 15))
                          .isAfter(DateTime.now())) {
                        Navigator.of(context).pushNamed('/ChooseLocation');
                      } else {
                        print(
                            "Your Game Time Must Be 15 minutes Atleast After the Current Time");
                      }
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: const Text(
                        'Next',
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
