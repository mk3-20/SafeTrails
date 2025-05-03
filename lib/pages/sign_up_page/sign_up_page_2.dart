import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';

import '../../global_data.dart';
import '../../models.dart';
import '../emergency_contact_page.dart';
import '../home_page/home_page.dart';

class SignUpPage2 extends StatefulWidget {
  final UserModel user;

  const SignUpPage2({super.key, required this.user});

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  late bool hideAllContacts = false;
  late bool _loading = false;

  void _signUp(BuildContext context) {
    try {
      setState(() {
        _loading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: widget.user.email, password: widget.user.password)
          .then((UserCredential userCredential) async {
        widget.user.userId = userCredential.user!.uid;


        for (EmergencyContact contact in widget.user.emergencyContacts) {
          contact.userId = widget.user.userId;
          DocumentReference contactDoc =
          await FirestoreHelper.addContact(contact);
          contact.contactId = contactDoc.id;
        }

        FirestoreHelper.addUser(widget.user).then((value) {
          setState(() {
            _loading = false;
          });
          travelToPage(context, HomePage(userId: widget.user.userId));
          // showDialog(
          //     context: context,
          //     builder: (context) => AboutDialog(
          //       children: [
          //         MkText(
          //             text:
          //             "email: ${widget.user.email}\npassword: ${widget.user.password}\nfull name: ${widget.user.name}\ncontact: ${widget.user.phoneNumber}\n------------\n"),
          //         ...widget.user.emergencyContacts.map((e) => MkText(
          //           text: e.contactId,
          //         ))
          //       ],
          //     ));
        });
      });
    } on FirebaseAuthException catch (ex) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: MkText(text: ex.code.toString(), googleFont: RASfonts.inter,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: MkUnFocus(
            onUnfocus: () => setState(() {
              hideAllContacts = true;
            }),
            child: Container(
                alignment: Alignment.center,
                width: gcw(context),
                height: gch(context),
                decoration: BoxDecoration(image: DecorationImage(image: GlobalData.bg_cones, fit: BoxFit.cover,)
                ),
                child: Container(
                  height: grh(context, 0.8),
                  width: grw(context, 0.9),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.only(right: grw(context, 0.05), left: grw(context, 0.05), top: grh(context, 0.07), bottom: grh(context,0.035)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MkText(text: "Add Emergency Contacts", googleFont: RASfonts.inter, size: grw(context, 0.07), padding: EdgeInsets.only(bottom: 20), fontWeight: FontWeight.w500, textColor: Colors.white70),
                          SizedBox(width: grw(context, 0.7), child: Divider(height: 2, color: Colors.black,)),
                          SizedBox(
                            height: 20,
                          ),
                          EmergencyContactPage(
                            user: widget.user,
                            // contacts: widget.user.emergencyContacts,
                            hideAllFlag: hideAllContacts,
                          ),
                        ],
                      ),
                      (_loading)?CircularProgressIndicator(color: Colors.yellow.shade700,):GestureDetector(
                        onTap: () => _signUp(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MkText(text: "Sign Up", googleFont: RASfonts.inter, padding: EdgeInsets.only(right: 4), size: grh(context, 0.027), textColor: Colors.white70,),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                                size: grh(context,0.03),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                )
            ),
          )
      ),
    );
  }
}
