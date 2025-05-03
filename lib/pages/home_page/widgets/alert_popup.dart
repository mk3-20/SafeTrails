import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/mk_flutter_helper.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';

import '../../../global_data.dart';

class AlertPopup extends StatelessWidget {
  final void Function()? onDismiss;
  const AlertPopup({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
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
                onTap: onDismiss,
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
}
