import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/models.dart';

import '../../../global_data.dart';

class DrawerTile extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const DrawerTile({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          MkText(
            padding: const EdgeInsets.symmetric(vertical: 20),
            text: text,
            size: grh(context, 0.025),
            googleFont: RASfonts.inter,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final AccidentReport accidentReport;
  const ReportTile({super.key, required this.accidentReport});

  @override
  Widget build(BuildContext context) {
    Color whiteTextColor =  Colors.white.withOpacity(0.9);
    Color whiteIconColor = Colors.white.withOpacity(0.8);
    DateTime dateTime = accidentReport.timestamp;
    String severityString = (accidentReport.severity>5)?"Critical":(accidentReport.severity>1)?"Major":"Minor";
    Color severityColor = (accidentReport.severity>5)?Colors.redAccent:(accidentReport.severity>1)?Colors.yellow.shade700:Colors.greenAccent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(20)
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MkText(googleFont: RASfonts.inter, size: 30, text: (accidentReport.description.isNotEmpty)?accidentReport.description:"No Description", textColor: whiteTextColor, overflow: TextOverflow.ellipsis,maxLines: 2, fontWeight: FontWeight.bold,),
            const SizedBox(height: 10,),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Icon(Icons.warning_amber_outlined, color: severityColor, size: 25,),
                        MkText(googleFont: RASfonts.inter, size: 20, text: severityString,textColor: whiteTextColor, padding: EdgeInsets.only(left:10),)
                      ]),
                    ),
                    const SizedBox(height: 10,),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Icon(Icons.pin_drop, color: whiteIconColor, size: 25,),
                        MkText(googleFont: RASfonts.inter, size: 20, text: accidentReport.addressString??"${accidentReport.location.latitude} ${accidentReport.location.longitude}",textColor: whiteTextColor, padding: EdgeInsets.only(left:10),)
                      ]),
                    ),
                    const SizedBox(height: 10,),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Icon(Icons.alarm_outlined, color: whiteIconColor, size: 25,),
                        MkText(googleFont: RASfonts.inter, size: 20, text: "${GoogleMapHelper.getDateString(dateTime)} ${GoogleMapHelper.getTimeString(dateTime)}",textColor: whiteTextColor, padding: EdgeInsets.only(left:10),)
                      ]),
                    ),
                    const SizedBox(height: 10,),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Icon(Icons.car_crash_outlined, color: whiteIconColor, size: 25,),
                        MkText(googleFont: RASfonts.inter, size: 20, text: "${accidentReport.vehiclesInvolved} Vehicles Involved",textColor: whiteTextColor, padding: EdgeInsets.only(left:10),)
                      ]),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


