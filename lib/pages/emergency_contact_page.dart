import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';
import 'package:road_accident_safety_system/global_data.dart';
import 'package:road_accident_safety_system/models.dart';

class EmergencyContactPage extends StatefulWidget {
  // final List<EmergencyContact> contacts;
  final UserModel user;
  final bool hideAllFlag;
  const EmergencyContactPage({super.key, required this.user, this.hideAllFlag = false});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  String? nameErr;
  String? phoneErr;

  late _ExpandedCard currentExpandedCard;
  final ScrollController _scrollController = ScrollController();

  bool hasInputError(){
    nameErr = null;
    phoneErr = null;
    if (currentExpandedCard.contact.name.isEmpty) nameErr = "name cannot be empty!";

    phoneErr = GlobalData.getPhoneError(currentExpandedCard.contact.phoneNumber);
    bool hasError = (nameErr!=null) || (phoneErr!=null);
    if(hasError) setState(() {});
    return hasError;
  }


  void deleteContact(EmergencyContact contact){
    if (widget.user.emergencyContacts.length>1) setState(() => widget.user.emergencyContacts.remove(contact));
  }


  void addContact(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + grh(context,0.2),
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
    if(!hasInputError()) setState(() => widget.user.emergencyContacts.add(EmergencyContact()));

  }

  @override
  Widget build(BuildContext context) {
    int currentExpandedCardIndex = (widget.user.emergencyContacts.length-1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.user.emergencyContacts.length,
            itemBuilder: (context, index) {
            EmergencyContact contact = widget.user.emergencyContacts[index];
            if(index == currentExpandedCardIndex) currentExpandedCard = _ExpandedCard(contact: contact, nameErr: nameErr, phoneErr: phoneErr,);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child:
                    (!widget.hideAllFlag && index == currentExpandedCardIndex)
                        ? currentExpandedCard
                        : _CollapsedCard(contact: contact, deleteContact: deleteContact,)
                    ),
                  if(index != (widget.user.emergencyContacts.length-1)) Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(width: grw(context, 0.7), child: Divider(height: 2, color: Colors.lightBlue,)),
                  ),
                ],
              );
            },
        ),
        GestureDetector(
          onTap: addContact,
          child: MkText(text: "+ add contact", size: grh(context, 0.02), textColor: Colors.blue,padding: EdgeInsets.only(left: 8),)
        )
      ],
    );
  }
}



class _CollapsedCard extends StatelessWidget {
  final EmergencyContact contact;
  final void Function(EmergencyContact) deleteContact;
  const _CollapsedCard({required this.contact, required this.deleteContact});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=>print("contact tapped (_CollapsedCard) "),
      onLongPress: ()=>deleteContact(contact),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MkText(text: contact.name, googleFont: RASfonts.inter, size: grh(context, 0.034), textColor: Colors.white70, fontWeight: FontWeight.bold,),
              MkText(text: contact.relationship, googleFont: RASfonts.inter, size: grh(context, 0.026),overflow: TextOverflow.ellipsis, textColor: Colors.white60,)
            ],
          ),
          MkText(text: contact.phoneNumber, googleFont: RASfonts.inter, fontWeight: FontWeight.bold, size: grh(context, 0.034), textColor: Colors.white60)
        ],
      ),
    );
  }
}


class _ExpandedCard extends StatelessWidget {
  final EmergencyContact contact;
  final String? nameErr;
  final String? phoneErr;
  const _ExpandedCard({required this.contact, this.nameErr, this.phoneErr});
  MkTextFormField BlankInput(Function(String) onTextChange, double size, String initialVal, String? errorTxt,
      {
        TextInputAction textInputAction = TextInputAction.next,
        TextInputType textInputType = TextInputType.text,
      })=> MkTextFormField(
    onTextChange: onTextChange,
    initialValue: initialVal,
    textStyle: MkText.style(googleFont: RASfonts.inter, size: size, textColor: Colors.white.withOpacity(0.8)),
    errorTextStyle: MkText.style(textColor: Colors.deepOrangeAccent, size: 15, googleFont: RASfonts.inter, ),
    cursorColor: Colors.white60,
    textCapitalization: TextCapitalization.words,
    textInputAction: textInputAction,
    textInputType: textInputType,
    errorText: errorTxt,
    textAlignment: TextAlign.start,
  );

  MkText SideHeading(String sideHeadingText, double sideHeadingSize)=>
      MkText(text: sideHeadingText,padding: EdgeInsets.only(right: 25),googleFont: RASfonts.inter, size: sideHeadingSize, textColor: Colors.white,);

  @override
  Widget build(BuildContext context) {
    double sideHeadingSize =  grw(context,0.055);
    double inputTextSize =  grh(context,0.027);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SideHeading("Name:", sideHeadingSize),
            Expanded(child: BlankInput((s)=> contact.name = s,inputTextSize, contact.name, nameErr)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SideHeading("Phone:", sideHeadingSize),
            Expanded(child: BlankInput((s)=>contact.phoneNumber = s, inputTextSize,contact.phoneNumber, phoneErr, textInputType: TextInputType.phone)),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SideHeading("Relation:", sideHeadingSize),
            Expanded(child: BlankInput((s)=> contact.relationship = s, inputTextSize, contact.relationship, null, textInputAction: TextInputAction.done)),
          ],
        ),
      ],
    );
  }
}
