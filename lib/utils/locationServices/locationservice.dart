// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:location/location.dart';

class Locationservice {
  var location = Location();
  Future<void> checkAndRequestLocationService() async {
    var isenabled = await location.serviceEnabled();
    if (!isenabled) {
      isenabled = await location.requestService();
      if (!isenabled) {
        throw LocationServiceExaption(
          massage: 'Location services are disabled.',
        );
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    var haspermission = await location.hasPermission();
    if (haspermission == PermissionStatus.denied) {
      haspermission = await location.requestPermission();
      if (haspermission != PermissionStatus.granted) {
        throw LocationPermissionExaption(
          massage: 'Location permissions are denied',
        );
      }
    }
    if (haspermission == PermissionStatus.deniedForever) {
      throw LocationPermissionExaption(
        massage: 'Location permissions are permanently denied',
      );
    } else {}
  }

  void getRealTimeLocation(void Function(LocationData)? streamLocation) async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(streamLocation);
  }

  Future<LocationData> getLocation() async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }
}

class LocationServiceExaption implements Exception {
  String massage;
  LocationServiceExaption({required this.massage});
}

class LocationPermissionExaption implements Exception {
  String massage;
  LocationPermissionExaption({required this.massage});
}
