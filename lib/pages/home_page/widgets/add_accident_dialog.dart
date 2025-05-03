import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';

import '../../../global_data.dart';
import '../../../models.dart';

class AddAccidentDialog extends StatefulWidget {
  final AccidentReport accidentReport;
  const AddAccidentDialog({super.key, required this.accidentReport});

  @override
  State<AddAccidentDialog> createState() => _AddAccidentDialogState();
}

class _AddAccidentDialogState extends State<AddAccidentDialog> {
  late int _severityVal;
  String _address = "Location";

  bool _loading = false;

  void chooseDateTime(){}

  void _submitAccidentReport() {
    try {
      setState(() {
        _loading = true;
      });

      FirestoreHelper.addAccidentReport(widget.accidentReport).then((docRef) {
        widget.accidentReport.reportId = docRef.id;
        setState(() {
          _loading = false;
        });
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (ex) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: MkText(
                text: ex.code.toString(),
                googleFont: RASfonts.inter,
              ))
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GoogleMapHelper.getAddressFromLatLng(widget.accidentReport.location).then((value) => setState(()=>_address=value));
    _severityVal = widget.accidentReport.severity;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.accidentReport.timestamp;

    MkSizedHeight PaddingInBetween = MkSizedHeight(0.02);
    return Padding(
      padding: EdgeInsets.only(top: grh(context, 0.05)),
      child: Dialog(
        insetPadding: EdgeInsets.all(20),
        backgroundColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
        child: MkUnFocus(
          child: PhysicalModel(
            color: Colors.transparent,
            child: Container(
              height: grh(context, 0.77),
              width: 500,
              padding: const EdgeInsets.all(15),
              child:  MkSingleChildScroll(
                overflowColor: Colors.black.withOpacity(0.1),
                child: Column(
                  children: [
                    MkText(text: "Report an Accident",googleFont: RASfonts.inter, textColor: Colors.white.withOpacity(0.8),padding: const EdgeInsets.only(top: 10),size: grh(context, 0.032),),
                    PaddingInBetween,
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.4),),
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: grh(context,0.018)),

                      child: Row(
                        children: [
                          Icon(Icons.pin_drop, color: Colors.yellow.shade700,),
                          MkText(text: _address, googleFont: RASfonts.inter,textColor: Colors.white70, size: grh(context, 0.017),padding: EdgeInsets.only(left: 10,bottom: 5),),
                        ],
                      ),
                    ),
                    PaddingInBetween,
                    GestureDetector(
                      onTap: chooseDateTime,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.4),),
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: grh(context,0.015)),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: Colors.yellow.shade700, size: 20,),
                            MkText(text: "${GoogleMapHelper.getDateString(dateTime)} ${GoogleMapHelper.getTimeString(dateTime)}", googleFont: RASfonts.inter,textColor: Colors.white70, size: grh(context, 0.017),padding: EdgeInsets.only(left: 10),),
                          ],
                        ),
                      ),
                    ),
                    PaddingInBetween,
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.4),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MkText(text: "Severity: ", googleFont: RASfonts.inter, textColor: Colors.white60, size: 25,),
                          Slider(
                            activeColor: (_severityVal>5)?Colors.redAccent:(_severityVal>1)?Colors.yellow.shade700:Colors.greenAccent,
                            inactiveColor: Colors.black.withOpacity(0.7),
                            onChanged: (value) {
                              setState(() {
                                _severityVal = value.round();
                                widget.accidentReport.severity = _severityVal;
                              });
                            },
                            max: 10,
                            divisions: 2,
                            value: _severityVal*1.0,
                            label: (_severityVal==0)?"Minor":(_severityVal==5)?"Major":"Critical",

                          ),
                        ],
                      ),
                    ),
                    PaddingInBetween,
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.4),),
                      child: Row(
                        children: [
                          MkText(text: "Vehicles Involved: ", googleFont: RASfonts.inter, textColor: Colors.white60, size: 20,padding: EdgeInsets.only(right: 15),),
                          Expanded(child: MkTextFormField(onTextChange: (s){widget.accidentReport.vehiclesInvolved = int.parse(s);}, cursorColor: Colors.white60 ,textInputType: TextInputType.number, textInputAction: TextInputAction.next, textStyle: MkText.style(googleFont: RASfonts.inter, textColor: Colors.yellow.shade700, size: 23), underlineWidth: 1, initialValue: "0",))
                        ],
                      ),
                    ),
                    PaddingInBetween,
                    Container(
                      padding: EdgeInsets.all(15),
                      height: grh(context, 0.22),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black.withOpacity(0.4),),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MkText(text: "Description: ", googleFont: RASfonts.inter, textColor: Colors.white60, size: 20,padding: EdgeInsets.only(bottom: 10),),
                          Expanded(
                            child: MkTextFormField(onTextChange: (s){widget.accidentReport.description = s;}, cursorColor: Colors.white38,textInputType: TextInputType.multiline, textInputAction: TextInputAction.newline, textStyle: MkText.style(googleFont: RASfonts.inter, textColor: Colors.white60, size: 18), mode: OutlineMode.box, maxLines: 7,minLines: 7, contentPadding: EdgeInsets.all(10), textAlignment: TextAlign.start, borderRadius: 10,),
                          )
                        ],
                      ),
                    ),
                    PaddingInBetween,
                    (_loading)?CircularProgressIndicator(color: Colors.yellow.shade700,):GestureDetector(
                      onTap: _submitAccidentReport,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.black.withOpacity(0.4),border: Border.all(color: Colors.white38, width: 1)),
                        child: MkText(text: "Done", googleFont: RASfonts.inter, textColor: Colors.white60, size: grh(context, 0.02)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
