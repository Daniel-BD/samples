import 'package:flutter/material.dart';
import '../theme/colors.dart' as game_colors;

class BackgroundClouds extends StatelessWidget {
  final bool asSmallAsPossible;
  const BackgroundClouds({
    super.key,
    this.asSmallAsPossible = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Image.asset(
          'assets/images/Background clouds.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        if (!asSmallAsPossible)
          Container(
            color: game_colors.backgroundCloudWhite,
            width: double.infinity,
            height: height * 0.05,
          ),
      ],
    );
  }
}
