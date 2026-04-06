import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_pro/modle/destination_modle/destination_modle.dart';
import 'package:route_tracker_pro/modle/destination_modle/lat_lng.dart';
import 'package:route_tracker_pro/modle/location_modle/lat_lng.dart';
import 'package:route_tracker_pro/modle/location_modle/location_modle.dart';
import 'package:route_tracker_pro/modle/place_datils_modle/place_datils_modle.dart';
import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/modle/routes_modle/routes_modle.dart';
import 'package:route_tracker_pro/utils/google_mapp_places_services/googleMapPlacesServices.dart';
import 'package:route_tracker_pro/utils/locationServices/locationservice.dart';
import 'package:route_tracker_pro/utils/routes_services/routes_services.dart';

class MapServices {
  Googlemapplacesservices googlemapplacesservices = Googlemapplacesservices();
  var locationservice = Locationservice();
  List<List<LatLng>> pointes = [[]];

  LatLng? currentlocation;
  void updatacurrentlocation(GoogleMapController controller) {
    locationservice.getRealTimeLocation((locationdata) {
      currentlocation = LatLng(locationdata.latitude!, locationdata.longitude!);
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentlocation!, zoom: 17),
        ),
      );
    });
  }

  Future<List<PlacesModle>> getPredictionPlaces({
    required String param,
    required String sessiontoken,
  }) async {
    var predictionplaces = await googlemapplacesservices
        .predictionesPlacesEndpoint(input: param, sessionToken: sessiontoken);
    return predictionplaces;
  }

  Future<PlaceDatilsModle> getplaceDatils(String placeID) async {
    var datils = await googlemapplacesservices.placesDatilsEndpoint(
      placeID: placeID,
    );
    return datils;
  }

  Future<List<RoutesModle>> getRoutes({
    required LatLng destinition,
    required Set<Marker> markers,
    required GoogleMapController googlmapcontroller,
  }) async {
    LocationModle locationmodle = LocationModle(
      latLng: LatLngmodl(
        latitude: currentlocation!.latitude,
        longitude: currentlocation!.longitude,
      ),
    );
    DestinationModle destinationmodle = DestinationModle(
      latLng: LatLngModle(
        latitude: destinition.latitude,
        longitude: destinition.longitude,
      ),
    );
    Marker destinationmarker = Marker(
      markerId: MarkerId('destination'),
      position: destinition,
    );
    markers.add(destinationmarker);
    var routeservices = RoutesServices(
      destinationmodle: destinationmodle,
      locationmodle: locationmodle,
      googlemapplacesservices: googlemapplacesservices,
    );
    List<RoutesModle> routs = await routeservices.featchroutes();
    pointes = routeservices.decodepolyline(routs);
    LatLngBounds bounds = getLatlngBounds(pointes);
    googlmapcontroller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 20));
    return routs;
  }

  LatLngBounds getLatlngBounds(List<List<LatLng>> points) {
    double minlong = points[0][0].longitude;
    double minlat = points[0][0].latitude;
    double maxlat = points[0][0].latitude;
    double maxlong = points[0][0].longitude;
    points.expand((row) => row).forEach((item) {
      minlong = min(minlong, item.longitude);
      minlat = min(minlat, item.latitude);
      maxlong = max(maxlong, item.longitude);
      maxlat = max(maxlat, item.latitude);
    });
    return LatLngBounds(
      southwest: LatLng(minlat, minlong),
      northeast: LatLng(maxlat, maxlong),
    );
  }
}
