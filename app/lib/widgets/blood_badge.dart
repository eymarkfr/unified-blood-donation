import 'package:flutter/material.dart';

class BloodBadge extends StatelessWidget {

  final String bloodType;
  final bool isUrgent;

  const BloodBadge({Key? key, required this.bloodType, required this.isUrgent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(color: isUrgent ? Color(0xffFCBE00) : Color(0xffFFF8D6), borderRadius: BorderRadius.circular(100)),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Blood needed: ", style: TextStyle(color: Colors.black)),
            TextSpan(text: bloodType, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
          ]
        ),
      )
    );
  }
}
