// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_pro/utils/map_services.dart';

void main() {
  test('calculate max and min latlong', () {
    var mapServices = MapServices();

    final result = mapServices.getLatlngBounds([
      [LatLng(12, 16), LatLng(3, 5), LatLng(5, 12)],
    ]);
    expect(result.southwest.latitude, 3);
    expect(result.southwest.longitude, 5);
    expect(result.northeast.latitude, 12);
    expect(result.northeast.longitude, 16);
  });
}
