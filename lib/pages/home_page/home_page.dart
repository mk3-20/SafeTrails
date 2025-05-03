// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';

import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/components.dart';
import 'package:road_accident_safety_system/global_data.dart';
import 'package:road_accident_safety_system/models.dart';
import 'package:road_accident_safety_system/pages/home_page/widgets/add_accident_dialog.dart';
import 'package:road_accident_safety_system/pages/home_page/widgets/alert_popup.dart';
import 'package:road_accident_safety_system/pages/home_page/widgets/tiles.dart';
import 'package:road_accident_safety_system/pages/home_page/widgets/home_map.dart';
import 'package:road_accident_safety_system/pages/home_page/widgets/reports_tab.dart';
import 'package:road_accident_safety_system/pages/intro_page.dart';
import 'package:vibration/vibration.dart';

int THRESHOLD_DIST = 8;

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _alertsPageController;
  late GoogleMapController _googleMapController;

  bool _markerTapped = false;
  bool _hideReportsTab = false;
  // final Map<String, AccidentReport> _reports = {};
  final Set<String> _reportIdSet = {};
  final List<AccidentReport> _reportsList = [];
  AccidentReport? _currentAccidentReport;

  double _getDistance(LatLng loc1, LatLng loc2) {
    return FlutterMapMath().distanceBetween(
        loc1.latitude, loc1.longitude, loc2.latitude, loc2.longitude, "meters");
  }

  void _dismissAlert({bool showNextAlert = true}) {
    Vibration.cancel();
    FlutterRingtonePlayer.stop();
    Navigator.of(context).pop();
    // String reportId = _alertsQueue.removeFirst();
    // _markers[reportId] = _markers[reportId]!.withItem2(true);
    //
    // if(showNextAlert) {
    //   while (_markers.isNotEmpty && _markers[_alertsQueue.first]!.item2) {
    //     _alertsQueue.removeFirst();
    //   }
    //   if (_alertsQueue.isNotEmpty) {
    //     _showAlert(_alertsQueue.first);
    //   }
    // }
    setState(() {
      _hideReportsTab = false;
    });
  }

  Future<void> _showAlert(String reportId) async {
    // AccidentReport report = await FirestoreHelper.getAccidentReport(reportId);
    if(_hideReportsTab) Navigator.pop(context);
    if (await Vibration.hasCustomVibrationsSupport() ?? true) {
      Vibration.vibrate(
          pattern: [500, 1000, 500, 1000], intensities: [1, 255], repeat: 1);
      FlutterRingtonePlayer.play(
        fromAsset: "images/alert_audio_3.mp3",
        ios: IosSounds.alarm,
        looping: true,
        // Android only - API >= 28
        volume: 1,
        // Android only - API >= 28
        asAlarm: true, // Android only - all APIs
      );
      setState(() {
        _hideReportsTab = true;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertPopup(onDismiss: _dismissAlert,);
          }
      );
    }
  }

    @override
  initState() {
    super.initState();
    _alertsPageController = PageController(viewportFraction: 0.85);
  }

  Future<void> _callNumber() async {
    String user_id = FirebaseAuth.instance.currentUser!.uid;
    String number = (await FirestoreHelper.getUser(user_id))
        .emergencyContacts[0]
        .phoneNumber; //set the number here
    // await FlutterPhoneDirectCaller.callNumber(number);
    // print("CALLLLLL NUMBER: $number");
  }

  void _onMapCreatedCallback(GoogleMapController controller) {
    _googleMapController = controller;
    GoogleMapHelper.getCurrentLocation().then((curLoc) {
      for (AccidentReport report in _reportsList) {
        if(_getDistance(curLoc, report.location)<=THRESHOLD_DIST && report.severity>5) {_showAlert(report.reportId); break;}
      }
    });
    setState((){});
  }

  void _onAddAccidentClicked(BuildContext context) {
    GoogleMapHelper.getCurrentLocation().then((value) {
      AccidentReport accidentReport = AccidentReport(value, DateTime.now(),
          reportedBy: FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        _hideReportsTab = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext con) =>
              AddAccidentDialog(accidentReport: accidentReport)).then((value) => setState(() => _hideReportsTab = false));
    });
  }

  void _onReportCardChange(AccidentReport newFocusReport){
    setState(() {
      if(_currentAccidentReport!=null){ // Change back the colour of previously focused marker from yellow to red
        _currentAccidentReport!.marker = _currentAccidentReport!.marker!.copyWith(iconParam: BitmapDescriptor.defaultMarker);
      }

      if(!_markerTapped){ // if Card changed by scrolling through the cards and not by tapping a marker
        _googleMapController.showMarkerInfoWindow(newFocusReport.marker!.markerId);
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newFocusReport.location, zoom: 19)));
      }

      newFocusReport.marker = newFocusReport.marker!.copyWith(iconParam: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)); // change the colour of now focused marker from red to yellow
      _currentAccidentReport = newFocusReport;
    });
  }

  void _animateToCard(AccidentReport accidentReport){
    int index = _reportsList.indexOf(accidentReport);
    _markerTapped = true;
    _alertsPageController.animateToPage(index, duration: const Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn).then((_) => _markerTapped=false);
  }

  @override
  Widget build(BuildContext context) {
    SizedBox DrawerDivider = SizedBox(
        width: grw(context, 0.6),
        child: const Divider(
          height: 1,
          color: Colors.grey,
        ));

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const MkText(
          text: "SafeTrails",
          textColor: Colors.white,
          googleFont: RASfonts.inter,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(icon: Icon(Icons.menu, color: Colors.yellow.shade700), onPressed: () {Scaffold.of(context).openDrawer();});
          }
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,

        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: "Home"),
                DrawerDivider,
                DrawerTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      _onAddAccidentClicked(context);
                    },
                    text: "Add an Accident"),
                DrawerDivider,
                GestureDetector(
                  onTap: _callNumber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MkText(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        text: "Call Emergency Contact",
                        size: grh(context, 0.023),
                        googleFont: RASfonts.inter,
                        textColor: Colors.redAccent,
                      ),
                      const Icon(
                        Icons.call,
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                ),
                DrawerDivider,
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    travelToPage(context, IntroPage());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MkText(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        text: "Logout",
                        size: grh(context, 0.025),
                        googleFont: RASfonts.inter,
                        textColor: Colors.yellow.shade700,
                      ),
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.yellow.shade700,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreHelper.accidentReportsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
            // if snapshot really updated
            List<QueryDocumentSnapshot> accidentReports = snapshot.data!.docs;
            for (QueryDocumentSnapshot report in accidentReports) {
              // for each report received in snapshot update
              String reportId = report.id;
              if (!_reportIdSet.contains(reportId)) {
                Map<String, dynamic> reportData =
                report.data() as Map<String, dynamic>;
                DateTime timestamp = (reportData[DbFields.TIMESTAMP] as Timestamp).toDate();

                GeoPoint geoPoint = (reportData[DbFields.LOCATION] as GeoPoint);
                LatLng location =  LatLng(geoPoint.latitude, geoPoint.longitude);
                // if report not already on Map
                AccidentReport accidentReport = AccidentReport(
                  location, timestamp,
                  reportedBy: reportData[DbFields.USER_ID],
                  description: reportData[DbFields.DESCRIPTION],
                  reportId: reportId,
                  severity: reportData[DbFields.SEVERITY],
                  vehiclesInvolved: reportData[DbFields.VEHICLES_INVOLVED],
                );

                GoogleMapHelper.getAddressFromLatLng(location).then((value) => accidentReport.addressString = value);

                Marker marker = Marker(
                  markerId: MarkerId(reportId),
                  position: location,
                  infoWindow:
                  InfoWindow(title: reportData[DbFields.DESCRIPTION]),
                  onTap: () => _animateToCard(accidentReport)
                );

                accidentReport.marker = marker;

                // _reports[reportId] = accidentReport; // to show marker on map
                _reportIdSet.add(reportId);
                _reportsList.add(accidentReport);
                _currentAccidentReport = accidentReport;
              }
            }
          }
          Set<Marker> markers = {};
          // _reports.forEach((key, repo) {
          //   if (repo.marker != null) markers.add(repo.marker!);
          // });
          for (AccidentReport repo in _reportsList) {
            if (repo.marker != null) markers.add(repo.marker!);
          }
          return HomeMap(markers: markers, onMapCreated: _onMapCreatedCallback);
        }
      ),
      floatingActionButton: FloatingActionButton.small(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => _onAddAccidentClicked(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: (_hideReportsTab || _reportsList.isEmpty)?null:ReportsTab(
        pageController: _alertsPageController,
        reportsList: _reportsList,
        // reportsList: List<AccidentReport>.of(_reports.values),
        onCardChange: _onReportCardChange,
      ),
    );
  }
}




