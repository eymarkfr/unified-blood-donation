import 'dart:math';

import 'package:faker/faker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:ubd/constants.dart';
import 'package:ubd/utils.dart';

enum BloodUrgency {
  NOT_NEEDED,
  NEEDED,
  URGENT
}

class BloodBank {
  final String id;
  final String name;
  final LatLng location;

  final List<Tuple2<String, BloodUrgency>> bloodNeeds;

  BloodBank(this.id, this.name, this.location, this.bloodNeeds);

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
      final needs = BLOOD_TYPES.map((e) => Tuple2(e, _randomUrgency(random)));

      entries.add(BloodBank(faker.guid.guid(), name, location, needs.toList()));
    }

    return entries;
}