import 'package:flutter/material.dart';
import 'package:monstermaker/custom_painting/brushes/brushes.dart';

class ExperimentalDrawing {
  final List<BrushLine> _lines = [];
  final List<BrushLine> _undoneLines = [];
  List<BrushLine> get lines => _lines;

  late final Size originalCanvasSize;
  late final double brushScaleFactor;
  bool hasSetOriginalCanvasSize = false;

  void setOriginalCanvasSize(Size sizeAvailable) {
    if (hasSetOriginalCanvasSize) {
      return;
    }
    var size = canvasSizeCalculator(sizeAvailable);
    originalCanvasSize = size;
    brushScaleFactor = size.height / 375;
    hasSetOriginalCanvasSize = true;
  }

  void startNewLine({required BrushSettings brushSettings, required Offset startPoint}) {
    _undoneLines.clear();
    if (_lines.isNotEmpty && _lines.last.userIsCurrentlyDrawing) {
      _lines.last.endLine();
    }
    _lines.add(brushSettings.getBrushLineWithSettings());
    addPoint(startPoint);
  }

  void addPoint(Offset point) {
    _lines.last.addPoint(point);
  }

  void endCurrentLine() {
    _lines.last.endLine();
  }

  void clearDrawing() {
    _lines.clear();
    _undoneLines.clear();
  }

  void undoBrushLine() {
    if (_lines.isEmpty) {
      return;
    }
    var lineToUndo = _lines.removeLast();
    _undoneLines.add(lineToUndo);
  }

  void redoBrushLine() {
    if (_undoneLines.isEmpty) {
      return;
    }
    var lineToRedo = _undoneLines.removeLast();
    _lines.add(lineToRedo);
  }

  static Size canvasSizeCalculator(Size sizeAvailable) {
    double height;
    double width;

    if (sizeAvailable.height * (16 / 9) <= sizeAvailable.width) {
      height = sizeAvailable.height;
      width = sizeAvailable.height * (16 / 9);
    } else {
      height = sizeAvailable.width * (9 / 16);
      width = sizeAvailable.width;
    }

    return Size(width, height);
  }
}
