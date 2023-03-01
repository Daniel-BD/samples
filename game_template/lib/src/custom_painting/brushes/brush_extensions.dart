import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import 'brushes.dart';

extension BrushExtensions on BrushStyle {
  String get humanReadableName {
    switch (this) {
      case BrushStyle.singleStroke:
        return "Simple";
      case BrushStyle.stripedStroke:
        return "Striped";
      case BrushStyle.doubleStroke:
        return "Double";
      case BrushStyle.wiggleFilled:
        return "Half Moons";
      case BrushStyle.wiggleNotFilled:
        return "Wiggle";
      case BrushStyle.beads:
        return "Beads";
      case BrushStyle.angledThick:
        return "Marker";
      case BrushStyle.starryNight:
        return "Starry";
      case BrushStyle.splatterDots:
        return "Dots";
      case BrushStyle.triangles:
        return "Triangle";
      case BrushStyle.rainbow:
        return "Rainbow";
      case BrushStyle.eraser:
        return "Eraser";
    }
  }

  BrushSettings get defaultSettings {
    const defaultWidth = 8.0;

    switch (this) {
      case BrushStyle.singleStroke:
        return SingleStrokeBrushSettings(
            color: brushColors.first, width: defaultWidth);
      case BrushStyle.stripedStroke:
        return StripedStrokeBrushSettings(
          firstColor: brushColors[6],
          secondColor: brushColors[17],
          width: defaultWidth,
          minStripeLength: defaultWidth * 2,
          rounded: true,
        );
      case BrushStyle.doubleStroke:
        return DoubleStrokeBrushSettings(
          firstColor: brushColors[11],
          secondColor: brushColors[26],
          width: defaultWidth,
        );
      case BrushStyle.wiggleFilled:
        return WiggleBrushSettings(
          minDiameter: defaultWidth * 2,
          strokeWidth: defaultWidth,
          color: brushColors[6],
          secondColor: brushColors[7],
          filled: true,
          maxDiameter: defaultWidth * 3,
        );
      case BrushStyle.wiggleNotFilled:
        return WiggleBrushSettings(
          minDiameter: defaultWidth * 2,
          strokeWidth: defaultWidth / 2,
          color: brushColors[7],
          filled: false,
          maxDiameter: defaultWidth * 3,
        );
      case BrushStyle.beads:
        return BeadsBrushSettings(
          isRainbowColored: true,
          minCircleDiameter: defaultWidth * 2,
          maxCircleDiameter: defaultWidth * 3,
        );
      case BrushStyle.angledThick:
        return AngledThickBrushSettings(
          color: brushColors[15].withOpacity(0.7),
          width: defaultWidth,
        );
      case BrushStyle.starryNight:
        return StarryNightBrushSettings(
          color: brushColors[12],
          grainLength: 9,
          grainThickness: 4,
          strokeWidth: 2,
        );
        assert(false, 'not yet available!');
        break;
      case BrushStyle.splatterDots:
        return SplatterDotsBrushSettings(
            color: brushColors[10], dotSize: 3, strokeWidth: 12);
        assert(false, 'not yet available!');
        break;
      case BrushStyle.triangles:
        return TriangleBrushSettings(
          minBaseWidth: defaultWidth * 2,
          maxBaseWidth: defaultWidth * 4,
          strokeWidth: defaultWidth / 3,
          color: brushColors[8],
          secondColor: brushColors[9],
        );
      case BrushStyle.rainbow:
        return RainbowBrushSettings(width: 16);
        assert(false, 'not yet available!');
        break;
      case BrushStyle.eraser:
        return EraserBrushSettings(width: defaultWidth);
    }
    assert(false, 'no matches');
    return SingleStrokeBrushSettings(
        color: brushColors.first, width: defaultWidth);
  }

