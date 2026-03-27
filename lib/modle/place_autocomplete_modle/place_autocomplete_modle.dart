import 'prediction.dart';

class PlaceAutocompleteModle {
	List<Prediction>? predictions;

	PlaceAutocompleteModle({this.predictions});

	factory PlaceAutocompleteModle.fromJson(Map<String, dynamic> json) {
		return PlaceAutocompleteModle(
			predictions: (json['predictions'] as List<dynamic>?)
						?.map((e) => Prediction.fromJson(e as Map<String, dynamic>))
						.toList(),
		);
	}



	Map<String, dynamic> toJson() => {
				'predictions': predictions?.map((e) => e.toJson()).toList(),
			};
}
