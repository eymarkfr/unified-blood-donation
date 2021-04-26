// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BloodBank _$BloodBankFromJson(Map<String, dynamic> json) {
  return BloodBank(
    json['id'] as String,
    json['name'] as String,
    const LatLngConverter().fromJson(json['location'] as List<double>),
    (json['bloodNeeds'] as List<dynamic>)
        .map((e) => const EntryConverter().fromJson(e as List))
        .toList(),
    json['imageUrl'] as String?,
    json['city'] as String,
    json['zipCode'] as String,
    json['street'] as String,
    json['country'] as String,
    json['url'] as String?,
  );
}

Map<String, dynamic> _$BloodBankToJson(BloodBank instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': const LatLngConverter().toJson(instance.location),
      'imageUrl': instance.imageUrl,
      'url': instance.url,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'street': instance.street,
      'country': instance.country,
      'bloodNeeds':
          instance.bloodNeeds.map(const EntryConverter().toJson).toList(),
    };
