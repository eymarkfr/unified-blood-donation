import 'dart:math';

import 'package:faker/faker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubd/constants.dart';
import 'package:ubd/utils.dart';
import 'package:ubd/utils/random_date.dart';

import 'blood_bank.dart';

const GENDERS = [
  "male",
  "female",
  "other"
];

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  final int height;
  final int weight;
  final String gender;

  final String country;
  final String zipCode;
  final DateTime birthday;
  final String bloodGroup;

  final int xp;
  final int? unitsDonated;
  final String teamId;
  final String imageUrl;
  final List<DonationHistoryItem> donationHistory;

  User(this.userId, this.firstName, this.lastName, this.email, this.phoneNumber, this.height, this.weight, this.gender, this.country, this.zipCode, this.birthday, this.bloodGroup, this.xp, this.unitsDonated, this.teamId, this.imageUrl, [List<DonationHistoryItem>? history]) : this.donationHistory = history ?? [] {
    assert(isValidBloodType(this.bloodGroup));
    assert(GENDERS.contains(this.gender));
    assert(unitsDonated == null || unitsDonated! >= 0);
  }

  bool isDonor(String bloodTypeRecipient) {
    return isValidDonor(bloodTypeRecipient, this.bloodGroup);
  }

  double bmi() {
    return weight / (height*height);
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

class DonationHistoryItem {
  final BloodBank bloodBank;
  final DateTime date;

  DonationHistoryItem(this.bloodBank, this.date);
}

String randomBloodType() {
  return BLOOD_TYPES[Random().nextInt(BLOOD_TYPES.length)];
}

List<User> generateRandomUsers(int n) {
  final faker = Faker();
  final rand = Random();
  return List<User>.generate(n, (index) {
    return User(
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