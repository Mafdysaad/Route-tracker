// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:route_tracker_pro/modle/destination_modle/destination_modle.dart';
import 'package:route_tracker_pro/modle/location_modle/location_modle.dart';
import 'package:route_tracker_pro/modle/routes_modle/routes_modle.dart';
import 'package:route_tracker_pro/utils/google_mapp_places_services/googleMapPlacesServices.dart';

class RoutesServices {
  DestinationModle destinationmodle;
  LocationModle locationmodle;
  Googlemapplacesservices googlemapplacesservices;
  RoutesServices({
    required this.destinationmodle,
    required this.locationmodle,
    required this.googlemapplacesservices,
  });
  Future<List<RoutesModle>> featchroutes() async {
    var routs = await googlemapplacesservices.routesEndpoint(
      locationmodle,
      destinationmodle,
    );
    return routs;
  }

  List<List<LatLng>> decodepolyline(List<RoutesModle> routs) {
    List<List<LatLng>> pointesRoutes = [];
    for (int index = 0; index < routs.length; index++) {
      List<PointLatLng> pointes = PolylinePoints.decodePolyline(
        routs[index].polyline!.encodedPolyline!,
      );
      pointesRoutes.add(
        pointes.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      );
    }

    return pointesRoutes;
  }
}
