import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:route_tracker_pro/modle/destination_modle/destination_modle.dart';
import 'package:route_tracker_pro/modle/location_modle/location_modle.dart';

import 'package:route_tracker_pro/modle/place_datils_modle/place_datils_modle.dart';

import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/modle/routes_modle/routes_modle.dart';

class Googlemapplacesservices {
  final String baseurl = "https://maps.googleapis.com/maps/api/place";
  final String routesUrl =
      "https://routes.googleapis.com/directions/v2:computeRoutes";
  final String apikey = "***************************";

  Future<List<PlacesModle>> predictionesPlacesEndpoint({
    required String input,
    required String sessionToken,
  }) async {
    var respons = await http.get(
      Uri.parse(
        '$baseurl/autocomplete/json?input=$input&key=$apikey&sessiontoken=$sessionToken',
      ),
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

  Future<List<RoutesModle>> routesEndpoint(
    LocationModle locationmodle,
    DestinationModle destinationmodle,
  ) async {
    Map<String, dynamic> body = {
      "origin": {"location": locationmodle.toJson()},
      "destination": {"location": destinationmodle.toJson()},
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false,
      },
      "languageCode": "en-US",
      "units": "METRIC",
    };
    Map<String, String> hedaer = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apikey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
    };
    var respons = await http.post(
      Uri.parse(routesUrl),
      headers: hedaer,
      body: jsonEncode(body),
    );
    if (respons.statusCode == 200) {
      var data = jsonDecode(respons.body)["routes"];
      List<RoutesModle> result = [];
      for (var item in data) {
        result.add(RoutesModle.fromJson(item));
      }
      return result;
    } else {
      throw Exception();
    }
  }
}
