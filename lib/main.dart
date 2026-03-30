import 'package:flutter/material.dart';
import 'package:route_tracker_pro/widget/googleMapView.dart';

void main() {
  runApp(const RouteTracker());
}

class RouteTracker extends StatelessWidget {
  const RouteTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(resizeToAvoidBottomInset: true, body: Googlemapview()),
    );
  }
}
