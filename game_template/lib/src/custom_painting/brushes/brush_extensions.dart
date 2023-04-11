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
    double midPoint(double a, double b) {
      assert(!a.isNegative && !b.isNegative);
      return (a + b) / 2;
    }

    switch (this) {
      case BrushStyle.singleStroke:
        return SingleStrokeBrushSettings(
          color: brushColors.first,
          width: midPoint(
            SingleStrokeBrushSettings.minWidth,
            SingleStrokeBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.stripedStroke:
        return StripedStrokeBrushSettings(
          firstColor: brushColors[6],
          secondColor: brushColors[17],
          width: midPoint(
            StripedStrokeBrushSettings.minWidth,
            StripedStrokeBrushSettings.maxWidth,
          ),
          minStripeLength: midPoint(
            StripedStrokeBrushSettings.minMinStripeLength,
            StripedStrokeBrushSettings.maxMinStripeLength,
          ),
          rounded: true,
        );
      case BrushStyle.doubleStroke:
        return DoubleStrokeBrushSettings(
          firstColor: brushColors[11],
          secondColor: brushColors[26],
          width: midPoint(
            DoubleStrokeBrushSettings.minWidth,
            DoubleStrokeBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.wiggleFilled:
        return WiggleBrushSettings(
          minDiameter: midPoint(
            WiggleBrushSettings.minDiameterRange,
            WiggleBrushSettings.maxDiameterRange,
          ),
          strokeWidth: midPoint(
            WiggleBrushSettings.minStrokeWidth,
            WiggleBrushSettings.maxStrokeWidth,
          ),
          color: brushColors[6],
          secondColor: brushColors[7],
          filled: true,
          maxDiameter: midPoint(
            WiggleBrushSettings.minDiameterRange,
            WiggleBrushSettings.maxDiameterRange,
          ),
        );
      case BrushStyle.wiggleNotFilled:
        return WiggleBrushSettings(
          minDiameter: midPoint(
            WiggleBrushSettings.minDiameterRange,
            WiggleBrushSettings.maxDiameterRange,
          ),
          strokeWidth: midPoint(
            WiggleBrushSettings.minStrokeWidth,
            WiggleBrushSettings.maxStrokeWidth,
          ),
          color: brushColors[7],
          filled: false,
          maxDiameter: midPoint(
            WiggleBrushSettings.minDiameterRange,
            WiggleBrushSettings.maxDiameterRange,
          ),
        );
      case BrushStyle.beads:
        return BeadsBrushSettings(
          isRainbowColored: true,
          minCircleDiameter: midPoint(
            BeadsBrushSettings.minDiameter,
            BeadsBrushSettings.maxDiameter,
          ),
          // maxCircleDiameter: midPoint(
          //   BeadsBrushSettings.minDiameter,
          //   BeadsBrushSettings.maxDiameter,
          // ),
        );
      case BrushStyle.angledThick:
        return AngledThickBrushSettings(
          color: brushColors[15].withOpacity(0.7),
          width: midPoint(
            AngledThickBrushSettings.minWidth,
            AngledThickBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.starryNight:
        return StarryNightBrushSettings(
          color: brushColors[12],
          secondColor: brushColors[8],
          grainLength: midPoint(
            StarryNightBrushSettings.minGrainLength,
            StarryNightBrushSettings.maxGrainLength,
          ),
          grainThickness: midPoint(
            StarryNightBrushSettings.minGrainThickness,
            StarryNightBrushSettings.maxGrainThickness,
          ),
          strokeWidth: midPoint(
            StarryNightBrushSettings.minStrokeWidth,
            StarryNightBrushSettings.maxStrokeWidth,
          ),
        );
      case BrushStyle.splatterDots:
        return SplatterDotsBrushSettings(
          color: brushColors[10],
          dotSize: midPoint(
            SplatterDotsBrushSettings.minDotSize,
            SplatterDotsBrushSettings.maxDotSize,
          ),
          strokeWidth: midPoint(
            SplatterDotsBrushSettings.minStrokeWidth,
            SplatterDotsBrushSettings.maxStrokeWidth,
          ),
        );
      case BrushStyle.triangles:
        return TriangleBrushSettings(
          minBaseWidth: midPoint(
            TriangleBrushSettings.minBaseWidthValue,
            TriangleBrushSettings.maxBaseWidthValue,
          ),
          // maxBaseWidth: midPoint(
          //   TriangleBrushSettings.minBaseWidthValue,
          //   TriangleBrushSettings.maxBaseWidthValue,
          // ),
          strokeWidth: midPoint(
            TriangleBrushSettings.minStrokeWidth,
            TriangleBrushSettings.maxStrokeWidth,
          ),
          color: brushColors[8],
          secondColor: brushColors[9],
        );
      case BrushStyle.rainbow:
        return RainbowBrushSettings(
          width: midPoint(
            RainbowBrushSettings.minWidth,
            RainbowBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.eraser:
        return EraserBrushSettings(
          width: midPoint(
            EraserBrushSettings.minWidth,
            EraserBrushSettings.maxWidth,
          ),
        );
    }
  }

  BrushSettings get randomizedBrush {
    final random = Random();
    List<Color> colors = [...brushColors];
    colors.shuffle();
    double doubleInRange(num start, num end) =>
        random.nextDouble() * (end - start) + start;

    final opacity = random.nextBool() ? doubleInRange(0.1, 0.6) : 1.0;

    switch (this) {
      case BrushStyle.singleStroke:
        return SingleStrokeBrushSettings(
          color: colors.first.withOpacity(opacity),
          width: doubleInRange(
            SingleStrokeBrushSettings.minWidth,
            SingleStrokeBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.stripedStroke:
        return StripedStrokeBrushSettings(
          firstColor: colors.first,
          secondColor: colors.last,
          width: doubleInRange(
            StripedStrokeBrushSettings.minWidth,
            StripedStrokeBrushSettings.maxWidth,
          ),
          minStripeLength: doubleInRange(
            StripedStrokeBrushSettings.minMinStripeLength,
            StripedStrokeBrushSettings.maxMinStripeLength,
          ),
          rounded: random.nextBool(),
        );
      case BrushStyle.doubleStroke:
        return DoubleStrokeBrushSettings(
          firstColor: colors.last,
          secondColor: colors.first.withOpacity(opacity),
          width: doubleInRange(
            DoubleStrokeBrushSettings.minWidth,
            DoubleStrokeBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.wiggleFilled:
        final minDiameter = doubleInRange(
          WiggleBrushSettings.minDiameterRange,
          WiggleBrushSettings.maxDiameterRange,
        );
        return WiggleBrushSettings(
          minDiameter: minDiameter,
          maxDiameter: doubleInRange(
            minDiameter,
            WiggleBrushSettings.maxDiameterRange,
          ),
          strokeWidth: doubleInRange(
            WiggleBrushSettings.minStrokeWidth,
            WiggleBrushSettings.maxStrokeWidth,
          ),
          color: colors.first,
          secondColor: colors.last,
          filled: true,
        );
      case BrushStyle.wiggleNotFilled:
        final minDiameter = doubleInRange(
          WiggleBrushSettings.minDiameterRange,
          WiggleBrushSettings.maxDiameterRange,
        );
        return WiggleBrushSettings(
          minDiameter: minDiameter,
          maxDiameter: doubleInRange(
            minDiameter,
            WiggleBrushSettings.maxDiameterRange,
          ),
          strokeWidth: doubleInRange(
            WiggleBrushSettings.minStrokeWidth,
            WiggleBrushSettings.maxStrokeWidth,
          ),
          color: colors.first,
          secondColor: colors.last,
          filled: false,
        );
      case BrushStyle.beads:
        final isRainbowColored = random.nextBool();
        final minDiameter = doubleInRange(
          BeadsBrushSettings.minDiameter,
          BeadsBrushSettings.maxDiameter,
        );
        return BeadsBrushSettings(
          color: isRainbowColored ? null : colors.first.withOpacity(opacity),
          isRainbowColored: isRainbowColored,
          minCircleDiameter: minDiameter,
          // maxCircleDiameter: doubleInRange(
          //   minDiameter,
          //   BeadsBrushSettings.maxDiameter,
          // ),
        );
      case BrushStyle.angledThick:
        return AngledThickBrushSettings(
          color: colors.first.withOpacity(opacity),
          width: doubleInRange(
            AngledThickBrushSettings.minWidth,
            AngledThickBrushSettings.maxWidth,
          ),
        );
      case BrushStyle.starryNight:
        return StarryNightBrushSettings(
          color: colors.first,
          secondColor: colors.last,
          grainLength: doubleInRange(
            StarryNightBrushSettings.minGrainLength,
            StarryNightBrushSettings.maxGrainLength,
          ),
          grainThickness: doubleInRange(
            StarryNightBrushSettings.minGrainThickness,
            StarryNightBrushSettings.maxGrainThickness,
          ),
          strokeWidth: doubleInRange(
            StarryNightBrushSettings.minStrokeWidth,
            StarryNightBrushSettings.maxStrokeWidth,
          ),
          sprawl: doubleInRange(
            StarryNightBrushSettings.minSprawl,
            StarryNightBrushSettings.maxSprawl,
          ),
        );
      case BrushStyle.splatterDots:
        return SplatterDotsBrushSettings(
          color: colors.first.withOpacity(opacity),
          dotSize: doubleInRange(
            SplatterDotsBrushSettings.minDotSize,
            SplatterDotsBrushSettings.maxDotSize,
          ),
          strokeWidth: doubleInRange(
            SplatterDotsBrushSettings.minStrokeWidth,
            SplatterDotsBrushSettings.maxStrokeWidth,
          ),
          circular: random.nextBool(),
        );
      case BrushStyle.triangles:
        final minBaseWidth = doubleInRange(
          TriangleBrushSettings.minBaseWidthValue,
          TriangleBrushSettings.maxBaseWidthValue,
        );
        return TriangleBrushSettings(
          minBaseWidth: minBaseWidth,
          // maxBaseWidth: doubleInRange(
          //   minBaseWidth,
          //   TriangleBrushSettings.maxBaseWidthValue,
          // ),
          strokeWidth: doubleInRange(
            TriangleBrushSettings.minStrokeWidth,
            TriangleBrushSettings.maxStrokeWidth,
          ),
          heightFactor: doubleInRange(
            TriangleBrushSettings.minHeightFactor,
            TriangleBrushSettings.maxHeightFactor,
          ),
          color: colors.first.withOpacity(opacity),
          secondColor: colors.last,
        );
      case BrushStyle.rainbow:
        return RainbowBrushSettings(
            width: doubleInRange(
          RainbowBrushSettings.minWidth,
          RainbowBrushSettings.maxWidth,
        ));
      case BrushStyle.eraser:
        return EraserBrushSettings(
            width: doubleInRange(
          EraserBrushSettings.minWidth,
          EraserBrushSettings.maxWidth,
        ));
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
