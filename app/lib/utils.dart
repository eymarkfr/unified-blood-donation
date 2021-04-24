import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ubd/constants.dart';

bool isValidBloodType(String bloodType) {
  return BLOOD_TYPES.contains(bloodType);
}

int getAgeFromDates(DateTime birthday, DateTime? date) {
  date = date ?? DateTime.now();
  return Jiffy(date).diff(birthday, Units.YEAR).toInt();
}

int getLevelFromXP(int xp) {
  // TODO this is just a dummy implementation
  return 3;
}

double getLevelProgress(int xp) {
  // TODO just a dummy
  final level = getLevelFromXP(xp);
  return 0.4;
}

int getXPUntilNextLevel(int xp) {
  // TODO
  return 2200;
}

LinearGradient getLevelProgressColor(int level) {
  return LinearGradient(colors: [Colors.lightBlueAccent, Colors.blue]);
}

Image getLevelIcon(int level, double? height, double? width) {
  // TODO just a dummy
  return Image.asset("assets/icons/icon_level3.png", fit: BoxFit.fill, height: height, width: width,);
}

