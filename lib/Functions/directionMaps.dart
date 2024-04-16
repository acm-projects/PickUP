import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickup/classes/game.dart';
import 'package:pickup/classes/location.dart' as userl;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:pickup/classes/user.dart';
import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geo;
import 'package:location_platform_interface/location_platform_interface.dart'
    hide LocationAccuracy;

import 'package:timezone/timezone.dart' as tz;
import 'package:pickup/Functions/liveMaps.dart';

const double CameraZoom = 16;
const double CameraTilt = 80;
const double CameraBearing = 30;
const LatLng _utdCoordinates =
    const LatLng(32.9864, -96.7497); // UTD coordinates
const LatLng _AngelsChickenCoordinates = const LatLng(32.9773, -96.8688);
const LatLng _k1Coor = const LatLng(32.985268524958364, -96.743522617005110);
//const LatLng _testingCenter = const LatLng(32.99501937800667, -96.75300623747732);
const LatLng _frankFordDriver =
    const LatLng(32.99803688995854, -96.75790995771933);

class DirectionsMap extends StatefulWidget {
  @override
  _DirectionsMapState createState() => _DirectionsMapState();
}

class _DirectionsMapState extends State<DirectionsMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  //late BitmapDescriptor customIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  final apiKey2 =
      'AIzaSyBPp3mPocXX-1j7jOuxHg_us96LyClD-H8'; // Replace with your actual API key
  Location locationController = Location();
  //LatLng? currentPosition = null;
  LatLng start =  _utdCoordinates; //LatLng(33.20959810732121, -97.15278204603084);
  LatLng end = _utdCoordinates;//LatLng(33.229468522867876, -97.12743770268979);
  String searchValue = '';
  TextEditingController searchController = TextEditingController();
  //iveMap liveMaps = LiveMap();
   LatLng? currentPosition = null;

  /*LatLng? fetchLocation(){
    LatLng currentLocation;
    LocationSettings locationSettings = LocationSettings(
    accuracy: geo.LocationAccuracy.high,
    distanceFilter: 100,
  );
  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if(position != null) {
          print('${position.latitude.toString()}, ${position.longitude.toString()}');
          setState(() {
           currentLocation = LatLng(position.latitude, position.longitude);
          
        });
        return currentLocation;
        } else{
          print('Unknown');
          return null;
        }
      });
  }*/

  

  @override
  void initState() {
    super.initState();
    custommMarker();
    getLocationUpdates();
    
    //populate();
    //getCurrentLocation();
    //_startLocationUpdates();

    //start = LatLng(0, 0); //_utdCoordinates;
    //end = LatLng(0, 0); //_AngelsChickenCoordinates;
    _markers.add(Marker(
      markerId: MarkerId('Current Location'),
      position: start,
      icon: markerIcon,
      infoWindow: InfoWindow(title: 'Start'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('End'),
      position: end,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'End'),
    ));

    
    _markers.add(Marker(
      markerId: MarkerId('K1'),
      position: _k1Coor,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'K1 Speed'),
    ));
    /*_markers.add(Marker(
    markerId: MarkerId('UTD Testing Center'),
    position: _testingCenter,
    icon: BitmapDescriptor.defaultMarker,
    infoWindow: InfoWindow(title: 'UT Dallas Testing Center'),
  ));*/
    _markers.add(Marker(
      markerId: MarkerId('Frankford Drive'),
      position: _frankFordDriver,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'FrankFord Drive'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('Home'),
      position: _utdCoordinates,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'Home'),
    ));
    displayRoute(start!, end!);
    _monitorUserLocation();

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }
  @override
  void dispose(){
    super.dispose();
    displayRoute(start, end);
  }

LocationData? currentLocation;
void getCurrentLocation() async {
  Location location = Location();
  location.getLocation().then(
    (location){
      currentLocation = location;
    },
  );
  
}

  Future<void> positionCamera(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 16,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          positionCamera(currentPosition!);
        });
      }
    });
  }
BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
void custommMarker() async{
  BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(), "assets/basketball_pin.png").then((icon){
      setState(() {
        print("yo");
        markerIcon = icon;
      });
    },
    );
    print('Added custom Marker');
}
  void findGame() {
    if (start != null && end != null) {
      MarkerId markerId = MarkerId(searchValue);
      Marker? foundMarker;
      for (Marker marker in _markers) {
        if (marker.markerId.value == searchValue) {
          foundMarker = marker;
          break;
        }
      }
      if (foundMarker != null) {
        print('Found Marker: ${foundMarker.markerId}');
        LatLng markerPosition = foundMarker.position;
        print('Marker Position: $markerPosition');
        displayRoute(currentPosition!, markerPosition);
        //_controller.animateCamera(CameraUpdate.newLatLng(markerPosition));
      } else {
        print('Marker not found');
      }
    } else {
      print('Null.... try again');
    }
    setState(() {});
  }
 List<String> directions = [];
 List<dynamic> steps = [];
  Future<void> turnByTurn(LatLng start, LatLng end) async {
  final apiKey = apiKey2;
  final url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';
  final response = await http.get(Uri.parse(url));
  final Map<String, dynamic> responseData = json.decode(response.body);
  steps = responseData['routes'][0]['legs'][0]['steps'];

  print("--------------------------------");
  print(responseData);

  steps.forEach((step) {
    print(step);
    directions.add(step['html_instructions']);
  });
  
  print('Directions:');
  directions.forEach((direction) {
    print(direction);
  });
  print ('________________________________________________________________');
  directions = directions.map((direction) {
    // Remove HTML tags using RegExp
    direction = direction.replaceAll(RegExp(r'<[^>]*>'), '');
    // Remove extra spaces
    direction = direction.trim();
    return direction;
  }).toList();

  print('Directions:');
  directions.forEach((direction) {
    print(direction);
  });

}
void filterTurnData(){
   List<String> relevantDirections = directions
      .where((direction) => direction.contains("<b>") && direction.contains("</b>"))
      .toList();

  relevantDirections.forEach((direction) {
    print("flutter: $direction");
  });
}

  /*void displayLiveGame() {
    setState(() {
      populate();
    });
  }*/

  List<LatLng> polylineCoords = [];

  void displayRoute(LatLng origin, LatLng destination) async {
    print("diplaying route");
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey2,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      });
    }
    print("route displayed successfully");
    turnByTurn(origin, destination);
    print("--------------------------------");
    print(polylineCoords);
    _monitorUserLocation();
    setState(() {});
  }

  Marker CreateGameMarker(String sportType, LatLng gamePosition) {
    print('Sport type: ' + sportType);
    print('Game position: ' + gamePosition.toString());
    return Marker(
      markerId: MarkerId(sportType),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      position: gamePosition,
    );
  }

  Future<List<double>?> getCoordinates(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      final results = data['results'] as List;
      if (results.isNotEmpty) {
        final location =
            results[0]['geometry']['location'] as Map<String, dynamic>;
        return [location['lat'] as double, location['lng'] as double];
      }
    }
    return null;
  }

 
// Below are functions to try and use location upates to update directions.
void _monitorUserLocation() {
  if (isApproachingNextTurn()) {
    displayNextDirection();
    moveMarker();
  }
}
int TurnIndex = 0;
bool isApproachingNextTurn() {
  print("In bool functions");
  if (polylineCoords.isEmpty || nextTurnIndex >= polylineCoords.length) {
    return false;
  }
  double nextTurn = calculateDistance(
    currentPosition!.latitude,
    currentPosition!.longitude,
    polylineCoords[TurnIndex].latitude,
    polylineCoords[TurnIndex].longitude,
  );
  double turnThreshold = 50; // 50 meters
  print("threshold: $turnThreshold");
  return nextTurn <= turnThreshold;
}
int nextTurnIndex = 1;
void displayNextDirection() {
  String nextDirection = directions[nextTurnIndex];
  // Print or display next direction
  print('Next Direction: $nextDirection');
  nextTurnIndex++;
}

void moveMarker() {
  if (nextTurnIndex < polylineCoords.length) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'CurrentLocation');
      _markers.add(
        Marker(
          markerId: MarkerId('CurrentLocation'),
          position: polylineCoords[TurnIndex],
          icon: markerIcon,
        ),
      );
    });
    TurnIndex ++;
    nextTurnIndex ++;
  }
}


  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  double distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  print("distanceInMeters: $distanceInMeters");
  return distanceInMeters / 1000; // Convert meters to kilometers
}

void populate() async {
    List<Object?> activeGames = await Game.fetch() as List<Object?>;

    for (final game in activeGames) {
      Map<String, dynamic> uGame = game as Map<String, dynamic>;

      if (uGame["gameID"] == "bedrock") continue;
      
      try {
        setState(() {
          BitmapDescriptor iconColor = uGame["players"].length >= uGame["maxNumOfPlayers"] ? 
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed) :
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
          
          _markers.add(
            Marker(
              markerId: MarkerId(game["gameID"]),
              icon: iconColor,
              position: LatLng(
                  game["coordinates"]["latitude"], game["coordinates"]["longitude"]),
            ),
          );
        });
      } catch (e) {
        print(e);
      }
    }
}




  @override
  Widget build(BuildContext context) {
   CameraPosition initialCameraPosition = CameraPosition(
    zoom: CameraZoom,
    tilt: CameraTilt,
    bearing: CameraBearing,
    target: _utdCoordinates,
  );

  return Scaffold(
    appBar: AppBar(
      title: Text('Live Map'),
    ),
    body: currentPosition == null
        ? const Center(
            child: Text("Loading..."),
          )
        :Stack(
            children: [
              GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: false,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: {
                  Polyline(
                    polylineId: PolylineId("route"),
                    points: polylineCoords,
                    width: 6,
                  )
                },
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  populate();
                },
              ),
              Positioned(
                top: 8.0,
                left: 8.0,
                right: 8.0,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                    });
                  },
                  onSubmitted: (value) {
                    findGame(); // Call findGame when user submits the search query
                  },
                  decoration: InputDecoration(
                    hintText: 'Search By Game ID',
                  ),
                ),
              ),
            ],
          ),
  );
}
}
