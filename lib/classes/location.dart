import 'package:timezone/timezone.dart' as tz;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Location {
  static double latitude = 0;
  static double longitude = 0;

  static void step() async {
    if (await Geolocator.isLocationServiceEnabled() && await Geolocator.checkPermission() != LocationPermission.denied) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // You can convert the values to strings if needed:
      longitude = position.longitude;
      latitude = position.latitude;
    }
  }

  

  static tz.Location getTimeZone() {
    return tz.getLocation(
        timezoneNames[DateTime.now().timeZoneOffset.inMilliseconds]);
  }

  // Convert Location object to a map
  static Map<String, dynamic> get() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

Map timezoneNames = {
  0: 'UTC',
  10800000: 'Indian/Mayotte',
  3600000: 'Europe/London',
  7200000: 'Europe/Zurich',
  -32400000: 'Pacific/Gambier',
  -28800000: 'US/Alaska',
  -14400000: 'US/Eastern',
  -10800000: 'Canada/Atlantic',
  -18000000: 'US/Central',
  -21600000: 'US/Mountain',
  -25200000: 'US/Pacific',
  -7200000: 'Atlantic/South_Georgia',
  -9000000: 'Canada/Newfoundland',
  39600000: 'Pacific/Pohnpei',
  25200000: 'Indian/Christmas',
  36000000: 'Pacific/Saipan',
  18000000: 'Indian/Maldives',
  46800000: 'Pacific/Tongatapu',
  21600000: 'Indian/Chagos',
  43200000: 'Pacific/Wallis',
  14400000: 'Indian/Reunion',
  28800000: 'Australia/Perth',
  32400000: 'Pacific/Palau',
  19800000: 'Asia/Kolkata',
  16200000: 'Asia/Kabul',
  20700000: 'Asia/Kathmandu',
  23400000: 'Indian/Cocos',
  12600000: 'Asia/Tehran',
  -3600000: 'Atlantic/Cape_Verde',
  37800000: 'Australia/Broken_Hill',
  34200000: 'Australia/Darwin',
  31500000: 'Australia/Eucla',
  49500000: 'Pacific/Chatham',
  -36000000: 'US/Hawaii',
  50400000: 'Pacific/Kiritimati',
  -34200000: 'Pacific/Marquesas',
  -39600000: 'Pacific/Pago_Pago'
};
