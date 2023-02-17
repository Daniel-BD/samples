import 'package:flutter/material.dart';
import '../brushes/brushes.dart';

class BrushPainter extends CustomPainter {
  final double scale;
  final List<BrushLine> brushLines;

  BrushPainter(this.brushLines, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(scale);
    for (final brushLine in brushLines) {
      for (var pathAndPaint in brushLine.getPathsAndPaints()) {
        canvas.drawPath(pathAndPaint.item1, pathAndPaint.item2);
      }
    }
  }

  @override
  bool shouldRepaint(BrushPainter oldDelegate) {
    return true;
    //TODO: Testa detta för performance
    //return oldDelegate.brushLines.length != brushLines.length || oldDelegate.brushLines.last.getLine().length != brushLines.last.getLine().length;
  }

  @override
  bool shouldRebuildSemantics(BrushPainter oldDelegate) => false;
}
