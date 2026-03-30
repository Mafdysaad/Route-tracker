import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:route_tracker_pro/modle/opitiones_modle/opitiones_modle.dart';
import 'package:route_tracker_pro/modle/place_datils_modle/place_datils_modle.dart';

import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/modle/routes_modle/routes_modle.dart';

class Googlemapplacesservices {
  final String baseurl = "https://maps.googleapis.com/maps/api/place";
  final String routesUrl =
      "https://routes.googleapis.com/directions/v2:computeRoutes";
  final String apikey = "--------------------------";

  Future<List<PlacesModle>> predictionesPlacesEndpoint({
    required String input,
  }) async {
    var respons = await http.get(
      Uri.parse('$baseurl/autocomplete/json?input=$input&key=$apikey'),
    );
    if (respons.statusCode == 200) {
      var data = jsonDecode(respons.body)['predictions'];
      List<PlacesModle> places = [];
      for (var item in data) {
        places.add(PlacesModle.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDatilsModle> placesDatilsEndpoint({
    required String placeID,
  }) async {
    var respons = await http.get(
      Uri.parse('$baseurl/details/json?place_id=$placeID&key=$apikey'),
    );
    if (respons.statusCode == 200) {
      var data = PlaceDatilsModle.fromJson(jsonDecode(respons.body)["result"]);
      return data;
    } else {
      throw Exception();
    }
  }

  Future<RoutesModle> routesEndpoint(OpitionesModle opitionesmodle) async {
    var respons = await http.post(
      Uri.parse(routesUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apikey,
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
      },
      body: {opitionesmodle.toJson()},
    );
    if (respons.statusCode == 200) {
      RoutesModle data = RoutesModle.fromJson(
        jsonDecode(respons.body)["routes"],
      );
      return data;
    } else {
      throw Exception();
    }
  }
}
