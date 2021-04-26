import 'dart:math';

import 'package:faker/faker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:ubd/constants.dart';
import 'package:ubd/models/custom_latlng_converter.dart';
import 'package:ubd/models/custom_tuple_converter.dart';
import 'package:ubd/utils.dart';
part 'blood_bank.g.dart';

enum BloodUrgency {
  @JsonValue("not_needed") NOT_NEEDED,
  @JsonValue("needed") NEEDED,
  @JsonValue("urgent") URGENT
}

String _urgencyToJSON(BloodUrgency u) {
  switch(u) {
    case BloodUrgency.NOT_NEEDED:
      return "not_needed";
    case BloodUrgency.NEEDED:
      return "needed";
    case BloodUrgency.URGENT:
      return "urgent";
  }
}

BloodUrgency _urgencyFromString(String s) {
  switch(s) {
    case "not_needed": return BloodUrgency.NOT_NEEDED;
    case "needed": return BloodUrgency.NEEDED;
    case "urgent": return BloodUrgency.URGENT;
    default: return BloodUrgency.NOT_NEEDED;
  }
}

class UrgencyEntry extends Tuple2<String, BloodUrgency> {
  UrgencyEntry(String item1, BloodUrgency item2) : super(item1, item2);
}
class EntryConverter implements JsonConverter<UrgencyEntry, List> {
  const EntryConverter();

  @override
  UrgencyEntry fromJson(List<dynamic> json) {
    return UrgencyEntry(json[0], _urgencyFromString(json[1]));
  }

  @override
  List toJson(UrgencyEntry object) {
    return [object.item1, _urgencyToJSON(object.item2)];
  }

}

@JsonSerializable()
@LatLngConverter()
@EntryConverter()
class BloodBank {
  final String id;
  final String name;
  final LatLng location;
  final String? imageUrl;

  final List<UrgencyEntry> bloodNeeds;

  BloodBank(this.id, this.name, this.location, this.bloodNeeds, this.imageUrl);

  factory BloodBank.fromJson(Map<String, dynamic> json) => _$BloodBankFromJson(json);
  Map<String, dynamic> toJson() => _$BloodBankToJson(this);


  bool hasUrgent() {
    for(var entry in bloodNeeds) {
      if(entry.item2 == BloodUrgency.URGENT) {
        return true;
      }
    }
    return false;
  }

  double distance(LatLng? other) {
    if(other == null) return 0;
    return computeDistanceKm(location, other);
  }

  double distanceMiles(LatLng? other) {
    return kmToMiles(distance(other));
  }
}

BloodUrgency _randomUrgency(Random random) {
  final value = random.nextDouble();
  if(value < 0.6) {
    return BloodUrgency.NOT_NEEDED;
  }
  if(value < 0.9) {
    return BloodUrgency.NEEDED;
  }
  return BloodUrgency.URGENT;
}

List<BloodBank> createDummyBloodBank(LatLng location, int n) {
    List<BloodBank> entries = [];
    final lat = location.latitude;
    final lng = location.longitude;
    final random = Random();

    for(var i = 0; i < n; ++i) {
      final name = faker.company.name();
      final location = LatLng(lat + random.nextDouble()*0.2 - 0.1, lng + random.nextDouble()*0.2 - 0.1);
      final needs = BLOOD_TYPES.sublist(1).map((e) => UrgencyEntry(e, _randomUrgency(random)));

      entries.add(BloodBank(faker.guid.guid(), name, location, needs.toList(), faker.image.image(width: 400, height: 400, random: true)));
    }

    return entries;
}