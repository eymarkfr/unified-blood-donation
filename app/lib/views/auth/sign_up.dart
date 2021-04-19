import 'package:flutter/material.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {

  final _formKey = GlobalKey<FormState>();

  static InputDecoration _getInputDecoration(theme, IconData icon, String hintText) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff191919), width: 1.0),
        borderRadius: BorderRadius.circular(1000)
      ),
      focusColor: theme.accentColor,
      hintText: hintText
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              Text("Hey there!", style: theme.textTheme.headline3,),
              SizedBox(height:20),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: _getInputDecoration(theme, Icons.email_outlined, "E-Mail address"),

                      ),
                      SizedBox(height:10),
                      TextFormField(
                          decoration: _getInputDecoration(theme, Icons.phone, "Phone number")
                      )
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
