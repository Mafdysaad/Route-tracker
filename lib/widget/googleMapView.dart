import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Googlemapview extends StatefulWidget {
  const Googlemapview({super.key});

  @override
  State<Googlemapview> createState() => _GooglemapviewState();
}

class _GooglemapviewState extends State<Googlemapview> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 0),
    );
  }
}