  BrushSettings get randomizedBrush {
    final random = Random();
    List<Color> colors = [...brushColors];
    colors.shuffle();
    final wideBrushWidth = (random.nextInt(30) + 4).toDouble();
    final lessWideBrushWidth = (random.nextInt(16) + 4).toDouble();

    final opacity = random.nextBool()
        ? random.nextBool()
            ? 1.0
            : min(random.nextDouble(), 0.6)
        : 1.0;

    switch (this) {
      case BrushStyle.singleStroke:
        return SingleStrokeBrushSettings(
          color: colors.first.withOpacity(opacity),
          width: wideBrushWidth,
        );
      case BrushStyle.stripedStroke:
        return StripedStrokeBrushSettings(
          firstColor: colors.first,
          secondColor: colors.last,
          width: wideBrushWidth,
          minStripeLength: random.nextInt(20) + 4.0,
          rounded: random.nextBool(),
        );
      case BrushStyle.doubleStroke:
        return DoubleStrokeBrushSettings(
          firstColor: colors.last,
          secondColor: colors.first.withOpacity(opacity),
          width: lessWideBrushWidth,
        );
      case BrushStyle.wiggleFilled:
        return WiggleBrushSettings(
          minDiameter: random.nextInt(20) + 8.0,
          maxDiameter: random.nextInt(50) + 20.0,
          strokeWidth: random.nextInt(12) + 2.0,
          color: colors.first,
          secondColor: colors.last,
          filled: true,
        );
      case BrushStyle.wiggleNotFilled:
        return WiggleBrushSettings(
          minDiameter: random.nextInt(40) + 8.0,
          strokeWidth: random.nextInt(12) + 2.0,
          color: colors.first,
          secondColor: colors.last,
          filled: false,
          maxDiameter: random.nextInt(50) + 20.0,
        );
      case BrushStyle.beads:
        final isRainbowColored = random.nextBool();
        return BeadsBrushSettings(
          color: isRainbowColored ? null : colors.first.withOpacity(opacity),
          isRainbowColored: isRainbowColored,
          minCircleDiameter: random.nextInt(40) + 8.0,
          maxCircleDiameter: random.nextInt(70) + 20.0,
        );
      case BrushStyle.angledThick:
        return AngledThickBrushSettings(
          color: colors.first.withOpacity(opacity),
          width: wideBrushWidth,
        );
      case BrushStyle.starryNight:
        return StarryNightBrushSettings(
          color: colors.first,
          secondColor: colors.last,
          grainLength: random.nextInt(12) + 4,
          grainThickness: random.nextInt(4) + 4,
          strokeWidth: wideBrushWidth,
        );
      case BrushStyle.splatterDots:
        return SplatterDotsBrushSettings(
          color:
              Colors.orange.withOpacity(0.5), //colors.first.withOpacity(0.5),
          dotSize: 6, //random.nextInt(12) + 4.0,
          strokeWidth: 40.0, //brushWidth * 3,
          circular: true, //random.nextBool(),
        );
      case BrushStyle.triangles:
        final double minBaseWidth = random.nextInt(20) + 10;
        return TriangleBrushSettings(
            minBaseWidth: minBaseWidth,
            strokeWidth: random.nextInt(8) + 2,
            color: colors.first.withOpacity(opacity),
            secondColor: colors.last,
            maxBaseWidth: random.nextInt(30) + minBaseWidth);
      case BrushStyle.rainbow:
        return RainbowBrushSettings(width: 6);
      case BrushStyle.eraser:
        return EraserBrushSettings(width: 16);
    }
  }

  BrushSettings brushFromJSON(Map<String, dynamic> json) {
    switch (this) {
      case BrushStyle.singleStroke:
        return SingleStrokeBrushSettings.fromJson(json);
      case BrushStyle.stripedStroke:
        return StripedStrokeBrushSettings.fromJson(json);
      case BrushStyle.doubleStroke:
        return DoubleStrokeBrushSettings.fromJson(json);
      case BrushStyle.wiggleFilled:
        return WiggleBrushSettings.fromJson(json);
      case BrushStyle.wiggleNotFilled:
        return WiggleBrushSettings.fromJson(json);
      case BrushStyle.beads:
        return BeadsBrushSettings.fromJson(json);
      case BrushStyle.angledThick:
        return AngledThickBrushSettings.fromJson(json);
      case BrushStyle.starryNight:
        return StarryNightBrushSettings.fromJson(json);
      case BrushStyle.splatterDots:
        return SplatterDotsBrushSettings.fromJson(json);
      case BrushStyle.triangles:
        return TriangleBrushSettings.fromJson(json);
      case BrushStyle.rainbow:
        return RainbowBrushSettings.fromJson(json);
      case BrushStyle.eraser:
        return EraserBrushSettings.fromJson(json);
    }
  }
}
