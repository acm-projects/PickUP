import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pickup/classes/game.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


const double CameraZoom = 16;
const double CameraTilt = 80;
const double CameraBearing = 30;
const LatLng _utdCoordinates = LatLng(32.9864, -96.7497); // UTD coordinates
const LatLng _AngelsChickenCoordinates = LatLng(32.9773, -96.8688);

class LiveMap extends StatefulWidget {
  const LiveMap({super.key});

  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
    // Call function to load custom icon
    _createCustomMarkerFromAsset(context);
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
      appBar: AppBar(
        title: const Text('Live Map'),
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                displayLiveGame(); // Call the function to display markers
              },
              onTap: _onMapTapped, // Add onTap handler
            ),
          ],
        ),
      ),
    );
  }

  // Handler for when the map is tapped
  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: "Tapped Location",
            snippet: "Latitude: ${tappedPoint.latitude}, Longitude: ${tappedPoint.longitude}",
          ),
        ),
      );
    });
  }

  Future<List<double>?> getCoordinates(String address) async {
    const apiKey = 'AIzaSyBPp3mPocXX-1j7jOuxHg_us96LyClD-H8'; // Replace with your actual API key
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      // Parse the JSON response
      final results = data['results'] as List;
      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'] as Map<String, dynamic>;
        return [location['lat'] as double, location['lng'] as double];
      }
    }
    return null;
  }

  void _createCustomMarkerFromAsset(BuildContext context) async {
    
  }

  Marker CreateGameMarker(String sportType, LatLng gamePosition) {
    Marker mk = Marker(
      markerId: MarkerId(sportType),
      icon: BitmapDescriptor.defaultMarker,
      position: gamePosition,
    );

    return mk;
  }

  void populate() async {
    List<Map<String, dynamic>> activeGames =
        (await Game.fetch()) as List<Map<String, dynamic>>;

    for (final game in activeGames) {
      _markers.add(
        CreateGameMarker(game["sport"],
            LatLng(game["location"]["latitude"], game["location"]["longitude"])),
      );
    }
  }

  void displayLiveGame() {
    setState(() {
      populate();
    });
  }
}

// for n in games: display game type ( MarkerID), posiion ( game Coordinates)
