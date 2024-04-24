import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pickup/classes/game.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

const double CameraZoom = 16;
const double CameraTilt = 80;
const double CameraBearing = 30;
const LatLng _utdCoordinates = LatLng(32.9864, -96.7497); // UTD coordinates
const LatLng _AngelsChickenCoordinates = LatLng(32.9773, -96.8688);
const LatLng _k1Coor = LatLng(32.985268524958364, -96.743522617005110);
//const LatLng _testingCenter = const LatLng(32.99501937800667, -96.75300623747732);
const LatLng _frankFordDriver = LatLng(32.99803688995854, -96.75790995771933);

class DirectionsMap extends StatefulWidget {
  const DirectionsMap({super.key});

  @override
  _DirectionsMapState createState() => _DirectionsMapState();
}

class _DirectionsMapState extends State<DirectionsMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  //late BitmapDescriptor customIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  final apiKey2 =
      'AIzaSyBPp3mPocXX-1j7jOuxHg_us96LyClD-H8'; // Replace with your actual API key
  Location locationController = Location();
  //LatLng? currentPosition = null;
  LatLng start =
      _utdCoordinates; //LatLng(33.20959810732121, -97.15278204603084);
  LatLng end =
      _utdCoordinates; //LatLng(33.229468522867876, -97.12743770268979);
  String searchValue = '';
  TextEditingController searchController = TextEditingController();
  //iveMap liveMaps = LiveMap();
  LatLng? currentPosition;

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
      markerId: const MarkerId('Current Location'),
      position: start,
      icon: markerIcon,
      infoWindow: const InfoWindow(title: 'Start'),
    ));
    _markers.add(Marker(
      markerId: const MarkerId('End'),
      position: end,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(title: 'End'),
    ));

    _markers.add(const Marker(
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
    _markers.add(const Marker(
      markerId: MarkerId('Frankford Drive'),
      position: _frankFordDriver,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'FrankFord Drive'),
    ));
    _markers.add(const Marker(
      markerId: MarkerId('Home'),
      position: _utdCoordinates,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'Home'),
    ));
    displayRoute(start, end);
    _monitorUserLocation();

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    displayRoute(start, end);
  }

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
  }

  Future<void> positionCamera(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 16,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
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
  void custommMarker() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/basketball_pin.png")
        .then(
      (icon) {
        setState(() {
          print("yo");
          markerIcon = icon;
        });
      },
    );
    print('Added custom Marker');
  }

  LatLng markerPosition = LatLng(0, 0);
  void findGame(Map<String, dynamic> coordinates) {
    LatLng markerPosition =
        LatLng(coordinates["latitude"], coordinates["longitude"]);
    print('Marker Position: $markerPosition');
    displayRoute(currentPosition!, markerPosition);
    //_controller.animateCamera(CameraUpdate.newLatLng(markerPosition));
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

    for (var step in steps) {
      print(step);
      directions.add(step['html_instructions']);
    }

    print('Directions:');
    for (var direction in directions) {
      print(direction);
    }
    print('________________________________________________________________');
    directions = directions.map((direction) {
      // Remove HTML tags using RegExp
      direction = direction.replaceAll(RegExp(r'<[^>]*>'), '');
      // Remove extra spaces
      direction = direction.trim();
      return direction;
    }).toList();

    print('Directions:');
    for (var direction in directions) {
      print(direction);
    }
  }

  void filterTurnData() {
    List<String> relevantDirections = directions
        .where((direction) =>
            direction.contains("<b>") && direction.contains("</b>"))
        .toList();

    for (var direction in relevantDirections) {
      print("flutter: $direction");
    }
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
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
    }
    print("route displayed successfully");
    turnByTurn(origin, destination);
    print("--------------------------------");
    print(polylineCoords);
    _monitorUserLocation();
    displayTurnByTurn();
    setState(() {});
  }

  Marker CreateGameMarker(String sportType, LatLng gamePosition) {
    print('Sport type: $sportType');
    print('Game position: $gamePosition');
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
        _markers.removeWhere(
            (marker) => marker.markerId.value == 'CurrentLocation');
        _markers.add(
          Marker(
            markerId: const MarkerId('CurrentLocation'),
            position: polylineCoords[TurnIndex],
            icon: markerIcon,
          ),
        );
      });
      TurnIndex++;
      nextTurnIndex++;
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
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
          BitmapDescriptor iconColor = uGame["players"].length >=
                  uGame["maxNumOfPlayers"]
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet);

          _markers.add(
            Marker(
              markerId: MarkerId(game["gameID"]),
              icon: iconColor,
              position: LatLng(game["coordinates"]["latitude"],
                  game["coordinates"]["longitude"]),
            ),
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void displayTurnByTurn() {
    String direction =
        directions[1]; // Assuming directions is an array of strings
    print("--------------------------------");
    print(direction);
    setState(() {
      Positioned(
        top: 8.0,
        left: 8.0,
        right: 8.0,
        child: Container(
          padding:
              EdgeInsets.all(8.0), // Add padding for spacing inside the box
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black), // Add border for the box
            borderRadius: BorderRadius.circular(8.0), // Add rounded corners
          ),
          child: TextField(
            controller: TextEditingController(
                text:
                    direction), // Use a TextEditingController to set initial text
            readOnly: true, // Make the text field read-only
          ),
        ),
      );
    });
  }

  void _showFinishGameDialog(BuildContext context) {
    String? result;
    TextEditingController team1Controller = TextEditingController();
    TextEditingController team2Controller = TextEditingController();

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(
              255, 221, 219, 219), // Set background color to very light grey
          title: Text('Did you win or lose?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: result,
                onChanged: (String? value) {
                  setState(() {
                    result = value;
                  });
                },
                items: <String>['Win', 'Lose'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Result',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: team1Controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Team 1 Score',
                      ),
                    ),
                  ),
                  Text(' - '),
                  Expanded(
                    child: TextField(
                      controller: team2Controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Team 2 Score',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Process the result and scores here
                // For now, just print them
                if (result != null) {
                  print('Result: $result');
                  print('Team 1 Score: ${team1Controller.text}');
                  print('Team 2 Score: ${team2Controller.text}');
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? coordinates =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("Fetched coordinates $coordinates");
    CameraPosition initialCameraPosition = const CameraPosition(
      zoom: CameraZoom,
      tilt: CameraTilt,
      bearing: CameraBearing,
      target: _utdCoordinates,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Map'),
      ),
      body: currentPosition == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(
              children: [
                GoogleMap(
                  myLocationButtonEnabled: true,
                  compassEnabled: false,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoords,
                      width: 6,
                    )
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    populate();
                    findGame(coordinates!);
                    displayRoute(currentPosition!, markerPosition);
                  },
                ),
                Positioned(
                  bottom: 16.0, // Adjust this value as needed
                  left: 16.0, // Adjust this value as needed
                  child: FloatingActionButton(
                    onPressed: () {
                      _showFinishGameDialog(context);
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
    );
  }
}
