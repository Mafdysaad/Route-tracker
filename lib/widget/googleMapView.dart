import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker_pro/utils/locationServices/locationservice.dart';

class Googlemapview extends StatefulWidget {
  const Googlemapview({super.key});

  @override
  State<Googlemapview> createState() => _GooglemapviewState();
}

class _GooglemapviewState extends State<Googlemapview> {
  late Locationservice locationservice;
  late GoogleMapController googleMapController;
  late Set<Marker> marker = {};
  bool isfirstCall = true;
  @override
  void initState() {
    locationservice = Locationservice();

    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 0),
        onMapCreated: (controller) {
          googleMapController = controller;
          customerPostion();
        },
        markers: marker,
        myLocationEnabled: true,
      ),
    );
  }

  Future<void> customerPostion() async {
    try {
      LocationData locationData = await locationservice.getLocation();
      setcamerposition(locationData);
    } on LocationPermissionExaption catch (e) {
      print(e.massage);
    } on LocationServiceExaption catch (e) {
      print(e.massage);
    } catch (e) {
      print(e);
    }
  }

  void addmarker(LatLng latlng) {
    var customerLocationMarker = Marker(
      markerId: MarkerId('customerLocation'),
      position: latlng,
    );
    marker.add(customerLocationMarker);
    setState(() {});
  }

  void setcamerposition(LocationData locationData) {
    if (isfirstCall) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 17,
          ),
        ),
      );
      isfirstCall = false;
    } else {
      googleMapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }
}
