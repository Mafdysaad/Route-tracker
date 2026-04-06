class LatLngModle {
  double? latitude;
  double? longitude;

  LatLngModle({this.latitude, this.longitude});

  factory LatLngModle.fromJson(Map<String, dynamic> json) => LatLngModle(
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
