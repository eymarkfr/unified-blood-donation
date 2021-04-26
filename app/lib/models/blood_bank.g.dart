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
  );
}

Map<String, dynamic> _$BloodBankToJson(BloodBank instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': const LatLngConverter().toJson(instance.location),
      'imageUrl': instance.imageUrl,
      'bloodNeeds':
          instance.bloodNeeds.map(const EntryConverter().toJson).toList(),
    };
