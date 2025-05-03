// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/global_data.dart';
import 'package:road_accident_safety_system/pages/sign_up_page/sign_up_page_1.dart';
import '../components.dart';

import 'home_page/home_page.dart';
import 'intro_page.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _errorEmail;
  String? _errorPassword;
  String _emailVal = '';
  String _passwordVal = '';
  bool _loading = false;

  void setEmail(String email) => setState(() {
        _emailVal = email.trim();
        _errorEmail = null;
      });

  void setPassword(String password) => setState(() {
        _passwordVal = password.trim();
        _errorPassword = null;
      });

  Future<void> _login() async {
    _errorEmail = null; _errorPassword = null;
    _errorEmail = GlobalData.getEmailError(_emailVal);
    _errorPassword = GlobalData.getPasswordError(_passwordVal);

    if (_errorPassword != null || _errorEmail != null) setState(() {});
    else {
      try {
        setState(() {
          _loading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailVal, password: _passwordVal)
            .then((UserCredential userCredential) async {
          setState(() {
            _loading = false;
          });
          travelToPage(context, HomePage(userId: userCredential.user!.uid));
        });

      } on FirebaseAuthException catch (ex) {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(content: MkText(text: ex.code.toString(), googleFont: RASfonts.inter,)));
        setState(() {
          _loading = false;
        });
      }
    }
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
              decoration: BoxDecoration(image: DecorationImage(image: GlobalData.bg_yellowLines, fit: BoxFit.cover,)),
              child: Container(
                height: grh(context, 0.65),
                width: grw(context, 0.9),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
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
                          text: "Login",
                          googleFont: headingFont,
                          size: grh(context, 0.06),
                          textColor: Colors.yellow.shade700,
                          padding: EdgeInsets.only(bottom: grh(context, 0.04)),

                          // alignment: TextAlign.start,
                        ),
                        Column(
                          children: [

                            CustomInputTextBox(
                                onTextChange: setEmail,
                                headingText: "Email",
                                hintText: "johndoe@abc.com",
                                textInputType: TextInputType.emailAddress,
                                iconData: Icons.email,
                                errorText: _errorEmail,
                                initialText: _emailVal,

                            ),
                            _SpacingBtwFields,
                            CustomInputTextBox(
                                onTextChange: setPassword,
                                headingText: "Password",
                                hintText: "******",
                                iconData: Icons.key,
                                errorText: _errorPassword,
                                initialText: _passwordVal,
                                obscureText: true,
                                textInputAction: TextInputAction.done),
                            const MkSizedHeight(0.07),
                            (_loading)?CircularProgressIndicator(color: Colors.yellow.shade700,)
                                :CustomArrowButton(
                                iconData: Icons.arrow_forward_outlined,
                                // onTap: ()=>travelToPage(context, SignUpPage2(user: user)),
                                onTap: _login
                            )

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


