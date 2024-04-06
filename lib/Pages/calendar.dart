import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:pickup/classes/location.dart';
import 'package:timezone/timezone.dart' as tz;

//Choose Date -> Choose Time

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dooboolab flutter calendar',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Calendar Carousel Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

DateTime _currentDate = DateTime.now();
final DateTime _currentDate2 = DateTime.now();
int selectedHour = DateTime.now().hour;
int selectedMinute = DateTime.now().minute;
bool _isSelectedPM = false;

class _MyHomePageState extends State<MyHomePage> {
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
      //markedDateIconMargin: 9,
      //markedDateIconOffset: 3,
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
              const HourMinuteDropdowns(),
              const AmpmButton(),
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
  //sportsGames[selectedSport]!.instantiate();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            value: selectedHour % 12,
            iconSize: 10,
            onChanged: (int? newValue) {
              setState(() {
                selectedHour = newValue!;
                _currentDate = _currentDate.copyWith(hour: selectedHour);
              });
            },
            items: List.generate(12, (hour) {
              return DropdownMenuItem<int>(
                value: (hour + 1) % 12,
                child: Text('${hour + 1}'),
              );
            }),
          ),
          const SizedBox(height: 10),
          DropdownButton<int>(
            value: selectedMinute,
            iconSize: 10,
            onChanged: (int? newValue) {
              setState(() {
                selectedMinute = newValue!;
                _currentDate = _currentDate.copyWith(minute: selectedMinute);
              });
            },
            items: List.generate(60, (minute) {
              return DropdownMenuItem<int>(
                value: minute,
                child: Text('$minute'.padLeft(2, '0')),
              );
            }),
          ),
          ElevatedButton(
            onPressed: () async {
              Location.step();
              print(Location.get());
              //Navigator.pushNamed(context, '/login/home/create/calendar/location');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 94, 160, 96),
            ),
            child: const Text(
              'Choose Location',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              print(tz.TZDateTime.parse(
                      Location.getTimeZone(), _currentDate.toIso8601String())
                  .add(Duration(hours: _isSelectedPM ? 12 : 0)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 94, 160, 96),
            ),
            child: const Text(
              'Go To Maps',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class AmpmButton extends StatefulWidget {
  const AmpmButton({super.key});

  @override
  _AmpmButtonState createState() => _AmpmButtonState();
}

class _AmpmButtonState extends State<AmpmButton> {
  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    _isSelectedPM = (now.period == DayPeriod.am ? 'AM' : 'PM') == 'PM';
  }

  void _toggleSelection() {
    setState(() {
      _isSelectedPM = !_isSelectedPM;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: _toggleSelection,
          style: TextButton.styleFrom(
            foregroundColor: _isSelectedPM
                ? Colors.blue
                : Colors.grey, // Change color based on selection
          ),
          child: const Text('PM'),
        ),
        const SizedBox(width: 10), // Add spacing between buttons
        TextButton(
          onPressed: _toggleSelection,
          style: TextButton.styleFrom(
            foregroundColor: !_isSelectedPM
                ? Colors.blue
                : Colors.grey, // Change color based on selection
          ),
          child: const Text('AM'),
        ),
      ],
    );
  }
}
