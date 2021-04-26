import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:ubd/models/user.dart';

class BasicUserProfile extends StatefulWidget {
  final UserProfile user;
  const BasicUserProfile({Key? key, required this.user}) : super(key: key);
  @override
  _BasicUserProfileState createState() => _BasicUserProfileState();
}

class _BasicUserProfileState extends State<BasicUserProfile> {
  final _formKey = GlobalKey<FormState>();

  String? _firstName;
  String? _lastName;
  DateTime? _birthDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: widget.user.firstName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'First name', labelText: 'First name'),
                  onChanged: (value) {
                    _firstName = value;
                  },
                ),
                TextFormField(
                    initialValue: widget.user.lastName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Last name', labelText: 'Last name'),
                    onChanged: (value) {
                      _lastName = value;
                    }),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: DatePickerWidget(
                        firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                        lastDate: DateTime.now(),
                        dateFormat: "dd-MMMM-yyyy",
                        initialDate: widget.user.birthday.toLocal(),
                        onChange: (date, _) {
                          _birthDay = date;
                        },
                        pickerTheme: DateTimePickerTheme(
                            dividerColor: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final userDoc = getUserDocument();
                        if (userDoc == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Failed to save changes. Please retry later!")));
                        }
                        String? birthDay = _birthDay?.toIso8601String();
                        if (birthDay == null) {
                          birthDay = widget.user.birthday.toIso8601String();
                        }
                        userDoc?.update({
                          "firstName": _firstName ?? widget.user.firstName,
                          "lastName": _lastName ?? widget.user.lastName,
                          "birthday": birthDay
                        });
                      },
                      child: Text('Save'),
                    ))
              ],
            ),
          )),
    );
  }
}
