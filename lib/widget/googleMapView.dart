import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/utils/google_mapp_places_services/googleMapPlacesServices.dart';
import 'package:route_tracker_pro/utils/locationServices/locationservice.dart';
import 'package:route_tracker_pro/utils/map_services.dart';
import 'package:route_tracker_pro/widget/customspartedlistview.dart';
import 'package:route_tracker_pro/widget/customtextfiled.dart';
import 'package:uuid/uuid.dart';

class Googlemapview extends StatefulWidget {
  const Googlemapview({super.key});

  @override
  State<Googlemapview> createState() => _GooglemapviewState();
}

class _GooglemapviewState extends State<Googlemapview> {
  late Locationservice locationservice;
  late GoogleMapController googleMapController;
  late Set<Marker> marker = {};
  late Googlemapplacesservices placesServices;
  late List<PlacesModle> predictionesplaces = [];
  late MapServices mapServices;
  String? tokenSaitiones;
  late Uuid uuid;
  TextEditingController controller = TextEditingController();
  bool isfirstCall = true;
  @override
  void initState() {
    locationservice = Locationservice();
    uuid = Uuid();
    placesServices = Googlemapplacesservices();
    mapServices = MapServices();
    featchplaces();
    super.initState();
  }

  void featchplaces() {
    controller.addListener(() async {
      tokenSaitiones ??= uuid.v4();
      if (controller.text.isNotEmpty) {
        var result = await mapServices.getPredictionPlaces(
          param: controller.text,
        );
        predictionesplaces.clear();
        predictionesplaces.addAll(result);
        setState(() {});
      }
      if (controller.text.isEmpty) {
        predictionesplaces.clear();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    googleMapController.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 0,
            ),
            onMapCreated: (controller) {
              googleMapController = controller;
              customerPostion();
            },
            markers: marker,
            myLocationEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Customtextfiled(textEditingController: controller),
                SizedBox(height: 15),
                Customspartedlistview(
                  places: predictionesplaces,
                  onslected: (placeModle) {
                    tokenSaitiones = null;
                    controller.clear();
                    predictionesplaces.clear();
                  },
                ),
              ],
            ),
          ),
        ],
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
