import 'package:flutter/material.dart';
import 'package:monstermaker/app_constants.dart';

class MonsterMakerLogo extends StatelessWidget {
  const MonsterMakerLogo({Key? key}) : super(key: key);

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
