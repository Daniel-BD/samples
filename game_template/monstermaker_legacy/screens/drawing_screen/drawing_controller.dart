import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:monstermaker/custom_painting/brushes/brush_extensions.dart';
import 'package:monstermaker/custom_painting/brushes/brushes.dart';
import 'package:monstermaker/models/experimental_drawing.dart';

enum DrawMode { brush, eraser }

class DrawingController extends GetxController {
  final _drawing = ExperimentalDrawing();
  _CurrentBrushController? brushController;

  get lines => _drawing.lines;

  void setOriginalCanvasSize(Size sizeAvailable) {
    if (_drawing.hasSetOriginalCanvasSize) {
      return;
    }
    _drawing.setOriginalCanvasSize(sizeAvailable);
    brushController = _CurrentBrushController(scaleFactor: _drawing.brushScaleFactor);
    SchedulerBinding.instance?.addPostFrameCallback((_) => update());
  }

  void startNewLine({required Offset startPoint}) {
    assert(brushController != null, 'brushController should not be null');
    if (brushController != null) {
      _drawing.startNewLine(brushSettings: brushController!.currentBrushOrEraser, startPoint: startPoint);
      update();
    }
  }

  void addPoint(Offset point) {
    _drawing.addPoint(point);
    update();
  }

  void endCurrentLine() {
    _drawing.endCurrentLine();
    update();
  }

  void clearDrawing() {
    _drawing.clearDrawing();
    update();
  }

  void undoBrushLine() {
    _drawing.undoBrushLine();
    update();
  }

  void redoBrushLine() {
    _drawing.redoBrushLine();
    update();
  }
}

class _CurrentBrushController {
  _CurrentBrushController({required this.scaleFactor});
  final double scaleFactor;

  var drawMode = DrawMode.brush.obs;

  BrushSettings get currentBrushOrEraser {
    return drawMode.value == DrawMode.brush ? currentBrush.value : eraser.value;
  }

  void setCurrentBrush(BrushSettings brushSettings) {
    currentBrush.value = brushSettings.withScaleFactor(scaleFactor);
  }

  late Rx<BrushSettings> currentBrush =
      // ignore: unnecessary_cast
      (BrushStyle.singleStroke.defaultSettings.withScaleFactor(scaleFactor) as BrushSettings).obs;

  late var currentEraserSize = (scaleFactor * 16.0).obs;
  final _currentEraserOpacity = 1.0.obs;
  RxDouble get currentEraserOpacity => _currentEraserOpacity;
  set currentEraserOpacity(RxDouble opacity) {
    assert(opacity <= 1.0 && opacity >= 0.0, 'Opacity is out of range');
    _currentEraserOpacity.value = opacity.value;
  }

  late var eraser = EraserBrushSettings(width: currentEraserSize.value, opacity: currentEraserOpacity.value).obs;
}