/*
class AlertSystem{
  final GoogleMapController mapController;
  AlertSystem({required this.mapController});

  late LatLng _lastLocation;
  final Queue<String> _alertsQueue = Queue();

  // initState -> _getCurrentLocation().then((value) {_lastLocation = value;}).then((value) => _listenToMovingPositionStream());

  double _getDistance(LatLng loc1, LatLng loc2) {
    return FlutterMapMath().distanceBetween(
        loc1.latitude, loc1.longitude, loc2.latitude, loc2.longitude, "meters");
  }

  void _listenToMovingPositionStream(){
    Geolocator.getPositionStream().listen((Position newPosition) {
      LatLng newLocation = LatLng(newPosition.latitude, newPosition.longitude);
      double distance = _getDistance(_lastLocation, newLocation);

      if (distance > 2) {
        _lastLocation = newLocation;

        _refreshAlertQueue();
      }
    });
  }

  Future<void> _dismissOnLeavingAlertZone() async {
    if (await _reportsWithinRadius() != null) _dismissAlert();
  }

  Future<void> _refreshAlertQueue() async {
    LatLng currentLoc = await _getCurrentLocation();
    if(_alertsQueue.isNotEmpty) _dismissAlert(showNextAlert: false);
    _alertsQueue.clear();
    for (String reportId in _markers.keys) {
      Marker marker = _markers[reportId]!.item1;
      double distance = _getDistance(currentLoc, marker.position);
      if (distance <= THRESHOLD_DIST) {
        if(!_markers[reportId]!.item2) _alertsQueue.add(reportId);
      }
      else{
        _markers[reportId] = _markers[reportId]!.withItem2(false);
      }
    }
    if(_alertsQueue.isNotEmpty) _showAlert(_alertsQueue.first);
  }

  Future<String?> _reportsWithinRadius() async {
    LatLng currentLoc = await _getCurrentLocation();
    for (String reportId in _markers.keys) {
      Marker marker = _markers[reportId]!.item1;
      double distance = _getDistance(currentLoc, marker.position);
      if (distance <= THRESHOLD_DIST) {
        return marker.markerId.toString();
      }
    }
    return null;
  }

  void _dismissAlert({bool showNextAlert = true}) {
    Vibration.cancel();
    FlutterRingtonePlayer.stop();
    Navigator.of(context).pop();
    String reportId = _alertsQueue.removeFirst();
    _markers[reportId] = _markers[reportId]!.withItem2(true);

    if(showNextAlert) {
      while (_markers.isNotEmpty && _markers[_alertsQueue.first]!.item2) {
        _alertsQueue.removeFirst();
      }
      if (_alertsQueue.isNotEmpty) {
        _showAlert(_alertsQueue.first);
      }
    }
  }

  Future<void> _showAlert(String reportId) async {
    AccidentReport report = await FirestoreHelper.getAccidentReport(reportId);
    if (await Vibration.hasCustomVibrationsSupport() ?? true) {
      Vibration.vibrate(
          pattern: [500, 1000, 500, 1000], intensities: [1, 255], repeat: 1);
      FlutterRingtonePlayer.play(
        fromAsset: "images/alert_audio_3.mp3",
        ios: IosSounds.alarm,
        looping: true,
        // Android only - API >= 28
        volume: 1,
        // Android only - API >= 28
        asAlarm: true, // Android only - all APIs
      );

      showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(top: grh(context, 0.05)),
              child: Dialog(
                insetPadding: EdgeInsets.all(20),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: grh(context, 0.25)),
                      child: PhysicalModel(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.black.withOpacity(0.3),
                        shadowColor: Colors.black,
                        elevation: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(30)),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          height: grh(context, 0.25),
                          width: 500,
                          padding: const EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                  size: grh(context, 0.1),
                                ),
                                MkText(
                                  text: "WARNING",
                                  googleFont: RASfonts.inter,
                                  textColor: Colors.yellow.shade700,
                                  padding:
                                  EdgeInsets.symmetric(vertical: 15),
                                ),
                                MkText(
                                  text: "You're in an accident prone area!",
                                  googleFont: RASfonts.inter,
                                  size: grw(context, 0.05),
                                  textColor: Colors.white60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    PhysicalModel(
                      shape: BoxShape.circle,
                      elevation: 30,

                      // borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.black.withOpacity(0.3),
                      shadowColor: Colors.black,
                      child: GestureDetector(
                        onTap: _dismissAlert,
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: MkText(
                            text: "Dismiss",
                            googleFont: RASfonts.inter,
                            textColor: Colors.white60,
                            size: grh(context, 0.025),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );

    }

  }

}
*/
