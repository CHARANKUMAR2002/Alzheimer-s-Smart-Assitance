import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Locate extends StatefulWidget {
  const Locate({super.key, required this.currentUser});
  final currentUser;

  @override
  State<Locate> createState() => _LocateState();
}

class _LocateState extends State<Locate> {

  Location location = new Location();
  late LocationData _locationData;
  double lat = 0.0;
  double lon = 0.0;
  LatLng? currentPos = null;

  Future<void> _cameraToPos(LatLng pos) async
      {
        final GoogleMapController controller = await _controller.future;
        CameraPosition _newCameraPos = CameraPosition(target: pos, zoom: 19.151926040649414);
        await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPos));
      }



  getLocation() async
  {
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
    print("${currentLocation.latitude}, ${currentLocation.longitude}");
    setState(() {
      currentPos = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _cameraToPos(currentPos!);
    });
});
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.4219983, -122.084),
      zoom: 19.151926040649414
      );

      
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPos == null ? Center(child: CircularProgressIndicator()) : GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kLake,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(markerId: MarkerId('_currentLocation'), icon: BitmapDescriptor.defaultMarker, position: currentPos!,)
        },
      )
    );
  }
}