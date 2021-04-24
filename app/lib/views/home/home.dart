import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ubd/models/blood_bank.dart';

import 'package:ubd/utils.dart';

class HomeView extends StatefulWidget {
  final void Function(List<BloodBank>, LatLng?) showBloodBanks;

  const HomeView({Key? key, required this.showBloodBanks}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Completer<GoogleMapController> _controller = Completer();

  Location _location = Location();
  LocationData? _locationData;
  List<BloodBank> _nearbyBloodBanks = [];
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  void _createMarker(List<BloodBank> bloodBanks) {
    Map<MarkerId, Marker> newMarkers = <MarkerId, Marker>{};
    bloodBanks.forEach((element) {
      final marker = Marker(
        markerId: MarkerId(element.id),
        position: element.location,
        infoWindow: InfoWindow(title: "Test")
      );
      newMarkers[marker.markerId] = marker;
    });

    setState(() {
      _markers.addAll(newMarkers);
    });
  }

  void locationSetup() async {
    var serviceEnabled = await _location.serviceEnabled();
    if(!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if(!serviceEnabled) return;
    }

    var permissionsGranted = await _location.hasPermission();
    if(permissionsGranted == PermissionStatus.denied) {
      permissionsGranted = await _location.requestPermission();
      if(permissionsGranted == PermissionStatus.denied) {
        return;
      }
    }

    final locData = await _location.getLocation();
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(locData.toLatLng(), 10));
    final bloodBanks = createDummyBloodBank(locData.toLatLng(), 20);
    _createMarker(bloodBanks);
    widget.showBloodBanks(bloodBanks, locData.toLatLng());
    setState(() {
      _locationData = locData;
      _nearbyBloodBanks = bloodBanks;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_locationData == null) {
      locationSetup();
    }
    final userName = "Emilie";
    return Container(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(0,0)),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white70, Colors.white12],
                  stops: [0.6, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Container()),
                        Expanded(child: Text("Hey, $userName!", style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center,)),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(alignment: Alignment.centerRight, child: Icon(Icons.search_sharp),),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
