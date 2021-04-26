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
                    _height = int.tryParse(value) ?? -1;
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
                      _weight = int.tryParse(value) ?? -1;
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
                      onPressed: () {
                        final userDoc = getUserDocument();
                        if (userDoc == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Failed to save changes. Please retry later!")));
                        }

                        int height = -1;
                        if (_height == -1 || _height == null) {
                          height = widget.user.height ?? -1;
                        } else {
                          height = _height!;
                        }

                        int weight = -1;
                        if (_weight == -1 || _weight == null) {
                          weight = widget.user.weight ?? -1;
                        } else {
                          weight = _weight!;
                        }

                        String bloodGroup = widget.user.bloodGroup;
                        if (_bloodGroup == null) {
                          bloodGroup = widget.user.bloodGroup;
                        } else {
                          bloodGroup = _bloodGroup!;
                        }
                        userDoc?.update({
                          "height": height,
                          "weight": weight,
                          "bloodGroup": bloodGroup
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
