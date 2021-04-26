import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/views/bloodbank_details.dart';
import 'package:ubd/widgets/blood_badge.dart';

import 'appointment_booker.dart';

class BloodBankListItem extends StatefulWidget {
  final BloodBank bloodBank;
  final LatLng? currentLocation;
  final void Function(BloodBank)? moveTo;

  const BloodBankListItem({Key? key, required this.bloodBank, required this.currentLocation, this.moveTo}) : super(key: key);

  @override
  _BloodBankListItemState createState() => _BloodBankListItemState();
}

class _BloodBankListItemState extends State<BloodBankListItem> {

  Widget _getHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.bloodBank.name, style: Theme.of(context).textTheme.headline5,),
          Row(
            children: [
              Icon(Icons.share_outlined, color: Colors.black38),
              Icon(Icons.more_vert_sharp, color: Colors.black38)
            ],
          )
        ],
      ),
    );
  }
  Widget _getBottomRow() {
    const buttonTextStyle = TextStyle(fontWeight: FontWeight.bold);
    final distance = widget.currentLocation != null ? widget.bloodBank.distanceMiles(widget.currentLocation!).toStringAsFixed(1) : " - ";
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              widget.moveTo?.call(widget.bloodBank);
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.near_me_outlined),
                  const SizedBox(width: 5,),
                  Text("$distance Miles", style: buttonTextStyle,)
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  builder: (context){
                    return AppointmentBooker(bloodBank: widget.bloodBank,);
                  },
                  isDismissible: true,
                  backgroundColor: Colors.transparent
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/droplet.png"),
                  const SizedBox(width: 5,),
                  Text("Donate", style: buttonTextStyle.copyWith(color: Theme.of(context).primaryColor))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _getCenterContent() {
    List<Widget> badges = [];
    widget.bloodBank.bloodNeeds.forEach((element) {
      if(element.item2 == BloodUrgency.URGENT) {
        badges.add(BloodBadge(bloodType: element.item1, isUrgent: true));
      }
    });
    widget.bloodBank.bloodNeeds.forEach((element) {
      if(element.item2 == BloodUrgency.NEEDED) {
        badges.add(BloodBadge(bloodType: element.item1, isUrgent: false));
      }
    });
    if(badges.isEmpty) {
      return SizedBox(height: 40,);
    }
    return Row(
      children: [
        Expanded(
            child: Column(
              children: badges,
            )
        ),
        Expanded(
            child: Column(
              children: [

              ],
            )
        )
      ],
    );
  }

  void _showDetailsView() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => BloodBankDetails(bloodBank: widget.bloodBank),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.bloodBank.hasUrgent() ? EdgeInsets.only(top: 10) : EdgeInsets.all(0),
      child: Stack(
        children: [
          InkWell(
            onTap: _showDetailsView,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      _getHeader(),
                      _getCenterContent(),
                      _getBottomRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if(widget.bloodBank.hasUrgent()) Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 30,
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Theme.of(context).primaryColor),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Urgent", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  SizedBox(width: 5,),
                  Image.asset("assets/icons/medical.png")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
