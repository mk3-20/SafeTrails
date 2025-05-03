// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/global_data.dart';
import 'package:road_accident_safety_system/pages/intro_page.dart';
import 'package:road_accident_safety_system/pages/sign_up_page/sign_up_page_2.dart';

import '../../components.dart';

import '../../models.dart';

class SignUpErrors {
  static String? emailErr, nameErr, passwordErr, phoneErr;

  static bool hasErr() {
    return !(emailErr == null &&
      nameErr == null &&
      passwordErr == null &&
      phoneErr == null);
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserModel _user = UserModel();
  Color textColor = Colors.white;

  Future<void> moveToSecondPage() async {
    SignUpErrors.emailErr = GlobalData.getEmailError(_user.email);
    SignUpErrors.passwordErr = GlobalData.getPasswordError(_user.password);
    SignUpErrors.nameErr = GlobalData.getNameError(_user.name);
    SignUpErrors.phoneErr = GlobalData.getPhoneError(_user.phoneNumber);

    if (SignUpErrors.hasErr()) {
      setState(() {});
      return;
    }

    print("email: ${_user.email}\npassword: ${_user.password}\nfull name: ${_user.name}\ncontact: ${_user.phoneNumber}\n------------\n");
    travelToPage(context, SignUpPage2(user: _user));
  }



  @override
  Widget build(BuildContext context) {

    MkSizedHeight _SpacingBtwFields = const MkSizedHeight(0.013);

    return MkUnFocus(
      child: Scaffold(
        body: Center(
          child: Container(
              alignment: Alignment.center,
              width: gcw(context),
              height: gch(context),
              decoration: BoxDecoration(image: DecorationImage(image: GlobalData.bg_cones, fit: BoxFit.cover,)),
                child: Container(
                height: grh(context, 0.8),
                width: grw(context, 0.9),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: grw(context, 0.1)),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomArrowButton(
                          iconData: Icons.arrow_back_outlined,
                          onTap: () => travelToPage(context, const IntroPage()),
                          rowAlignment: MainAxisAlignment.start,
                        ),
                        const MkSizedHeight(0.06),
                        MkText(
                          text: "Sign Up",
                          googleFont: headingFont,
                          size: grh(context, 0.07),
                          padding: EdgeInsets.only(bottom: grh(context, 0.04)),
                          textColor: Colors.yellow.shade700 ,
                          // alignment: TextAlign.start,
                        ),
                        Column(
                          children: [
                            CustomInputTextBox(
                                onTextChange: (s) {
                                  setState(() {
                                    SignUpErrors.nameErr = null;
                                  });
                                  _user.name = s;
                                },
                                textCapitalization: TextCapitalization.words,
                                headingText: "Full Name",
                                hintText: "John Doe",
                                textInputType: TextInputType.name,
                                iconData: Icons.person,
                                errorText: SignUpErrors.nameErr,
                                initialText: _user.name,
                            ),
                            _SpacingBtwFields,
                            CustomInputTextBox(
                                onTextChange: (s) {
                                  setState(() {
                                    SignUpErrors.phoneErr = null;
                                  });
                                  _user.phoneNumber = s;
                                },
                                headingText: "Phone Number",
                                hintText: "+919876543210",
                                textInputType: TextInputType.phone,
                                iconData: Icons.phone,
                                errorText: SignUpErrors.phoneErr,
                                initialText: _user.phoneNumber),
                            _SpacingBtwFields,
                            CustomInputTextBox(
                                onTextChange: (s) {
                                  setState(() {
                                    SignUpErrors.emailErr = null;
                                  });
                                  _user.email = s;
                                },
                                headingText: "Email",
                                hintText: "johndoe@abc.com",
                                textInputType: TextInputType.emailAddress,
                                iconData: Icons.email,
                                errorText: SignUpErrors.emailErr,
                                initialText: _user.email),
                            _SpacingBtwFields,
                            CustomInputTextBox(
                                onTextChange: (s) {
                                  setState(() {
                                    SignUpErrors.passwordErr = null;
                                  });
                                  _user.password = s;
                                },
                                headingText: "Password",
                                hintText: "******",
                                iconData: Icons.key,
                                errorText: SignUpErrors.passwordErr,
                                initialText: _user.password,
                                obscureText: true,
                                textInputAction: TextInputAction.done),
                            const MkSizedHeight(0.07),
                            CustomArrowButton(
                              iconData: Icons.arrow_forward_outlined,
                              // onTap: ()=>travelToPage(context, SignUpPage2(user: user)),
                              onTap: moveToSecondPage
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}


// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//   Container(
//     margin: EdgeInsets.only(right: 6),
//     width: (!_firstPageDone) ? dotsWidth : dotsHeight,
//     height: dotsHeight,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(dotsHeight),
//       color: (!_firstPageDone) ? Colors.lightBlue : Colors.black,
//     ),
//   ),
//
//   Container(
//     margin: EdgeInsets.only(right: 2),
//     width: (_firstPageDone) ? dotsWidth : dotsHeight,
//     height: dotsHeight,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(dotsHeight),
//       color: (_firstPageDone) ? Colors.lightBlue : Colors.black,
//     ),
//   )
// ],),
