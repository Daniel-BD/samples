import 'package:flutter/material.dart';
import 'package:monstermaker/colors.dart';

class PopUpPanelDecoration extends StatelessWidget {
  const PopUpPanelDecoration({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: panelOffWhiteColor,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          width: 2.0,
          color: panelDarkColor,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}
