import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/global_data.dart';
import 'package:road_accident_safety_system/pages/login_page.dart';
import 'package:road_accident_safety_system/pages/sign_up_page/sign_up_page_1.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: gcw(context),
        height: gch(context),
        decoration: BoxDecoration(image: DecorationImage(image: GlobalData.bg_yellowLines, fit: BoxFit.cover,)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MkSizedHeight(0.15),
                Container(
                  height: grh(context, 0.2),
                  width: grh(context, 0.2),
                  // color: Colors.yellow,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black, blurRadius: 50)],
                      image: DecorationImage(
                        image: GlobalData.logo,
                      fit: BoxFit.cover
                    )
                  ),
                ),
                MkSizedHeight(0.01),
                MkText(text: GlobalData.appTitle, googleFont: RASfonts.josefinSlab, size: grh(context, 0.05), fontWeight: FontWeight.bold, textColor: Colors.yellow.shade600,),
                MkSizedHeight(0.02),
                MkText(text: GlobalData.appTagline, googleFont: RASfonts.algreya, size: grh(context, 0.03), alignment: TextAlign.center, textColor: Colors.white),
                MkSizedHeight(0.2),
                Column(
                  children: [
                    ElevatedButton(onPressed: ()=>travelToPage(context, LoginPage()),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                          shadowColor:MaterialStateProperty.all<Color>(Colors.black),
                          elevation: MaterialStateProperty.all<double>(18),
                        ),
                        child: MkText(
                          padding: EdgeInsets.all(grh(context, 0.01)),
                          text:"Login",
                          googleFont: RASfonts.josefinSlab,
                          size: grh(context, 0.03),
                          textColor: Colors.white,
                        )
                    ),
                    MkSizedHeight(0.01),
                    ElevatedButton(onPressed: ()=> travelToPage(context, const SignUpPage()),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                          shadowColor:MaterialStateProperty.all<Color>(Colors.black),
                          elevation: MaterialStateProperty.all<double>(18),
                        ),
                        child: MkText(
                          padding: EdgeInsets.all(grh(context, 0.01)),
                          text:"Sign Up",
                          googleFont: RASfonts.josefinSlab,
                          size: grh(context, 0.03),
                          textColor: Colors.white,
                        )
                    ),
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
