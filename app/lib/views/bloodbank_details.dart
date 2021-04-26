import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/models/user.dart';
import 'package:ubd/utils.dart';
import 'package:ubd/widgets/bloodbank_info.dart';
import 'package:ubd/widgets/opening_hours.dart';
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
    final textTheme = Theme.of(context).textTheme;
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
                        imageUrl: null,
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

class AppointmentBooker extends StatefulWidget {
  
  final BloodBank bloodBank;

  const AppointmentBooker({Key? key, required this.bloodBank}) : super(key: key);
  
  
  @override
  _AppointmentBookerState createState() => _AppointmentBookerState();
}

class _AppointmentBookerState extends State<AppointmentBooker> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  int _selectedTimeIndex = 0;
  bool _showConfirm = false;
  
  Map<String, OpeningHourDayEntry> _hours = {
    "tuesday": OpeningHourDayEntry([OpeningHourEntry(TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 11, minute: 30))])
  };

  void _addAppointment(DateTime date, BloodBank bloodBank) {
    final docRef = getUserDocument();
    docRef?.update({
      "appointments": FieldValue.arrayUnion([{
        "date": date.toIso8601String(),
        "bloodBank": {
          "name": bloodBank.name,
          "location": [bloodBank.location.latitude, bloodBank.location.longitude],
          "id": bloodBank.id,
          "imageUrl": bloodBank.imageUrl,
        }
      }])
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Appointment booked"))
    );
    Navigator.pop(context);
  }

  void _handleSelect(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  List<TimeOfDay> _getAllowedTimes(OpeningHourDayEntry dayEntry) {
    List<TimeOfDay> result = [];

    for(var e in dayEntry.entries) {
      for(var t = e.startTime; timeOfDayToDouble(t) < timeOfDayToDouble(e.endTime); t = addMinutesToTimeOfDay(t, 15)) {
        result.add(t);
      }
    }

    return result;
  }

  void _updateTimeIndex(int diff, int limit) {
    int newIndex = _selectedTimeIndex + diff;
    if(newIndex < 0) {
      newIndex = 0;
    }
    if(newIndex > limit) {
      newIndex = limit;
    }

    if(newIndex == _selectedTimeIndex) return;
    setState(() {
      _selectedTimeIndex = newIndex;
    });
  }

  Widget _getTimePicker(OpeningHourDayEntry dayEntry) {
    final validTimes = _getAllowedTimes(dayEntry);
    _selectedTime = validTimes[_selectedTimeIndex];
    return Container(
      width: MediaQuery.of(context).size.width*0.75,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Choose a time", style: Theme.of(context).textTheme.headline5,),
                const SizedBox(height: 15,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(onTap: ()=>_updateTimeIndex(-1, validTimes.length-1),child: Icon(Icons.remove_circle_outline)),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          child: Center(child: Text(_selectedTime!.format(context), style: Theme.of(context).textTheme.headline5,))
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    InkWell(onTap: ()=>_updateTimeIndex(1, validTimes.length-1), child: Icon(Icons.add_circle_outline))
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    _showConfirm = true;
                  });
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Book"),
                    Icon(Icons.chevron_right_sharp)
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
  
  Widget _confirmBooking() {
    final theme = Theme.of(context);
    final pickedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime!.hour, _selectedTime!.minute);
    
    return Column(
      children: [
        Text("Confirm your booking", style: theme.textTheme.headline5?.copyWith(color: theme.primaryColor),),
        const SizedBox(width: 50,),
        Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.bloodBank.name, style: theme.textTheme.headline4),
                const SizedBox(height: 20,),
                Text(DateFormat("E, d. MMMM y - hh:mm").format(pickedDate), style: theme.textTheme.headline4)
              ],
            )
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000))),
                onPressed: (){
                  setState(() {
                    _showConfirm = false;
                  });
                },
                child: Text("Cancel"),
              ),
            ),
            const SizedBox(width: 40,),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000))),
                  onPressed: () {
                    _addAppointment(pickedDate, widget.bloodBank);
                  },
                  child: Text("Confirm")
              ),
            )
          ],
        ),
        const SizedBox(width: 30,),
      ],
    );
  }
  
  Widget _appointmentChooser() {
    final theme = Theme.of(context);
    final now = DateTime.now();

    var dayEntry = _hours[WEEK_DAYS[_selectedDate.weekday-1].toLowerCase()];
    
    return Column(
      children: [
        Text("Choose your appointment date", style: theme.textTheme.headline5?.copyWith(color: theme.primaryColor),),
        const SizedBox(width: 20,),
        TableCalendar(
          focusedDay: _selectedDate,
          firstDay: now,
          lastDay: now.add(Duration(days: 6*30)),
          calendarFormat: CalendarFormat.week,
          onDaySelected: _handleSelect,
          selectedDayPredicate: (day) {
            return isSameDay(day, _selectedDate);
          },
          enabledDayPredicate: (day) {
            final weekDay = WEEK_DAYS[day.weekday-1];
            return _hours[weekDay.toLowerCase()] != null;
          },
        ),
        const SizedBox(height: 20,),
        if(dayEntry != null) Expanded(
            child: _getTimePicker(dayEntry)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: _showConfirm ? _confirmBooking() : _appointmentChooser(),
    );
  }
}

