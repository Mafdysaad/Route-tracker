import 'route.dart';

class RoutesModle {
	List<Route>? routes;

	RoutesModle({this.routes});

	factory RoutesModle.fromJson(Map<String, dynamic> json) => RoutesModle(
				routes: (json['routes'] as List<dynamic>?)
						?.map((e) => Route.fromJson(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'routes': routes?.map((e) => e.toJson()).toList(),
			};
}
