import 'package:flutter/material.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/widgets/opening_hours.dart';

class BloodBankInfo extends StatefulWidget {
  final BloodBank bloodBank;

  const BloodBankInfo({Key? key, required this.bloodBank}) : super(key: key);

  @override
  _BloodBankInfoState createState() => _BloodBankInfoState();
}

class _BloodBankInfoState extends State<BloodBankInfo> {
  final double _spacer = 10.0;

  var _expandHours = false;

  Map<String, OpeningHourDayEntry> _hours = {
    "monday": OpeningHourDayEntry([OpeningHourEntry(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 11, minute: 30))])
  };

  Widget _addressRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor,),
        SizedBox(width: _spacer,),
        Expanded(child: Text("Paul-Feyerabend-Hof 1, 8049 Zurich, Switzerland", maxLines: 100,))
      ],
    );
  }

  Widget _openingHours(Map<String, OpeningHourDayEntry?> hours) {
    final dayOfWeek = DateTime.now().weekday;
    final dayName = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][dayOfWeek];
    final open = isOpen(hours);

    String title = "";
    if(open) {
      title = "Open now";
    } else {
      title = "Closed";
    }

    if(!_expandHours) {
      return InkWell(
        onTap: ()=>setState(()=>_expandHours=true),
        child: Row(
          children: [
            Icon(Icons.access_time_outlined, color: Theme.of(context).primaryColor),
            SizedBox(width: _spacer,),
            Expanded(child: Text(title)),
            Icon(Icons.arrow_drop_down_outlined),
          ],
        ),
      );
    }

    return InkWell(
      onTap: ()=>setState(()=>_expandHours=false),
      child: Row(
        children: [
          Icon(Icons.access_time_outlined, color: Theme.of(context).primaryColor),
          SizedBox(width: _spacer,),
          Expanded(child: OpeningHours(hours: _hours)),
          Icon(Icons.arrow_drop_up_outlined),
        ],
      ),
    );
  }

  Widget _homepageRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.public_outlined, color: Theme.of(context).primaryColor,),
        SizedBox(width: _spacer,),
        Expanded(child: Text("www.icrc.org", maxLines: 100,))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _addressRow(),
          const Divider(),
          _openingHours(_hours),
          const Divider(),
          _homepageRow()
        ],
      ),
    );
  }
}
