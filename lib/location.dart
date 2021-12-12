// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable, unnecessary_null_comparison, curly_braces_in_flow_control_structures

import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

class Location {
  static late Position position;
  static late String mylocation;

  static Future<String> getLocation() async {
    mylocation = await initLocation();
    if (mylocation == '&')
      return "Longitude(not identified) Latitude(not identified)";
    else
      return mylocation;
  }

  static Future initLocation() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    position = await _determinePosition();
    String myloc = '&';
    if (position != null)
      myloc = "Longitude(" +
          position.longitude.toString() +
          ") Latitude(" +
          position.latitude.toString() +
          ")";
    return myloc;
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
