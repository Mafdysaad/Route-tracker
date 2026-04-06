class LatLngmodl {
  double? latitude;
  double? longitude;

  LatLngmodl({this.latitude, this.longitude});

  factory LatLngmodl.fromJson(Map<String, dynamic> json) => LatLngmodl(
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
