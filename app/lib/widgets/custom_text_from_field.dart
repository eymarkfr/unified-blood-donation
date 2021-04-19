import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final InputDecoration decoration;
  final Color focusColor;
  final Color unfocusedColor;

  const CustomTextFormField({Key key, this.decoration, this.focusColor, this.unfocusedColor}) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  Color _color;
  FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    _color = widget.unfocusedColor;
    _textFieldFocus.addListener((){
      if(_textFieldFocus.hasFocus){
        setState(() {
          _color = widget.focusColor;
        });
      }else{
        setState(() {
          _color = widget.unfocusedColor;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var decoration = InputDecoration(...widget.decoration, fillColor: _color);
    return TextFormField(
      decoration: decoration,
      focusNode: _textFieldFocus,
    );
  }
}
