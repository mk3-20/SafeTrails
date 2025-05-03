import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../global_data.dart';

class HomeMap extends StatefulWidget {
  final Set<Marker> markers;
  final void Function(GoogleMapController) onMapCreated;
  const HomeMap({super.key, required this.markers, required this.onMapCreated});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  late GoogleMapController _googleMapController;
  bool _isLoading = true;

  void _onMapCreated(GoogleMapController controller){
    _googleMapController = controller;
    GoogleMapHelper.getCurrentLocation().then((curLoc) {
      print("GOTTTT CURRENT LOCATION! now animating to it");
      setState(() {
        _isLoading = false;
      });
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: curLoc, zoom: 19)));
    });
    widget.onMapCreated(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(target: LatLng(20.5937, 78.9629),zoom: 4),
          markers: widget.markers,
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          zoomControlsEnabled: false,
          trafficEnabled: true,
          mapToolbarEnabled: false,
          onMapCreated: _onMapCreated,
        ),
        if(_isLoading ) Positioned(left: 20,top: 20,child: CircularProgressIndicator(color: Colors.yellow.shade700,))
      ],
    );
  }
}