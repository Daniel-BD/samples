import 'dart:math';

import 'package:flutter/material.dart';

enum SignType { newMonsters, topMonsters }

class MonsterSign extends StatelessWidget {
  const MonsterSign({
    required this.type,
    this.small = false,
    super.key,
  });

  final bool small;
  //TODO: use this to decide the asset path for different signs
  final SignType type;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: small ? min(width * 0.45, 280.0) : min(width * 0.55, 320.0),
      child: Image.asset('assets/images/Type=New monsters.png'),
    );
  }
}
