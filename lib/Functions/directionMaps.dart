import 'dart:async';
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

  late bool servicePermission = false;
  Position? _currentLocation;
  late LocationPermission permission;
  Future<Position> getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print('Service is not enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    //populate();
    //getCurrentLocation();
    //_startLocationUpdates();

    //start = LatLng(0, 0); //_utdCoordinates;
    //end = LatLng(0, 0); //_AngelsChickenCoordinates;
    _markers.add(Marker(
      markerId: MarkerId('start'),
      position: start,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'Start'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('End'),
      position: end,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'End'),
    ));

    _markers.add(Marker(
      markerId: MarkerId('UTD'),
      position: _utdCoordinates,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: 'UT Dallas'),
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
        displayRoute(_utdCoordinates, markerPosition);
        //_controller.animateCamera(CameraUpdate.newLatLng(markerPosition));
      } else {
        print('Marker not found');
      }
    } else {
      print('Null.... try again');
    }
    setState(() {});
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
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      });
    }
    print("route displayed successfully");
    setState(() {});
  }

  /*void populate() async {
    List<Map<String, dynamic>> activeGames =
        (await Game.fetch()) as List<Map<String, dynamic>>;
    print(activeGames);

    for (final game in activeGames) {
      try {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(game["sport"]),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
              position: LatLng(
                  game["location"]["latitude"], game["location"]["longitude"]),
            ),
          );
        });
      } catch (e) {
        print(gam)
        print(e);
      }
    }
  }*/

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

  Future<void> positionCamera(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
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
      body: Stack(
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
              //displayLiveGame();
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
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _currentLocation = await getCurrentLocation();
          print("${_currentLocation}");
        },
        child: Icon(Icons.my_location),
      ),*/
    );
  }
}
