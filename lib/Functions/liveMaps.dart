import 'dart:async';
import 'package:flutter/material.dart';
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

import 'package:timezone/timezone.dart' as tz;

const double CameraZoom = 17;
const double CameraTilt = 80;
const double CameraBearing = 30;
const LatLng _utdCoordinates =
    const LatLng(32.9864, -96.7497); // UTD coordinates
const LatLng _AngelsChickenCoordinates = const LatLng(32.9773, -96.8688);
const LatLng _k1Coor = const LatLng(32.985268524958364, -96.743522617005110);

class LiveMap extends StatefulWidget {
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  //late BitmapDescriptor customIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  final apiKey2 =
      'AIzaSyBPp3mPocXX-1j7jOuxHg_us96LyClD-H8'; // Replace with your actual API key
  Location locationController = Location();
  LatLng? currentPosition = null;
  LatLng? start = null;
  LatLng? end = null;

  @override
  void initState() {
    super.initState();
    //populate();
    getLocationUpdates();
    //displayRoute(start, end);
    // Call function to load custom icon
    //_createCustomMarkerFromAsset(context);
    // Add the following code to enable Hybrid Composition mode
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
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
            ):
          Container(
        child: Stack(
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
                //displayLiveGame(); // Call the function to display markers
                populate();
              },
              onTap: _onMapTapped, // Add onTap handler
              onLongPress: onMarkerTapped,
            ),
            ElevatedButton(
              child: const Text('Confirm location!'),
              onPressed: () async {
                await Game.currentGame.instantiate();
              },
            )
          ],
        ),
      ),
    );
  }

  static final Polyline drawPoly = Polyline(
    polylineId: PolylineId("Directions"),
    points: [_utdCoordinates, _k1Coor],
  );
  // Handler for when the map is tapped
  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      Game.currentGame.location = {
        "latitude": tappedPoint.latitude,
        "longitude": tappedPoint.longitude,
      };
      
      _markers.add(
        Marker(
          markerId: MarkerId(Game.currentGame.gameID),
          position: tappedPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: "Tapped Location",
            snippet:
                "Latitude: ${tappedPoint.latitude}, Longitude: ${tappedPoint.longitude}",
          ),
        ),
      );
      /*if (_markers.length == 2) {
        // Draw polyline when there are two markers
        drawPolylines();
      }*/

      userl.Location.latitude = tappedPoint.latitude;
      userl.Location.longitude = tappedPoint.longitude;
    });
  }

  /*Future<void> _drawPolylines() async {
    Marker startMarker = _markers.elementAt(0);
    Marker endMarker = _markers.elementAt(1);

    var url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startMarker.position.latitude},${startMarker.position.longitude}&destination=${endMarker.position.latitude},${endMarker.position.longitude}&key=apikey2";
    
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      List<LatLng> points = [];

      data['routes'][0]['legs'][0]['steps'].forEach((step) {
        points.add(LatLng(step['start_location']['lat'], step['start_location']['lng']));
        points.add(LatLng(step['end_location']['lat'], step['end_location']['lng']));
      });

      setState(() {
        polylineCoordinates = points;
        polylines.add(
          Polyline(
            polylineId: PolylineId("poly"),
            color: Colors.blue,
            points: polylineCoordinates,
            width: 3,
          ),
        );
      });
    }
  }*/

  Future<List<double>?> getCoordinates(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      // Parse the JSON response
      final results = data['results'] as List;
      if (results.isNotEmpty) {
        final location =
            results[0]['geometry']['location'] as Map<String, dynamic>;
        return [location['lat'] as double, location['lng'] as double];
      }
    }
    return null;
  }

  /*void _createCustomMarkerFromAsset(BuildContext context) async {
    if (customIcon == null) {
      ImageConfiguration configuration = ImageConfiguration();
      BitmapDescriptor.fromAssetImage(
          configuration, 'assets/basketball_pin.png').then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }*/

  Marker CreateGameMarker(String sportType, LatLng gamePosition) {
    Marker mk = new Marker(
      markerId: MarkerId(sportType),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      position: gamePosition,
    );

    return mk;
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
                  game["location"]["latitude"], game["location"]["longitude"]),
            ),
          );
        });
      } catch (e) {
        print(e);
      }
    }

    print(_markers);
  }

  

  void displayLiveGame() {
    setState(() {
      populate();
    });
  }

  void onMarkerTapped(LatLng tappedMarkerPosition) {
    if (currentPosition != null) {
      // Draw polyline
      displayRoute(_utdCoordinates, tappedMarkerPosition);
    }
  }

  List<LatLng> polylineCoords = [];

  void displayRoute(LatLng origin, LatLng destination) async {
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
    setState(() {});
  }

  void _drawPolyline(LatLng from, LatLng to) {
    setState(() {
      polylines.add(
        Polyline(
          polylineId: PolylineId('polyLine'),
          color: Colors.blue,
          points: [from, to],
          width: 3, // Adjust polyline width as needed
        ),
      );
    });
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
      zoom: CameraZoom,
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
        _markers.removeWhere((marker) => marker.markerId.value == 'Home');
        _markers.add(Marker(
          markerId: MarkerId('Home'),
          position: currentPosition!,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Home'),
        ));
      });
    }
  });
}
}
