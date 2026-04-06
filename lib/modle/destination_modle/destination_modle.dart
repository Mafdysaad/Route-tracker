import 'lat_lng.dart';

class DestinationModle {
  LatLngModle? latLng;

  DestinationModle({required this.latLng});

  factory DestinationModle.fromJson(Map<String, dynamic> json) {
    return DestinationModle(
      latLng: json['latLng'] == null
          ? null
          : LatLngModle.fromJson(json['latLng'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'latLng': latLng?.toJson()};
}
