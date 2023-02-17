import 'package:flutter/material.dart';
import 'debug.dart';
import 'line_animation.dart';
import 'painter.dart';
import 'parser.dart';

class PathPainterBuilder {
  PathPainterBuilder(LineAnimation? lineAnimation, {required this.scale}) {
    // ignore: prefer_initializing_formals
    this.lineAnimation = lineAnimation;
  }
  List<Paint>? paints;
  void Function(int currentPaintedPathIndex)? onFinishFrame;
  bool? scaleToViewport;
  DebugOptions? debugOptions;
  List<PathSegment>? pathSegments;
  LineAnimation? lineAnimation;
  Animation<double>? animation;
  Size? customDimensions;
  double scale;

  PathPainter build() {
    switch (lineAnimation) {
      case LineAnimation.oneByOne:
        return OneByOnePainter(
            animation, pathSegments, customDimensions, paints, onFinishFrame, scaleToViewport, debugOptions, scale);
      case LineAnimation.allAtOnce:
        return AllAtOncePainter(
            animation, pathSegments, customDimensions, paints, onFinishFrame, scaleToViewport, debugOptions, scale);
      default:
        return PaintedPainter(
            animation, pathSegments, customDimensions, paints, onFinishFrame, scaleToViewport, debugOptions, scale);
    }
  }

  void setAnimation(Animation<double> animation) {
    this.animation = animation;
  }

  void setCustomDimensions(Size? customDimensions) {
    this.customDimensions = customDimensions;
  }

  void setPaints(List<Paint> paints) {
    this.paints = paints;
  }

  void setOnFinishFrame(void Function(int currentPaintedPathIndex) onFinishFrame) {
    this.onFinishFrame = onFinishFrame;
  }

  void setScaleToViewport(bool scaleToViewport) {
    this.scaleToViewport = scaleToViewport;
  }

  void setDebugOptions(DebugOptions? debug) {
    debugOptions = debug;
  }

  void setPathSegments(List<PathSegment> pathSegments) {
    this.pathSegments = pathSegments;
  }
}
