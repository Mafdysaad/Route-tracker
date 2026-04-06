import 'polyline.dart';

class RoutesModle {
	int? distanceMeters;
	String? duration;
	Polyline? polyline;

	RoutesModle({this.distanceMeters, this.duration, this.polyline});

	factory RoutesModle.fromJson(Map<String, dynamic> json) => RoutesModle(
				distanceMeters: json['distanceMeters'] as int?,
				duration: json['duration'] as String?,
				polyline: json['polyline'] == null
						? null
						: Polyline.fromJson(json['polyline'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toJson() => {
				'distanceMeters': distanceMeters,
				'duration': duration,
				'polyline': polyline?.toJson(),
			};
}
