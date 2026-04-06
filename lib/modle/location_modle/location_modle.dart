import 'lat_lng.dart';

class LocationModle {
  LatLngmodl? latLng;

  LocationModle({required this.latLng});

  factory LocationModle.fromJson(Map<String, dynamic> json) => LocationModle(
    latLng: json['latland'] == null
        ? null
        : LatLngmodl.fromJson(json['latLng'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {'latLng': latLng?.toJson()};
}
