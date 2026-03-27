import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:route_tracker_pro/modle/place_autocomplete_modle/place_autocomplete_modle.dart';

class Googlemapplacesservices {
  final String baseurl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?";
  final String apikey = '--------------------------------';

  Future<List<PlaceAutocompleteModle>> autocomplete({
    required String input,
  }) async {
    var respons = await http.get(
      Uri.parse('${baseurl}input=$input&key=$apikey'),
    );
    if (respons.statusCode == 200) {
      var data = jsonDecode(respons.body)["predictions"];
      List<PlaceAutocompleteModle> places = [];
      for (var item in data) {
        places.add(PlaceAutocompleteModle.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }
}
