import 'package:route_tracker_pro/modle/place_datils_modle/place_datils_modle.dart';
import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/utils/google_mapp_places_services/googleMapPlacesServices.dart';

class MapServices {
  Googlemapplacesservices googlemapplacesservices = Googlemapplacesservices();

  Future<List<PlacesModle>> getPredictionPlaces({required String param}) async {
    var predictionplaces = await googlemapplacesservices
        .predictionesPlacesEndpoint(input: param);
    return predictionplaces;
  }

  Future<PlaceDatilsModle> getplaceDatils(String placeID) async {
    var datils = await googlemapplacesservices.placesDatilsEndpoint(
      placeID: placeID,
    );
    return datils;
  }
}
