
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/models.dart';

import 'global_data.dart';


const String headingFont = RASfonts.algreya;
const String inputFont = RASfonts.josefinSlab;

class CustomInputTextBox extends StatelessWidget {
  final dynamic Function(String) onTextChange;
  final String headingText;
  final String hintText;
  final IconData? iconData;
  final String? errorText;
  final bool obscureText;
  final String initialText;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextInputType textInputType;


  const CustomInputTextBox({
    super.key,
    this.obscureText = false,
    this.initialText = "",
    this.hintText = "",
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType = TextInputType.text,
    required this.onTextChange,
    required this.headingText,
    required this.iconData,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: (errorText!=null)?grh(context, 0.01):0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          MkText(text: headingText,googleFont: RASfonts.inter, textColor: Colors.white, size: grw(context, 0.06),padding: EdgeInsets.only(bottom:(errorText!=null)? 10:0),),
          MkTextFormField(
            textInputAction: textInputAction,
            underlineWidth: 2,
            // mode: OutlineMode.box,
            onTextChange: onTextChange,
            width: grw(context, 0.75, maxWidth: 500),
            height: grh(context, 0.057),
            cursorColor: Colors.white60,
            textStyle: MkText.style(googleFont: RASfonts.algreya, size: grh(context, 0.027), fontWeight: FontWeight.w400, textColor: Colors.white.withOpacity(0.8)),
            errorText: errorText,
            errorTextStyle: MkText.style(textColor: Colors.deepOrangeAccent, size: 15, googleFont: RASfonts.inter, overflow: TextOverflow.clip),
            hintTextStyle: MkText.style(textColor: Colors.yellow.withOpacity(0.5), googleFont: RASfonts.algreya, size: grh(context, 0.027)),
            initialValue: initialText,
            hintText: hintText,
            obscureText: obscureText,
            prefixIconWidget: Icon(iconData, size: grh(context, 0.025), color: Colors.yellow.shade700,),
            suffixIconSize: grh(context, 0.02),
            textAlignment: TextAlign.start,
            textCapitalization: textCapitalization,
            textInputType: textInputType,
          ),
        ],
      ),
    );
  }
}


class CustomArrowButton extends StatelessWidget {
  final IconData iconData;
  final void Function()? onTap;
  final MainAxisAlignment rowAlignment;

  const CustomArrowButton({super.key, required this.iconData, this.onTap, this.rowAlignment = MainAxisAlignment.end});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: grw(context, 0.75, maxWidth: 500),
        child: Row(
          mainAxisAlignment: rowAlignment,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Material(
                color: Colors.transparent,
                shape: CircleBorder(
                    side: BorderSide(color: Colors.white60, width: 1.8)),
                child: Padding(
                  padding: const EdgeInsets.all(3.7),
                  child: Icon(
                    iconData,
                    color: Colors.white60,
                    size: grh(context, 0.032),
                  ),
                ),
              ),
            )
          ],
        )
    )
    ;
  }
}

