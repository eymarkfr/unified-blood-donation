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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000))),
                      onPressed: () async {
                        final userDoc = getUserDocument();
                        if (userDoc == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Failed to save changes. Please retry later!")));
                        }
                        Map<String, dynamic> updateDoc = {};
                        if(_firstName != null && _firstName != widget.user.firstName) updateDoc['firstName'] = _firstName;
                        if(_lastName != null && _lastName != widget.user.lastName) updateDoc['lastName'] = _lastName;
                        if(_birthDay != null && _birthDay != widget.user.birthday) updateDoc['birthday'] = _birthDay!.toIso8601String();

                        if(updateDoc.isEmpty) {
                          Navigator.of(context).pop();
                          return;
                        }

                        try {
                          await userDoc?.update(updateDoc);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Information updated"))
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to update information"))
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text('Save', style: TextStyle(fontSize: 20),),
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
