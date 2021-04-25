import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:ubd/constants.dart';
import 'package:ubd/models/user.dart';
import 'package:ubd/widgets/auth/sign_up_initial.dart';

enum SIGN_UP_STATE {
  FORM,
  BIRTHDAY,
  LOCATION,
  BLOOD_GROUP
}

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {

  SIGN_UP_STATE _signUpState = SIGN_UP_STATE.FORM;
  final _zipController = TextEditingController();

  final initialCountry = "US";
  final initialDate = DateTime(1990, 1, 1);

  String _bloodType = "A-";
  DateTime? _selectedDate;
  String? _selectedCountry;
  String? _zipCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = initialDate;
  }

  void _onNext() {
    SIGN_UP_STATE nextState = SIGN_UP_STATE.FORM;
    switch(_signUpState) {
      case SIGN_UP_STATE.FORM:
        nextState = SIGN_UP_STATE.BIRTHDAY;
        break;
      case SIGN_UP_STATE.BIRTHDAY:
        nextState = SIGN_UP_STATE.LOCATION;
        break;
      case SIGN_UP_STATE.LOCATION:
        nextState = SIGN_UP_STATE.BLOOD_GROUP;
        break;
      case SIGN_UP_STATE.BLOOD_GROUP:
        // TODO: Handle this case.
        break;
    }

    setState(() {
      _signUpState = nextState;
    });
  }

  double _getProgress(SIGN_UP_STATE signUpState) {
    switch(signUpState) {
      case SIGN_UP_STATE.FORM: return 0.0;
      case SIGN_UP_STATE.BIRTHDAY: return 0.25;
      case SIGN_UP_STATE.LOCATION: return 0.5;
      case SIGN_UP_STATE.BLOOD_GROUP: return 0.75;
    }
  }
  
  Widget _getInnerContent(SIGN_UP_STATE signUpState) {
    final theme = Theme.of(context);
    switch(signUpState) {
      case SIGN_UP_STATE.FORM:
        // This should not happen
        return Container();
      case SIGN_UP_STATE.BIRTHDAY:
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Image.asset("assets/images/progress_bday.png"),
                Expanded(child: Image.asset("assets/images/bday.png")),
                SizedBox(height: 15,),
                Text("When is your birthday?", style: theme.textTheme.headline3?.copyWith(color: theme.primaryColor)),
                SizedBox(height: 5,),
                Text("Please enter your birthday", style: theme.textTheme.subtitle2,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: DatePickerWidget(
                    firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                    lastDate: DateTime.now(),
                    initialDate: initialDate,
                    dateFormat: "dd-MMMM-yyyy",
                    onChange: (date, _) {
                      _selectedDate = date;
                    },
                    pickerTheme: DateTimePickerTheme(dividerColor: Theme.of(context).primaryColor),
                  ),
                ),
                MaterialButton(
                  onPressed: (){
                    final userDoc = getUserDocument();
                    if(userDoc == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to set birthday. Please set from settings"))
                      );
                    }
                    userDoc?.update({"birthday": _selectedDate});
                    _onNext();
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.chevron_right_sharp, size: 30,),
                    ),
                  ),
                  shape: CircleBorder(),
                  color: theme.primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      case SIGN_UP_STATE.LOCATION:
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Image.asset("assets/images/progress_zip.png"),
                Expanded(child: Image.asset("assets/images/zip.png")),
                SizedBox(height: 15,),
                Text("Where are you from?", style: theme.textTheme.headline3?.copyWith(color: theme.primaryColor)),
                SizedBox(height: 5,),
                Text("This helps us to locate the nearest blood center", style: theme.textTheme.subtitle2,),
                CountryCodePicker(
                  initialSelection: 'US',
                  showCountryOnly: true,
                  showDropDownButton: true,
                  showOnlyCountryWhenClosed: true,
                  onChanged: (code) {
                    _selectedCountry = code.code;
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: TextFormField(
                    controller: _zipController,
                    decoration: InputDecoration(
                      hintText: "Enter your ZIP code",
                      labelText: "ZIP code",
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20,),
                MaterialButton(
                  onPressed: (){
                    final userDoc = getUserDocument();
                    if(userDoc == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to set country and zip code. Please set from settings"))
                      );
                    }
                    _zipCode = _zipController.text;
                    userDoc?.update({
                      "country": _selectedCountry,
                      "zipCode": _zipCode,
                    });
                    _onNext();
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.chevron_right_sharp, size: 30,),
                    ),
                  ),
                  shape: CircleBorder(),
                  color: theme.primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      case SIGN_UP_STATE.BLOOD_GROUP:
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Image.asset("assets/images/progress_bloodgroup.png"),
                Expanded(child: Image.asset("assets/images/bg.png")),
                SizedBox(height: 15,),
                Text("What's your blood group?", style: theme.textTheme.headline3?.copyWith(color: theme.primaryColor)),
                SizedBox(height: 5,),
                Text("Choose your blood group", style: theme.textTheme.subtitle2,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: 100,
                    child: CupertinoPicker.builder(
                      selectionOverlay: Container(
                        decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: theme.primaryColor, width: 2.0))),
                      ),
                      itemExtent: 30,
                      squeeze: 0.95,
                      diameterRatio: 2.0,
                      magnification: 1.3,
                      onSelectedItemChanged: (int item){
                        _bloodType = BLOOD_TYPES[item];
                      },
                      childCount: BLOOD_TYPES.length,
                      itemBuilder: (context, index){
                        return Center(child: Text(BLOOD_TYPES[index]));
                      },
                    )
                  ),
                ),
                MaterialButton(
                  onPressed: (){
                    final userDoc = getUserDocument();
                    if(userDoc == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to set country and zip code. Please set from settings"))
                      );
                    }
                    _zipCode = _zipController.text;
                    userDoc?.update({
                      "bloodGroup": _bloodType,
                    });
                    _onNext();
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.chevron_right_sharp, size: 30,),
                    ),
                  ),
                  shape: CircleBorder(),
                  color: theme.primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _getBody(SIGN_UP_STATE signUpState, ThemeData theme) {
    if(signUpState == SIGN_UP_STATE.FORM) {
      return SignUpBasicForm(onNext: _onNext,);
    }
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: LinearProgressIndicator(
                value: _getProgress(signUpState),
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                backgroundColor: theme.accentColor,
              ),
            ),
            Expanded(child: _getInnerContent(signUpState)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                  height: MediaQuery.of(context).size.height,
                  child: _getBody(_signUpState, theme))
          )
      ),
    );
  }
}
