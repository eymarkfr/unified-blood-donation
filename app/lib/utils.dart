import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart';
import 'package:ubd/constants.dart';

extension GoogleMapsExtensions on LocationData {
  LatLng toLatLng() {
    return LatLng(this.latitude ?? 0, this.longitude ?? 0);
  }
}

double computeDistanceKm(LatLng p1, LatLng p2) {
  const radius = 6371; //km
  final dLat = deg2rad(p2.latitude - p1.latitude);
  final dLon = deg2rad(p2.longitude - p2.longitude);
  final a = sin(dLat*0.5) * sin(dLat * 0.5)
      + cos(deg2rad(p1.latitude)) * cos(deg2rad(p2.latitude))
          * sin(dLon * 0.5) * sin(dLon * 0.5);
  final c = 2 * atan2(sqrt(a), sqrt(1-a));
  return radius * c;
}

double deg2rad(double deg) {
  return deg * pi / 180.0;
}

double kmToMiles(double km) {
  return km*0.621371;
}

double milesToKm(double miles) {
  return miles*1.60934;
}

bool getRhFromBloodType(final String bloodType) {
  return bloodType.endsWith("+");
}

String getBloodGroupWithoutRh(final String bloodType) {
  return bloodType.substring(0, bloodType.length-1);
}

bool isValidDonor(final String bloodGroupRecipient, final String bloodGroupDonor) {
  final rhRecipient = getRhFromBloodType(bloodGroupRecipient);
  final rhDonor = getRhFromBloodType(bloodGroupDonor);

  // rh positive can't donate to rh negative
  if(rhDonor && !rhRecipient) {
    return false;
  }

  final bgDonor = getBloodGroupWithoutRh(bloodGroupDonor);
  final bgRecipient = getBloodGroupWithoutRh(bloodGroupRecipient);

  // universal donor
  if(bgDonor == "0") return true;
  // AB can receive anything
  if(bgRecipient == "AB") return true;
  // otherwise the blood type must be the same
  if(bgDonor == bgRecipient) return true;
  return false;
}

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

