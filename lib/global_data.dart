import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'mk_theme_provider.dart';

class RASfonts{
  static const String algreya = 'Alegreya Sans';
  static const String annieUseYourTelescope = 'Annie Use Your Telescope';
  static const String blinker = 'Blinker';
  static const String josefinSlab = 'Josefin Slab';
  static const String oswald ='Oswald';
  static const String ptSans ='PT Sans';
  static const String rancho ='Rancho';
  static const String sniglet ='Sniglet';
  static const String teko ='Teko';
  static const String vibur ='Vibur';
  static const String inter ='Inter';
}

class GlobalData{
  static int lastThemeIndex = 0;
  static String appTitle = "SafeTrails";
  static String appTagline = "Safety in Every Step,\nSafeTrails keeps you protected!";
  static AssetImage bg_yellowLines = AssetImage("images/yellowLines.jpg");
  static AssetImage bg_cones = AssetImage("images/cones.jpg");

  static Map<MkColor, Color> lightTheme = {
    MkColor.theme : Colors.white,
    MkColor.contrast : Colors.black,
    MkColor.navBar : Colors.black,
    MkColor.statusBar : Colors.black,
  };

  static const AssetImage logo =  AssetImage('images/logo.png');

  static String? getEmailError(String email) {
    if (email.isEmpty) return "email cannot be empty!";
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) return "enter valid email!";
    return null;
  }


  static String? getNameError(String name) {
    if (name.isEmpty) return "name cannot be empty!";
    if (!RegExp(r"[a-zA-Z]+").hasMatch(name)) return "enter valid name!";
    return null;
  }

  static String? getPhoneError(String phone) {
    if (phone.isEmpty) return "phone cannot be empty!";
    if ((phone.length != 10) || !RegExp(r"^(\+91)?[0-9]{10}$").hasMatch(phone)) return "enter valid phone number!";
    return null;
  }

  static String? getPasswordError(String password){
    if (password.isEmpty) return "password cannot be empty!";
    if (password.length < 6) return 'atleast 6 characters needed!';
    return null;
  }

}

class GoogleMapHelper{
  static Map<int,String> monthMap = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  static  Future<LatLng> getCurrentLocation() async {
    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus==LocationPermission.denied || permissionStatus == LocationPermission.deniedForever) {
        await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) async {
        await Geolocator.requestPermission();
        print("ERROR GETTING CURRENT LOCATION [global_data -> GoogleMapHelper -> getCurrentLocation()]: " + error.toString());
      });
    }
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(pos.latitude, pos.longitude);
  }

  static Future<String> getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemarks[0];

    return '${place.street}, ${place.subLocality}\n${place.subAdministrativeArea}, ${place.postalCode}';
  }

  static String getDateString(DateTime dateTime)=>"${dateTime.day} ${monthMap[dateTime.month]} ${dateTime.year}";
  static String getTimeString(DateTime dateTime)=>"${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

}


// Google Maps API KEY: AIzaSyBQatGCJ6IyglQ-vN49cvaFKTudsW9i_xQ
