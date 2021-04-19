import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ubd/widgets/custom_text_from_field.dart';

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
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(1000)
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
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/icons/blood_drop_auth.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hey there!", style: theme.textTheme.headline3,),
                  Text("Every treasure needs it's lock", style: theme.textTheme.subtitle2),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            decoration: _getInputDecoration(theme, Icons.email_outlined, "E-Mail address"),
                            focusColor: theme.accentColor,
                            unfocusedColor: theme.backgroundColor,
                          ),
                          SizedBox(height:10),
                          CustomTextFormField(
                            decoration: _getInputDecoration(theme, Icons.phone, "Phone number"),
                            focusColor: theme.accentColor,
                            unfocusedColor: theme.backgroundColor,
                          ),
                          SizedBox(height:10),
                          CustomTextFormField(
                            decoration: _getInputDecoration(theme, Icons.lock, "Password")
                                .copyWith(suffixIcon: InkWell(child: Icon(Icons.remove_red_eye_outlined),)),
                            focusColor: theme.accentColor,
                            unfocusedColor: theme.backgroundColor,
                            passwordField: true,
                          )
                        ],
                      ),
                  ),
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By signing up, you agree to ",
                        style: theme.textTheme.bodyText2
                      ),
                      TextSpan(
                        text: "Our Terms",
                        style: theme.textTheme.bodyText2?.copyWith(color: theme.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (){/*TODO*/}
                      )
                    ]
                  )),
                  MaterialButton(
                    onPressed: (){
                      //TODO
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
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Continue as guest",
                            style: theme.textTheme.bodyText2,
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){/*TODO*/}
                        )
                      ]
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Or join using",
                                style: theme.textTheme.bodyText2,
                                textAlign: TextAlign.center,)
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: (){
                                  //TODO
                                },
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.google),
                                ),
                                shape: CircleBorder(),
                                color: theme.primaryColor,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: (){
                                  //TODO
                                },
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.facebook),
                                ),
                                shape: CircleBorder(),
                                color: theme.primaryColor,
                                textColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: (){
                                  //TODO
                                },
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.twitter),
                                ),
                                shape: CircleBorder(),
                                color: theme.primaryColor,
                                textColor: Colors.white,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Already a member? ",
                            style: theme.textTheme.bodyText2
                        ),
                        TextSpan(
                            text: "Log in",
                            style: theme.textTheme.bodyText2?.copyWith(color: theme.primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){/*TODO*/}
                        )
                      ]
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
