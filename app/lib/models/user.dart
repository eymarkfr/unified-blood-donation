import 'package:ubd/utils.dart';

const GENDERS = [
  "male",
  "female",
  "other"
];

class User {
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

  User(this.firstName, this.lastName, this.email, this.phoneNumber, this.height, this.weight, this.gender, this.country, this.zipCode, this.birthday, this.bloodGroup, this.xp) {
    assert(isValidBloodType(this.bloodGroup));
    assert(GENDERS.contains(this.gender));
  }

  bool isDonor(String bloodTypeRecipient) {
    return isValidDonor(bloodTypeRecipient, this.bloodGroup);
  }

}