import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker_pro/modle/destination_modle/destination_modle.dart';
import 'package:route_tracker_pro/modle/location_modle/location_modle.dart';

import 'package:route_tracker_pro/modle/placesmodle/places_modle/places_modle.dart';
import 'package:route_tracker_pro/modle/routes_modle/routes_modle.dart';
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
  late DestinationModle destinationmodle;
  late LocationModle locationmodle;
  Set<Polyline> pointofroute = {};
  late Set<Marker> marker = {};
  late Googlemapplacesservices placesServices;
  late List<PlacesModle> predictionesplaces = [];
  late MapServices mapServices;
  late RoutesModle routes;
  LocationData? customerpostion;
  String? sesstionToken;
  late LatLng destination;
  late Uuid uuid;
  TextEditingController controller = TextEditingController();
  bool isfirstCall = true;
  Timer? debounce;
  @override
  void initState() {
    locationservice = Locationservice();
    uuid = Uuid();
    placesServices = Googlemapplacesservices();
    mapServices = MapServices();
    routes = RoutesModle();
    featchplaces();
    super.initState();
  }

  void featchplaces() {
    controller.addListener(() async {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      sesstionToken ??= uuid.v4();

      debounce = Timer(Duration(milliseconds: 300), () async {
        if (controller.text.isNotEmpty) {
          var result = await mapServices.getPredictionPlaces(
            param: controller.text,
            sessiontoken: sesstionToken!,
          );
          predictionesplaces.clear();
          predictionesplaces.addAll(result);
          setState(() {});
        }
      });
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
              mapServices.updatacurrentlocation(googleMapController);
            },
            markers: marker,
            myLocationEnabled: true,
            polylines: pointofroute,
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
                  onslected: (placeModle) async {
                    var rout = await mapServices.getRoutes(
                      destinition: LatLng(
                        placeModle.geometry!.location!.lat!,
                        placeModle.geometry!.location!.lng!,
                      ),
                      markers: marker,
                      googlmapcontroller: googleMapController,
                    );
                    desplyroute();
                    sesstionToken = null;
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

  void desplyroute() {
    for (int i = 0; i < mapServices.pointes.length; i++) {
      pointofroute.add(
        Polyline(
          width: 5,
          polylineId: PolylineId('$i'),
          points: mapServices.pointes[i],
          color: i == 0 ? Colors.blue : const Color.fromARGB(118, 33, 149, 243),
        ),
      );
    }
    setState(() {});
  }

  LatLngBounds? getBounds(List<List<LatLng>> routes) {
    int index = 0;
    double? minlat = 0;
    double? minlog = 0;
    double? maxlat = 0;
    double? maxlong = 0;
    for (int i = 0; i < routes.length; i++) {}
  }
  // Future<void> customerPostion() async {
  //   try {
  //     mapServices.updatacurrentlocation(googleMapController);
  //     setcamerposition(customerpostion!);
  //     setState(() {});
  //   } on LocationPermissionExaption catch (e) {
  //     print(e.massage);
  //   } on LocationServiceExaption catch (e) {
  //     print(e.massage);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void addmarker(LatLng latlng) {
    var customerLocationMarker = Marker(
      markerId: MarkerId('customerLocation'),
      position: latlng,
    );
    marker.add(customerLocationMarker);
    setState(() {});
  }

  // void setcamerposition(LocationData locationData) {
  //   if (isfirstCall) {
  //     googleMapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: LatLng(locationData.latitude!, locationData.longitude!),
  //           zoom: 17,
  //         ),
  //       ),
  //     );
  //     isfirstCall = false;
  //   } else {
  //     googleMapController.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(locationData.latitude!, locationData.longitude!),
  //       ),
  //     );
  //   }
  // }
}
