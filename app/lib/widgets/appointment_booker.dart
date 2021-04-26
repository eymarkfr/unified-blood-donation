
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ubd/models/blood_bank.dart';
import 'package:ubd/models/user.dart';

import '../utils.dart';
import 'opening_hours.dart';

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

