import 'package:location/location.dart';

class Locationservice {
  var location = Location();
  Future<bool> checkAndRequestLocationService() async {
    var isenabled = await location.serviceEnabled();
    if (!isenabled) {
      isenabled = await location.requestService();
      if (!isenabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var haspermission = await location.hasPermission();
    if (haspermission == PermissionStatus.denied) {
      haspermission = await location.requestPermission();
      return haspermission == PermissionStatus.granted;
    }
    if (haspermission == PermissionStatus.deniedForever) {
      return false;
    } else {
      return true;
    }
  }

  void getRealTimeLocation(void Function(LocationData)? streamLocation) {
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(streamLocation);
  }
}
