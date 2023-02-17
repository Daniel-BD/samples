import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import 'control_panel_controller.dart';

class ClosePanelButton extends StatelessWidget {
  const ClosePanelButton({
    super.key,
    this.onTapped,
  });
  final VoidCallback? onTapped;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: onTapped ??
          () => context.read<ControlPanelController>().panelState =
              ControlPanelState.none,
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
