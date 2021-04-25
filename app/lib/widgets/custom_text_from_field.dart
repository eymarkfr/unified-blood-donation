import 'dart:developer';

import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final InputDecoration decoration;
  final Color? focusColor;
  final Color? unfocusedColor;
  final bool? passwordField;
  final FormFieldValidator? validator;
  final TextEditingController? controller;

  const CustomTextFormField({
    Key? key,
    required this.decoration,
    this.focusColor,
    this.unfocusedColor,
    this.passwordField,
    this.validator,
    this.controller
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  Color? _color;
  bool _obscureText = true;
  FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    _color = widget.unfocusedColor;
    _obscureText = widget.passwordField ?? false;

    _textFieldFocus.addListener((){
      if(_textFieldFocus.hasFocus){
        setState(() {
          _color = widget.focusColor;
        });
      } else {
        setState(() {
          _color = widget.unfocusedColor;
        });
      }
    });
    super.initState();
  }

  Widget? _getToggleObscureWidget() {
    if(!(widget.passwordField ?? false)) return null;
    return InkWell(
      onTap: ()=>setState(() {
        _obscureText = !_obscureText;
      }),
      child: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
    );
  }

  @override
  Widget build(BuildContext context) {
    var decoration = widget.decoration.copyWith(
      fillColor: _color,
      filled: true,
      suffixIcon: _getToggleObscureWidget()
    );
    return TextFormField(
      decoration: decoration,
      focusNode: _textFieldFocus,
      obscureText: _obscureText,
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}
