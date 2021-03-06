import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/widgets/appointment_booker.dart';
import 'package:ubd/widgets/bloodbank_info.dart';
import 'package:ubd/widgets/safe_image.dart';

class BloodBankDetails extends StatefulWidget {
  final BloodBank bloodBank;

  const BloodBankDetails({Key? key, required this.bloodBank}) : super(key: key);

  @override
  _BloodBankDetailsState createState() => _BloodBankDetailsState();
}

class _BloodBankDetailsState extends State<BloodBankDetails> {
  Completer<GoogleMapController> _controller = Completer();

  Widget _getTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Text(
        widget.bloodBank.name,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  Widget _getHeaderRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipOval(
                      child: SafeUrlImage(
                        placeholderAsset: "assets/images/bb_placeholder.jpg",
                        imageUrl: widget.bloodBank.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )),
          ),
            )),
          SizedBox(width: 5,),
          Expanded(
            flex: 2,
            child: BloodBankInfo(bloodBank: widget.bloodBank,)
          )
        ],
      ),
    );
  }

  void _pickTimeSlot() {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return AppointmentBooker(bloodBank: widget.bloodBank,);
        },
      isDismissible: true,
      backgroundColor: Colors.transparent
    );
  }

  Widget _bookAppointment() {
    return ElevatedButton(
      onPressed: _pickTimeSlot,
      child: Text("Book an appointment"),
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
    );
  }

  Widget _getMap() {
    final markerId = MarkerId(widget.bloodBank.id);
    final Map<MarkerId, Marker> markers = <MarkerId, Marker>{
      markerId: Marker(markerId: markerId, position: widget.bloodBank.location)
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 0.3 * MediaQuery.of(context).size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: widget.bloodBank.location, zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                _getTitle(),
                _getHeaderRow(),
                const SizedBox(
                  height: 20,
                ),
                _getMap(),
                const SizedBox(
                  height: 20,
                ),
                _bookAppointment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
