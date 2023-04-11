import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class CheckersBackground extends StatelessWidget {
  const CheckersBackground({
    super.key,
    this.child,
    this.canvasColor,
    this.circular = true,
    this.clipRadius,
  });

  final Widget? child;
  final Color? canvasColor;
  final Radius? clipRadius;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckersPainter(canvasColor, circular, clipRadius),
      child: child,
    );
  }
}

class _CheckersPainter extends CustomPainter {
  _CheckersPainter(this.canvasColor, this.circular, this.clipRadius);

  final Color? canvasColor;
  final Radius? clipRadius;
  final bool circular;
  late final divideWidthBy = circular ? 5 : 12;
  late final divideHeightBy = circular ? 5 : 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rectSide = size.width / divideWidthBy;
    final paintLight = Paint()..color = canvasColor ?? Color(0xFFFFFFFF);
    final paintDark = Paint()
      ..color = checkersPatternDarkColor; //Color(0x55BFBFBF);

    final offsetThingy = rectSide / 2;

    if (circular) {
      final clipPath = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(size.height / 2, size.height / 2),
            width: size.width,
            height: size.height,
          ),
        );

      canvas.clipPath(
        clipPath,
      );
    } else if (clipRadius != null) {
      canvas.clipRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height,
          ),
          clipRadius!,
        ),
      );
    }

    if (canvasColor != null) {
      canvas.drawPaint(Paint()..color = canvasColor!);
    }

    for (int i = 0; i < divideHeightBy; i++) {
      for (int j = 0; j < divideWidthBy; j++) {
        var skip = false;
        if (canvasColor != null) {
          if (canvasColor != null && i.isEven && j.isOdd ||
              i.isOdd && j.isEven) {
            skip = true;
          }
        }
        if (!skip) {
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(
                offsetThingy + (rectSide) * j,
                offsetThingy + (rectSide) * i,
              ),
              width: rectSide,
              height: rectSide,
            ),
            i.isEven
                ? j.isEven
                    ? paintDark
                    : paintLight
                : j.isOdd
                    ? paintDark
                    : paintLight,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
