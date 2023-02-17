import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/colors.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/control_panel_controller.dart';

class ClosePanelButton extends StatelessWidget {
  const ClosePanelButton({
    Key? key,
    this.onTapped,
  }) : super(key: key);
  final VoidCallback? onTapped;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: onTapped ?? () => Get.find<ControlPanelController>().panelState = ControlPanelState.none,
      icon: Container(
        height: 32,
        width: 32,
        decoration: const BoxDecoration(
          color: panelDarkColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          size: 20,
        ),
      ),
      color: Colors.white,
    );
  }
}
