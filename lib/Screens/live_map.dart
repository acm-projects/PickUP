import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:pickup/classes/location.dart' as userl;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

const double CameraZoom = 17;
const double CameraTilt = 80;
const double CameraBearing = 30;
const LatLng _utdCoordinates = LatLng(32.9864, -96.7497); // UTD coordinates
const LatLng _AngelsChickenCoordinates = LatLng(32.9773, -96.8688);
const LatLng _k1Coor = LatLng(32.985268524958364, -96.743522617005110);

class LiveMap extends StatefulWidget {
  const LiveMap({super.key});

  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  //late BitmapDescriptor customIcon;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  final apiKey2 =
      'AIzaSyBPp3mPocXX-1j7jOuxHg_us96LyClD-H8'; // Replace with your actual API key
  Location locationController = Location();
  LatLng? currentPosition;
  LatLng? start;
  LatLng? end;

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
    CameraPosition initialCameraPosition = const CameraPosition(
      zoom: CameraZoom,
      tilt: CameraTilt,
      bearing: CameraBearing,
      target: _utdCoordinates,
    );

    return Scaffold(
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
                    'Live Map',
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
      body: Container(
        child: Stack(
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
                //displayLiveGame(); // Call the function to display markers
                populate();
              },
              onTap: _onMapTapped, // Add onTap handler
              onLongPress: onMarkerTapped,
            ),
          ],
        ),
      ),
    );
  }

  static const Polyline drawPoly = Polyline(
    polylineId: PolylineId("Directions"),
    points: [_utdCoordinates, _k1Coor],
  );
  // Handler for when the map is tapped
  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      Game.currentGame.coordinates = {
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
    Marker mk = Marker(
      markerId: MarkerId(sportType),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      position: gamePosition,
    );

    return mk;
  }

  void populate() async {
    Timer.periodic(const Duration(milliseconds: 5000), (_) async {
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
    });
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
      for (var point in result.points) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
  }

  void _drawPolyline(LatLng from, LatLng to) {
    setState(() {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('polyLine'),
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
      (location) {
        currentLocation = location;
      },
    );
  }

  Future<void> positionCamera(LatLng pos) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: CameraZoom,
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
          _markers.removeWhere((marker) => marker.markerId.value == 'Home');
          _markers.add(Marker(
            markerId: const MarkerId('Home'),
            position: currentPosition!,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: 'Home'),
          ));
        });
      }
    });
  }
}
