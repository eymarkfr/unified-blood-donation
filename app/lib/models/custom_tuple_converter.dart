import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';

class Tuple2Converter<T1, T2> implements JsonConverter<Tuple2<T1, T2>, List> {
  const Tuple2Converter();

  @override
  Tuple2<T1, T2> fromJson(List<dynamic> json) {
    return Tuple2(json[0] as T1, json[1] as T2);
  }

  @override
  List toJson(Tuple2<T1, T2> object) {
    return [object.item1, object.item2];
  }

}