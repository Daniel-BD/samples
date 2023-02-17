import 'package:flutter/material.dart';

import '../theme/colors.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({super.key});
  static const numberOfDashes = 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.biggest.height;
      final width = constraints.biggest.width;

      final dashHeight = height / 100;
      final dashLength = (width / numberOfDashes) * 0.7;
      final dashSpace = (width / numberOfDashes) * 0.3;

      return Padding(
        padding: EdgeInsets.only(bottom: height / 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < numberOfDashes - 1; i++)
              Row(
                children: [
                  Dash(
                    height: dashHeight,
                    width: dashLength,
                  ),
                  SizedBox(
                    width: dashSpace,
                  ),
                ],
              ),
            Dash(
              height: dashHeight,
              width: dashLength,
            ),
          ],
        ),
      );
    });
  }
}

class Dash extends StatelessWidget {
  const Dash({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        color: canvasDashColor,
      ),
    );
  }
}
