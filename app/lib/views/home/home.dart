import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/models/user.dart';

import 'package:ubd/utils.dart';
import 'package:ubd/widgets/blood_bank_card.dart';

class HomeView extends StatefulWidget {
  final void Function(PersistentBottomSheetController? controller) setSheetController;
  final User? user;

  const HomeView({Key? key, required this.setSheetController, this.user}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Completer<GoogleMapController> _controller = Completer();
  PersistentBottomSheetController? _bottomSheetController;

  Location _location = Location();
  LocationData? _locationData;
  List<BloodBank> _nearbyBloodBanks = [];
  String _title = "";
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  void _createMarker(List<BloodBank> bloodBanks) {
    Map<MarkerId, Marker> newMarkers = <MarkerId, Marker>{};
    bloodBanks.forEach((element) {
      final marker = Marker(
        markerId: MarkerId(element.id),
        position: element.location,
        infoWindow: InfoWindow(title: element.name)
      );
      newMarkers[marker.markerId] = marker;
    });

    setState(() {
      _markers.addAll(newMarkers);
    });
  }

  Widget? _getBottomSheet(List<BloodBank> bloodBanks, LatLng location) {
    if(bloodBanks.isNotEmpty) {
      return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.25,
          minChildSize: 0.1,
          builder: (context, scrollController) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: ListView.builder(
                    itemCount: bloodBanks.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return BloodBankListItem(bloodBank: bloodBanks[index], currentLocation: location, moveTo: (bb) async {
                        final mapController = await _controller.future;
                        mapController.animateCamera(CameraUpdate.newLatLngZoom(bb.location, 14));
                        mapController.showMarkerInfoWindow(MarkerId(bb.id));
                        _bottomSheetController?.close();
                      },);
                    }
                )
            );
          }
      );
    }

    return null; //Container(height: 0,);
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

    setState(() {
      _locationData = locData;
      _nearbyBloodBanks = bloodBanks;
      _showBloodBankSheet();
    });
  }

  void _showBloodBankSheet() async {
    final locData = await _location.getLocation();
    if(_nearbyBloodBanks.isNotEmpty) {
      _bottomSheetController = showBottomSheet(
          context: context,
          builder: (context) =>
          _getBottomSheet(_nearbyBloodBanks, locData.toLatLng()) ?? Container()
      );
      widget.setSheetController(_bottomSheetController);
    }
  }

  void _getTitle() async {
    final doc = getUserDocument();
    String title = "";
    if(doc == null) {
      title = "Hey there!";
    } else {
      final values = await doc.get();
      final firstName = values.data()!["firstName"];
      title = "Hey, $firstName!";
    }

    setState(() {
      _title = title;
    });
  }

  @override
  void initState() {
    _getTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_locationData == null) {
      locationSetup();
    }
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
                        Expanded(child: Text(_title, style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center,)),
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 60),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: (){
                  _showBloodBankSheet();
                },
                child: Icon(Icons.list, color: Theme.of(context).primaryColor,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
