import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
const double CameraZoom = 16;
const double CameraTilt = 80;
const double CameraBearing = 30;
const LatLng _utdCoordinates = const LatLng(32.9864, -96.7497); // UTD coordinates
const LatLng _AngelsChickenCoordinates = const LatLng(32.9773, -96.7688);

class LiveMap extends StatefulWidget {
  @override
  _LiveMapState createState() => _LiveMapState();
}
class _LiveMapState extends State<LiveMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
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
      body: Container(
        child: GoogleMap(
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
        ),
      ),
    );
  }

  void _createCustomMarkerFromAsset(BuildContext context) async {
    if (customIcon == null) {
      ImageConfiguration configuration = ImageConfiguration();
      BitmapDescriptor.fromAssetImage(
        configuration, 'assets/basketball_pin.png')
        .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  void displayLiveGame() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("UT Dallas"),
          icon: customIcon,
          position: _utdCoordinates,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("Angels Chicken"),
          icon: BitmapDescriptor.defaultMarker,
          position: _AngelsChickenCoordinates,
        ),
      );
    });
  }
}
