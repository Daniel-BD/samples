import 'package:flutter/material.dart';
import '../ui_components/ui_constants.dart';

class MonsterMakerLogo extends StatelessWidget {
  const MonsterMakerLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConstants.logoMaxWidth,
      ),
      child: Image.asset('assets/images/Logo and tagline.png'),
    );
  }
}
