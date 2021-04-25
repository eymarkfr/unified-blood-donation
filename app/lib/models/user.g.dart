// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['userId'] as String,
    json['firstName'] as String,
    json['lastName'] as String,
    json['email'] as String,
    json['phoneNumber'] as String,
    json['height'] as int,
    json['weight'] as int,
    json['gender'] as String,
    json['country'] as String,
    json['zipCode'] as String,
    DateTime.parse(json['birthday'] as String),
    json['bloodGroup'] as String,
    json['xp'] as int,
    json['unitsDonated'] as int?,
    json['teamId'] as String,
    json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'height': instance.height,
      'weight': instance.weight,
      'gender': instance.gender,
      'country': instance.country,
      'zipCode': instance.zipCode,
      'birthday': instance.birthday.toIso8601String(),
      'bloodGroup': instance.bloodGroup,
      'xp': instance.xp,
      'unitsDonated': instance.unitsDonated,
      'teamId': instance.teamId,
      'imageUrl': instance.imageUrl,
    };
