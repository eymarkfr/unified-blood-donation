import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubd/models/user.dart';

import '../constants.dart';

class MedicalUserProfile extends StatefulWidget {
  final UserProfile user;
  const MedicalUserProfile({Key? key, required this.user}) : super(key: key);
  @override
  _MedicalUserProfileState createState() => _MedicalUserProfileState();
}

class _MedicalUserProfileState extends State<MedicalUserProfile> {
  final _formKey = GlobalKey<FormState>();

  int? _height;
  int? _weight;
  String? _bloodGroup;

  @override
  void initState() {
    _height = widget.user.height;
    _weight = widget.user.weight;
    _bloodGroup = widget.user.bloodGroup;
    super.initState();
  }

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
                  keyboardType: TextInputType.number,
                  initialValue: widget.user.height.toString(),
                  validator: (input) {
                    final isDigitsOnly = int.tryParse(input ?? '');
                    return isDigitsOnly == null
                        ? 'Input needs to be digits only'
                        : null;
                  },
                  decoration:
                      InputDecoration(hintText: 'Height', labelText: 'Height'),
                  onChanged: (value) {
                    _height = int.tryParse(value);
                  },
                ),
                TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.user.weight.toString(),
                    validator: (input) {
                      final isDigitsOnly = int.tryParse(input ?? '');
                      return isDigitsOnly == null
                          ? 'Input needs to be digits only'
                          : null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Weight', labelText: 'Weight'),
                    onChanged: (value) {
                      _weight = int.tryParse(value);
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 100,
                      child: CupertinoPicker.builder(
                        selectionOverlay: Container(
                          decoration: BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2.0))),
                        ),
                        itemExtent: 30,
                        squeeze: 0.95,
                        diameterRatio: 2.0,
                        magnification: 1.3,
                        onSelectedItemChanged: (int item) {
                          _bloodGroup = BLOOD_TYPES[item];
                        },
                        scrollController: FixedExtentScrollController(
                            initialItem: BLOOD_TYPES.indexWhere((bloodgroup) =>
                                widget.user.bloodGroup == bloodgroup)),
                        childCount: BLOOD_TYPES.length,
                        itemBuilder: (context, index) {
                          return Center(child: Text(BLOOD_TYPES[index]));
                        },
                      )),
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
                        if(_height != null && _height != widget.user.height) {
                          updateDoc["height"] = _height;
                        }
                        if(_weight != null && _weight != widget.user.weight) {
                          updateDoc['weight'] = _weight;
                        }
                        if(_bloodGroup != null && _bloodGroup != widget.user.bloodGroup) {
                          updateDoc['bloodGroup'] = _bloodGroup;
                        }

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
