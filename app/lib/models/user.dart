import 'dart:math';

import 'package:faker/faker.dart';
import 'package:ubd/constants.dart';
import 'package:ubd/utils.dart';
import 'package:ubd/utils/random_date.dart';

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

  User(this.userId, this.firstName, this.lastName, this.email, this.phoneNumber, this.height, this.weight, this.gender, this.country, this.zipCode, this.birthday, this.bloodGroup, this.xp, this.unitsDonated, this.teamId, this.imageUrl) {
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