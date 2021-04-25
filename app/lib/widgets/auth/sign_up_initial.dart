import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../custom_text_from_field.dart';

enum SignInPageState { SIGN_UP, SIGN_IN }

class SignUpBasicForm extends StatefulWidget {
  final void Function() onNext;

  const SignUpBasicForm({Key? key, required this.onNext}) : super(key: key);

  @override
  _SignUpBasicFormState createState() => _SignUpBasicFormState();
}

class _SignUpBasicFormState extends State<SignUpBasicForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  SignInPageState _pageState = SignInPageState.SIGN_IN;
  String? _manualUsernameError;

  static InputDecoration _getInputDecoration(
      theme, IconData icon, String hintText) {
    return InputDecoration(
        prefixIcon: Icon(icon),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(1000)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(1000)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(1000)),
        errorStyle: TextStyle(color: Colors.red),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff191919), width: 1.0),
            borderRadius: BorderRadius.circular(1000)),
        focusColor: theme.accentColor,
        hintText: hintText);
  }

  void _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      log("Logging in user");
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log("Login successful");
    } on FirebaseAuthException catch (e) {
      log(e.code);

      if(e.code == 'user-not-found') {
        setState(() {
          _manualUsernameError = "Username not found";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Log in failed")));
      }
    }
  }

  void _handleSignUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      log("Signing up user");
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final doc = FirebaseFirestore.instance.collection("users").doc(credentials.user!.uid);
      final nameParts = _nameController.text.split(" ");
      final firstName = nameParts[0];
      final lastName = nameParts[nameParts.length - 1];
      doc.set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "userId": faker.guid.guid(),
      });
      widget.onNext();
    } on FirebaseAuthException catch(e) {
      print(e.toString());
      log(e.code);
      if(e.code == 'email-already-in-use') {
        setState(() {
          _manualUsernameError = "E-Mail is already in use";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up failed")));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
                Column(
                  children: [
                    Text(
                      "Hey there!",
                      style: theme.textTheme.headline3,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text("Every treasure needs it's lock",
                        style: theme.textTheme.subtitle2),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_pageState == SignInPageState.SIGN_UP)
                        CustomTextFormField(
                          key: Key("name"),
                          decoration: _getInputDecoration(
                              theme, Icons.person, "Enter your first and last name"),
                          focusColor: theme.accentColor,
                          controller: _nameController,
                          unfocusedColor: theme.backgroundColor,
                        ),
                      if (_pageState == SignInPageState.SIGN_UP)
                        const SizedBox(height: 10),
                      CustomTextFormField(
                          key: Key("mail"),
                          decoration: _getInputDecoration(
                              theme, Icons.email_outlined, "E-Mail address").copyWith(errorText: _manualUsernameError),
                          focusColor: theme.accentColor,
                          unfocusedColor: theme.backgroundColor,
                          controller: _emailController,
                          validator: (value) {
                            return EmailValidator.validate(value)
                                ? null
                                : "Please check your mail";
                          }),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        key: Key("password"),
                        decoration:
                            _getInputDecoration(theme, Icons.lock, "Password")
                                .copyWith(
                                    suffixIcon: InkWell(
                          child: Icon(Icons.remove_red_eye_outlined),
                        )),
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.toString().length < 6) {
                            return "Password empty or too short";
                          }
                        },
                        focusColor: theme.accentColor,
                        unfocusedColor: theme.backgroundColor,
                        passwordField: true,
                      )
                    ],
                  ),
                ),
                if (_pageState == SignInPageState.SIGN_UP)
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "By signing up, you agree to ",
                        style: theme.textTheme.bodyText2),
                    TextSpan(
                        text: "Our Terms",
                        style: theme.textTheme.bodyText2
                            ?.copyWith(color: theme.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            /*TODO*/
                          })
                  ])),
                if (_pageState == SignInPageState.SIGN_UP)
                  ElevatedButton(
                    onPressed: _handleSignUp,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Sign up"),
                          SizedBox(width: 10,),
                          Icon(
                            Icons.chevron_right_sharp,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), elevation: 4),
                  ),
                if (_pageState == SignInPageState.SIGN_IN)
                  ElevatedButton(
                    onPressed: () {
                      _handleSignIn();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Sign in",
                        style: theme.textTheme.headline4
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 5),
                  ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Continue as guest",
                      style: theme.textTheme.bodyText2,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          /*TODO*/
                        })
                ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              _pageState == SignInPageState.SIGN_IN
                                  ? "Or sign in using"
                                  : "Or join using",
                              style: theme.textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              //TODO
                            },
                            child: Center(
                              child: FaIcon(FontAwesomeIcons.google),
                            ),
                            shape: CircleBorder(),
                            color: theme.accentColor,
                            textColor: theme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              //TODO
                            },
                            child: Center(
                              child: FaIcon(FontAwesomeIcons.facebook),
                            ),
                            shape: CircleBorder(),
                            color: theme.accentColor,
                            textColor: theme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              //TODO
                            },
                            child: Center(
                              child: FaIcon(FontAwesomeIcons.twitter),
                            ),
                            shape: CircleBorder(),
                            color: theme.accentColor,
                            textColor: theme.primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                if (_pageState == SignInPageState.SIGN_UP)
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Already a member? ",
                        style: theme.textTheme.bodyText2),
                    TextSpan(
                        text: "Log in",
                        style: theme.textTheme.bodyText2
                            ?.copyWith(color: theme.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _pageState = SignInPageState.SIGN_IN;
                            });
                          })
                  ])),
                if (_pageState == SignInPageState.SIGN_IN)
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "No account yet? ",
                        style: theme.textTheme.bodyText2),
                    TextSpan(
                        text: "Sign up",
                        style: theme.textTheme.bodyText2
                            ?.copyWith(color: theme.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _pageState = SignInPageState.SIGN_UP;
                            });
                          })
                  ])),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
