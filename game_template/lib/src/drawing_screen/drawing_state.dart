import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_template/src/custom_painting/brushes/brush_extensions.dart';

import '../custom_painting/brushes/brushes.dart';
import '../models/experimental_drawing.dart';

enum DrawMode { brush, eraser }

class DrawingState extends ChangeNotifier {
  final _drawing = ExperimentalDrawing();
  CurrentBrushState get currentBrushState => _currentBrushState;
  late CurrentBrushState _currentBrushState;
  bool get initialized => _drawing.hasSetOriginalCanvasSize;

  List<BrushLine> get lines => _drawing.lines;

  void setOriginalCanvasSize(Size sizeAvailable) {
    if (!_drawing.hasSetOriginalCanvasSize) {
      _drawing.setOriginalCanvasSize(sizeAvailable);
      notifyListeners();
    }
    _currentBrushState =
        CurrentBrushState(scaleFactor: _drawing.brushScaleFactor);
    if (!_drawing.hasSetOriginalCanvasSize) {
      //TODO: Remove this?
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void setDrawMode(DrawMode drawMode) {
    _currentBrushState = _currentBrushState.copyWith(drawMode: drawMode);
    notifyListeners();
  }

  void setCurrentBrush(BrushSettings brush) {
    _currentBrushState = _currentBrushState.copyWith(currentBrush: brush);
    notifyListeners();
  }

  void setEraserOpacity(double opacity) {
    assert(opacity <= 1.0 && opacity >= 0.0, 'Opacity is out of range');
    _currentBrushState =
        _currentBrushState.copyWith(currentEraserOpacity: opacity);
    notifyListeners();
  }

  void setEraserSize(double eraserSize) {
    _currentBrushState =
        _currentBrushState.copyWith(currentEraserSize: eraserSize);
    notifyListeners();
  }

  void startNewLine({required Offset startPoint}) {
    _drawing.startNewLine(
        brushSettings: _currentBrushState.currentBrushOrEraser,
        startPoint: startPoint);
    notifyListeners();
  }

  void addPoint(Offset point) {
    _drawing.addPoint(point);
    notifyListeners();
  }

  void endCurrentLine() {
    _drawing.endCurrentLine();
    notifyListeners();
  }

  void clearDrawing() {
    _drawing.clearDrawing();
    notifyListeners();
  }

  void undoBrushLine() {
    _drawing.undoBrushLine();
    notifyListeners();
  }

  void redoBrushLine() {
    _drawing.redoBrushLine();
    notifyListeners();
  }
}

@immutable
class CurrentBrushState {
  CurrentBrushState({
    required this.scaleFactor,
    this.drawMode = DrawMode.brush,
    this.currentEraserOpacity = 1.0,
    BrushSettings? currentBrush,
    double? currentEraserSize,
    EraserBrushSettings? eraser,
  }) {
    this.currentBrush = currentBrush ??
        BrushStyle.singleStroke.defaultSettings.withScaleFactor(scaleFactor);

    this.currentEraserSize = currentEraserSize ?? (scaleFactor * 16.0);

    this.eraser = eraser ??
        EraserBrushSettings(
          width: this.currentEraserSize,
          opacity: currentEraserOpacity,
        );
  }

  final double scaleFactor;
  final DrawMode drawMode;
  late final BrushSettings currentBrush;

  late final double currentEraserSize;
  final double currentEraserOpacity;
  late final EraserBrushSettings eraser;

  BrushSettings get currentBrushOrEraser {
    return drawMode == DrawMode.brush ? currentBrush : eraser;
  }

  CurrentBrushState copyWith({
    double? scaleFactor,
    DrawMode? drawMode,
    double? currentEraserOpacity,
    BrushSettings? currentBrush,
    double? currentEraserSize,
    EraserBrushSettings? eraser,
  }) {
    return CurrentBrushState(
      scaleFactor: scaleFactor ?? this.scaleFactor,
      drawMode: drawMode ?? this.drawMode,
      currentEraserOpacity: currentEraserOpacity ?? this.currentEraserOpacity,
      currentBrush: currentBrush ?? this.currentBrush,
      currentEraserSize: currentEraserSize ?? this.currentEraserSize,
      eraser: eraser ?? this.eraser,
    );
  }
}

// class CurrentBrushNotifier extends StateNotifier<CurrentBrushState> {
//   CurrentBrushNotifier(super.state);
//
//   void setCurrentBrush(BrushSettings currentBrush) {
//     state = state.copyWith(currentBrush: currentBrush);
//   }
//
//   void setEraserOpacity(double opacity) {
//     assert(opacity <= 1.0 && opacity >= 0.0, 'Opacity is out of range');
//     state = state.copyWith(currentEraserOpacity: opacity);
//   }
// }
