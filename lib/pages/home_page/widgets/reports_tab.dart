
import 'package:flutter/material.dart';
import 'package:mk_flutter_helper/relative_dimension.dart';

import '../../../models.dart';
import 'tiles.dart';

class ReportsTab extends StatefulWidget {
  final void Function(AccidentReport) onCardChange;
  final List<AccidentReport> reportsList;
  final PageController pageController;

  const ReportsTab({super.key, required this.reportsList, required this.onCardChange, required this.pageController});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  int _index = 0;

  void reportChanged(int newIndex){
    setState(() => _index = newIndex);
    widget.onCardChange(widget.reportsList.elementAt(newIndex));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: grh(context,0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                  height: grh(context,0.27), // Card height
                  width: gcw(context),
                  child: PageView.builder(
                      itemCount: widget.reportsList.length,
                      controller: widget.pageController,
                      onPageChanged: reportChanged,
                      itemBuilder: (context, index) {

                        return AnimatedPadding(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                            padding:
                            EdgeInsets.all(_index == index ? 0.0 : 8.0),
                            child: ReportTile(accidentReport: widget.reportsList.elementAt(index))
                        );
                      })),
            ],
          )
        ],
      ),
    );
  }
}