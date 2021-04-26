import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubd/constants.dart';
import 'package:ubd/utils.dart';
import 'package:ubd/utils/random_date.dart';
import 'package:json_annotation/json_annotation.dart';
import 'blood_bank.dart';
part 'user.g.dart';

const GENDERS = [
  "male",
  "female",
  "other"
];

@JsonSerializable()
class UserProfile {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phoneNumber;

  final int? height;
  final int? weight;
  final String? gender;

  final String country;
  final String zipCode;
  final DateTime birthday;
  final String bloodGroup;

  final int? xp;
  final int? unitsDonated;
  final String? teamId;
  final String? imageUrl;
  final List<DonationHistoryItem> donationHistory;

  UserProfile(this.userId, this.firstName, this.lastName, this.email, this.phoneNumber, this.height, this.weight, this.gender, this.country, this.zipCode, this.birthday, this.bloodGroup, this.xp, this.unitsDonated, this.teamId, this.imageUrl, [List<DonationHistoryItem>? history]) : this.donationHistory = history ?? [] {
    assert(isValidBloodType(this.bloodGroup));
    assert(gender == null || GENDERS.contains(this.gender));
    assert(unitsDonated == null || unitsDonated! >= 0);
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  String initials() {
    if(lastName == null || firstName == null) return "";
    return "${firstName![0]}${lastName![0]}";
  }

  String heightFormatted() {
    if(height == null) {
      return "not set";
    }
    return "$height cm";
  }

  String weightFormatted() {
    if(weight == null) {
      return "not set";
    }
    return "$weight kg";
  }

  String bmiFormatted() {
    final v = bmi();
    if(v == null) return "not available";
    String bmiSuffix = "Underweight";
    if(v < 24.9) {
      bmiSuffix = "Normal";
    } else if(v < 29.9) {
      bmiSuffix = "Overweight";
    } else {
      bmiSuffix = "Obese";
    }
    return "${v.toStringAsFixed(1)} ($bmiSuffix)";
  }

  bool isDonor(String bloodTypeRecipient) {
    return isValidDonor(bloodTypeRecipient, this.bloodGroup);
  }

  double? bmi() {
    if(weight == null || height == null) return null;
    return weight! / (height!*height!) * 1e4;
  }

  int getAge() {
    return getAgeFromDates(birthday, null);
  }

  List<DonationHistoryItem> getRandomHistroyForDemo(int n) {
    final randDate = RandomDate();
    List<BloodBank> banks = createDummyBloodBank(LatLng(0, 0), n);
    List<DateTime> dates = List<DateTime>.generate(n, (index) => randDate.generateRandomDate(2019, 2021));
    dates.sort();

    return List<DonationHistoryItem>.generate(n, (index) => DonationHistoryItem(banks[index], dates[index]));
  }
}

DocumentReference? getUserDocument() {
  final user = FirebaseAuth.instance.currentUser;
  if(user == null) {
    return null;
  }
  return FirebaseFirestore.instance.collection("users").doc(user.uid);
}

Future<UserProfile?> getUserProfile() async {
  final docRef = getUserDocument();
  if(docRef == null) {
    return null;
  }
  final doc = await docRef.get();
  return UserProfile.fromJson(doc.data()!);
}

class DonationHistoryItem {
  final BloodBank bloodBank;
  final DateTime date;

  DonationHistoryItem(this.bloodBank, this.date);
}

String randomBloodType() {
  return BLOOD_TYPES[Random().nextInt(BLOOD_TYPES.length)];
}

List<UserProfile> generateRandomUsers(int n) {
  final faker = Faker();
  final rand = Random();
  return List<UserProfile>.generate(n, (index) {
    return UserProfile(
      faker.guid.guid(),
      faker.person.firstName(),
      faker.person.lastName(),
      faker.internet.email(),
      faker.phoneNumber.us(),
      rand.nextInt(30) + 160,
      rand.nextInt(40) + 50,
      "female",
      "us",
      "94016",
      RandomDate().generateRandomDate(1955, 2002),
      randomBloodType(),
      rand.nextInt(5000),
      rand.nextInt(20),
      faker.guid.guid(),
      faker.image.image(width: 100, height: 100, keywords: ['person'], random: true)
    );
  });
}