import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../theme/colors.dart';

const List<BrushStyle> availableBrushes = [
  BrushStyle.singleStroke,
  BrushStyle.stripedStroke,
  BrushStyle.doubleStroke,
  BrushStyle.wiggleFilled,
  BrushStyle.wiggleNotFilled,
  BrushStyle.angledThick,
  BrushStyle.triangles,
  BrushStyle.beads,
  BrushStyle.starryNight,
  BrushStyle.splatterDots,
  BrushStyle.rainbow,
  BrushStyle.eraser
  //Todo: gör en dashed? https://medium.com/flutter-community/playing-with-paths-in-flutter-97198ba046c8
];

// DON'T CHANGE THE NAMES OF THESE! DOING SO WILL BREAK JSON SERIALIZATION.
enum BrushStyle {
  singleStroke,
  stripedStroke,
  doubleStroke,
  wiggleFilled,
  wiggleNotFilled,
  beads,
  angledThick,
  starryNight,
  splatterDots,
  triangles,
  rainbow,
  eraser,
}

class BrushStroke {}

abstract class BrushSettings extends Equatable {
  const BrushSettings(this.brushStyle);
  final BrushStyle brushStyle;

  /// Returns a copy with sizes scaled according to scaleFactor
  BrushSettings withScaleFactor(double scaleFactor);

  BrushLine getBrushLineWithSettings();

  Map<String, dynamic> toJson();

  BrushSettings copyWith();
}

abstract class BrushLine {
  BrushLine(this.settings);
  List<Tuple2<Path, Paint>> pathsAndPaints = [];

  final BrushSettings settings;
  List<Offset> _line = [];
  bool userIsCurrentlyDrawing = true;

  /// Should be called everytime a new point is added to the BrushLine.
  /// Adds a [Path] and a [Paint] to [pathsAndPaints] corresponding to the brush settings and style.
  void updatePathAndPaint();

  void addPoint(Offset point) {
    _line.add(point);
    updatePathAndPaint();
  }

  @mustCallSuper
  void endLine() {
    userIsCurrentlyDrawing = false;
  }

  List<Offset> getLine() {
    if (userIsCurrentlyDrawing) {
      return _getLineWhileUserIsDrawing();
    } else {
      return _getEndedLine();
    }
  }

  List<Offset> _getLineWhileUserIsDrawing() {
    return _line;
  }

  List<Offset> _getEndedLine() {
    return _line;
  }

  List<Tuple2<Path, Paint>> getPathsAndPaints() {
    return pathsAndPaints;
  }

  /*Stopwatch s = Stopwatch();

  void startStopwatch() {
    s.reset();
    s.start();
  }

  void stopStopwatch() {
    s.stop();
    print('${settings.brushStyle} took ${s.elapsedMicroseconds}');
  }*/
}

/// Brush implementations
///
///

/// [BrushStyle.singleStroke] implementations
///
///

class SingleStrokeBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  SingleStrokeBrushSettings({required this.color, required this.width})
      : super(BrushStyle.singleStroke);

  late final Color color;
  late final double width;

  @override
  BrushLine getBrushLineWithSettings() {
    return SingleStrokeBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return SingleStrokeBrushSettings(color: color, width: width * scaleFactor);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.singleStroke.name,
      "color": color.value,
      "width": width,
    };
  }

  SingleStrokeBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.singleStroke) {
    color = Color(json["color"] as int);
    width = json["width"] as double;
  }

  @override
  SingleStrokeBrushSettings copyWith({
    Color? color,
    double? width,
  }) {
    return SingleStrokeBrushSettings(
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }

  @override
  List<Object?> get props => [super.brushStyle, color, width];
}

class SingleStrokeBrushLine extends BrushLine {
  SingleStrokeBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final SingleStrokeBrushSettings settings;

  @override
  void updatePathAndPaint() {
    if (_line.length > 1) {
      final p0 = _line[_line.length - 2];
      final p1 = _line[_line.length - 1];
      pathsAndPaints.last.item1.quadraticBezierTo(
          p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
    } else if (_line.isNotEmpty) {
      pathsAndPaints.add(Tuple2(
        Path()
          ..moveTo(_line.first.dx, _line.first.dy)
          ..lineTo(_line.first.dx, _line.first.dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = settings.color
          ..strokeWidth = settings.width,
      ));
    }
  }
}

/// [BrushStyle.stripedStroke] implementations
///
///

class StripedStrokeBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  StripedStrokeBrushSettings({
    required this.firstColor,
    required this.secondColor,
    required this.width,
    required this.minStripeLength,
    required this.rounded,
  }) : super(BrushStyle.stripedStroke);

  late final Color firstColor;
  late final Color secondColor;
  late final double width;
  late final double minStripeLength;
  late final bool rounded;

  @override
  BrushLine getBrushLineWithSettings() {
    return StripedStrokeBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return StripedStrokeBrushSettings(
      firstColor: firstColor,
      secondColor: secondColor,
      width: width * scaleFactor,
      minStripeLength: minStripeLength * scaleFactor,
      rounded: rounded,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.stripedStroke.name,
      "firstColor": firstColor.value,
      "secondColor": secondColor.value,
      "width": width,
      "minStripeLength": minStripeLength,
      "rounded": rounded,
    };
  }

  StripedStrokeBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.stripedStroke) {
    firstColor = Color(json["firstColor"] as int);
    secondColor = Color(json["secondColor"] as int);
    width = json["width"] as double;
    minStripeLength = json["minStripeLength"] as double;
    rounded = json["rounded"] as bool;
  }

  @override
  StripedStrokeBrushSettings copyWith({
    Color? firstColor,
    Color? secondColor,
    double? width,
    double? minStripeLength,
    bool? rounded,
  }) {
    return StripedStrokeBrushSettings(
      firstColor: firstColor ?? this.firstColor,
      secondColor: secondColor ?? this.secondColor,
      width: width ?? this.width,
      minStripeLength: minStripeLength ?? this.minStripeLength,
      rounded: rounded ?? this.rounded,
    );
  }

  @override
  List<Object?> get props => [
        super.brushStyle,
        firstColor,
        secondColor,
        width,
        minStripeLength,
        rounded
      ];
}

//TODO: This brush adds duplicate lines, try with opacity to see what I mean. Fix this for performance.
class StripedStrokeBrushLine extends BrushLine {
  StripedStrokeBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final StripedStrokeBrushSettings settings;

  @override
  void addPoint(Offset point) {
    if (_line.isNotEmpty) {
      final xDiff = point.dx - _line.last.dx;
      final yDiff = point.dy - _line.last.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      if (realDistance >= settings.minStripeLength) {
        _line.add(point);
      }
    } else {
      _line.add(point);
    }

    updatePathAndPaint();
  }

  @override
  void updatePathAndPaint() {
    if (_line.length > 1) {
      final p0 = _line[_line.length - 2];
      final p1 = _line[_line.length - 1];
      Path path = Path()..moveTo(p0.dx, p0.dy);
      path.lineTo(p1.dx, p1.dy);

      pathsAndPaints.add(Tuple2(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = settings.rounded ? StrokeCap.round : StrokeCap.butt
          ..color = (_line.length - 1).isOdd
              ? settings.firstColor
              : settings.secondColor
          ..strokeWidth = settings.width,
      ));
    }
  }
}

/// [BrushStyle.doubleStroke] implementations
///
///

class DoubleStrokeBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  DoubleStrokeBrushSettings({
    required this.firstColor,
    required this.secondColor,
    required this.width,
  }) : super(BrushStyle.doubleStroke);

  late final Color firstColor;
  late final Color secondColor;
  late final double width;

  @override
  List<Object?> get props => [super.brushStyle, firstColor, secondColor, width];

  @override
  BrushLine getBrushLineWithSettings() {
    return DoubleStrokeBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return DoubleStrokeBrushSettings(
      firstColor: firstColor,
      secondColor: secondColor,
      width: width * scaleFactor,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.doubleStroke.name,
      "firstColor": firstColor.value,
      "secondColor": secondColor.value,
      "width": width,
    };
  }

  DoubleStrokeBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.doubleStroke) {
    firstColor = Color(json["firstColor"] as int);
    secondColor = Color(json["secondColor"] as int);
    width = json["width"] as double;
  }

  @override
  DoubleStrokeBrushSettings copyWith({
    Color? firstColor,
    Color? secondColor,
    double? width,
  }) {
    return DoubleStrokeBrushSettings(
      firstColor: firstColor ?? this.firstColor,
      secondColor: secondColor ?? this.secondColor,
      width: width ?? this.width,
    );
  }
}

class DoubleStrokeBrushLine extends BrushLine {
  DoubleStrokeBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final DoubleStrokeBrushSettings settings;

  @override
  void updatePathAndPaint() {
    final translationOffset = Offset(-settings.width, settings.width);

    if (_line.length == 1) {
      final firstPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = settings.secondColor
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.bevel
        ..strokeWidth = settings.width;

      final secondPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = settings.firstColor
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.bevel
        ..strokeWidth = settings.width;

      Path path = Path()..moveTo(_line.first.dx, _line.first.dy);

      pathsAndPaints.add(Tuple2(path.shift(translationOffset), secondPaint));
      pathsAndPaints.add(Tuple2(path, firstPaint));

      final p1 = _line.last;
      pathsAndPaints[1].item1.lineTo(p1.dx, p1.dy);
      final p1Shifted = p1.translateWithOffset(translationOffset);
      pathsAndPaints[0].item1.lineTo(p1Shifted.dx, p1Shifted.dy);
    } else if (_line.length > 1) {
      final p0 = _line[_line.length - 2];
      final p1 = _line[_line.length - 1];
      pathsAndPaints[1].item1.quadraticBezierTo(
          p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);

      final p0Shifted = p0.translateWithOffset(translationOffset);
      final p1Shifted = p1.translateWithOffset(translationOffset);
      pathsAndPaints[0].item1.quadraticBezierTo(p0Shifted.dx, p0Shifted.dy,
          (p0Shifted.dx + p1Shifted.dx) / 2, (p0Shifted.dy + p1Shifted.dy) / 2);
    }
  }
}

/// [BrushStyle.wiggleStroked] and [BrushStyle.wiggleFilled] implementations
///
///
//TODO: This brush adds duplicate lines, try with opacity to see what I mean. Fix this for performance. Maybe more brushes do this.
class WiggleBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  WiggleBrushSettings({
    required this.strokeWidth,
    required this.color,
    this.secondColor,
    required this.minDiameter,
    required this.maxDiameter,
    required this.filled,
  }) : super(filled ? BrushStyle.wiggleFilled : BrushStyle.wiggleNotFilled);

  late final bool filled;
  late final double maxDiameter;
  late final double minDiameter;
  late final double strokeWidth;
  late final Color color;
  late final Color? secondColor;

  @override
  WiggleBrushSettings copyWith({
    bool? filled,
    double? strokeWidth,
    Color? color,
    Color? secondColor,
    double? maxDiameter,
    double? minDiameter,
  }) {
    return WiggleBrushSettings(
      filled: filled ?? this.filled,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      secondColor: secondColor ?? this.secondColor,
      maxDiameter: maxDiameter ?? this.maxDiameter,
      minDiameter: minDiameter ?? this.minDiameter,
    );
  }

  @override
  List<Object?> get props => [
        super.brushStyle,
        filled,
        color,
        secondColor,
        minDiameter,
        maxDiameter,
        strokeWidth
      ];

  @override
  BrushLine getBrushLineWithSettings() {
    return WiggleBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return WiggleBrushSettings(
      strokeWidth: strokeWidth * scaleFactor,
      color: color,
      secondColor: secondColor,
      minDiameter: minDiameter * scaleFactor,
      maxDiameter: maxDiameter * scaleFactor,
      filled: filled,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": filled
          ? BrushStyle.wiggleFilled.name
          : BrushStyle.wiggleNotFilled.name,
      "width": strokeWidth,
      "color": color.value,
      "secondColor": secondColor?.value,
      "minDiameter": minDiameter,
      "maxDiameter": maxDiameter,
      "filled": filled,
    };
  }

  WiggleBrushSettings.fromJson(Map<String, dynamic> json)
      : super(json["filled"] as bool
            ? BrushStyle.wiggleFilled
            : BrushStyle.wiggleNotFilled) {
    strokeWidth = json["width"] as double;
    color = Color(json["color"] as int);
    secondColor =
        json["secondColor"] != null ? Color(json["secondColor"] as int) : null;
    minDiameter = json["minDiameter"] as double;
    maxDiameter = json["maxDiameter"] as double;
    filled = json["filled"] as bool;
  }
}

class WiggleBrushLine extends BrushLine {
  WiggleBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final WiggleBrushSettings settings;

  @override
  void endLine() {
    _line = _getLineWithMinimumDistanceEnforced();
    super.endLine();
  }

  @override
  List<Offset> _getEndedLine() {
    return _line;
  }

  @override
  List<Offset> _getLineWhileUserIsDrawing() {
    return _getLineWithMinimumDistanceEnforced();
  }

  List<Offset> _getLineWithMinimumDistanceEnforced() {
    if (_line.isEmpty) {
      return [];
    }

    final List<Offset> lineCopy = [];
    lineCopy.add(_line.first);

    for (int i = 1; i < _line.length; i++) {
      final xDiff = _line[i].dx - lineCopy.last.dx;
      final yDiff = _line[i].dy - lineCopy.last.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      if (realDistance >= settings.minDiameter) {
        lineCopy.add(_line[i]);
      }
    }

    return lineCopy;
  }

  late final firstPaint = Paint()
    ..strokeCap = StrokeCap.round
    ..style = settings.filled ? PaintingStyle.fill : PaintingStyle.stroke
    ..strokeWidth = settings.strokeWidth
    ..color = settings.color;

  late final secondPaint = Paint()
    ..strokeCap = StrokeCap.round
    ..style = settings.filled ? PaintingStyle.fill : PaintingStyle.stroke
    ..strokeWidth = settings.strokeWidth
    ..color = !settings.filled
        ? settings.color
        : settings.secondColor ?? settings.color;

  @override
  void updatePathAndPaint() {
    if (getLine().length > 1) {
      final nextToLastPointIndex = getLine().length - 2;
      final lastPointIndex = getLine().length - 1;
      final p0 = getLine()[nextToLastPointIndex];
      final p1 = getLine()[lastPointIndex];

      final xDiff = p1.dx - p0.dx;
      final yDiff = p1.dy - p0.dy;
      final realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      final angle = atan2(p1.dy - p0.dy, p1.dx - p0.dx);
      final flipAngle = lastPointIndex.isEven ? pi : 0;

      pathsAndPaints.add(Tuple2(
        Path()
          ..moveTo(p0.dx, p0.dy)
          ..arcTo(
              Rect.fromCenter(
                center: Offset.lerp(p1, p0, 0.5)!,
                width: realDistance,
                height: realDistance,
              ),
              angle + flipAngle,
              pi,
              true),
        lastPointIndex.isOdd ? firstPaint : secondPaint,
      ));
    }
  }
}

/// [BrushStyle.beads] implementations
///
///

class BeadsBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  BeadsBrushSettings({
    this.color,
    required this.isRainbowColored,
    required this.minCircleDiameter,
    required this.maxCircleDiameter,
    this.continueRainbow = true,
  })  : assert(
            isRainbowColored && color == null ||
                !isRainbowColored && color != null,
            "If rainbowColors ìs true, then colors should be null and vice versa"),
        super(BrushStyle.beads);

  late final Color? color;
  late final bool isRainbowColored;
  late final double minCircleDiameter;
  late final double maxCircleDiameter;
  late final bool continueRainbow;

  @override
  BeadsBrushSettings copyWith({
    Color? color,
    bool? isRainbowColored,
    double? minCircleDiameter,
    double? maxCircleDiameter,
    bool? continueRainbow,
  }) {
    return BeadsBrushSettings(
      color: color ?? this.color,
      isRainbowColored: isRainbowColored ?? this.isRainbowColored,
      minCircleDiameter: minCircleDiameter ?? this.minCircleDiameter,
      maxCircleDiameter: maxCircleDiameter ?? this.maxCircleDiameter,
      continueRainbow: continueRainbow ?? this.continueRainbow,
    );
  }

  @override
  List<Object?> get props => [
        super.brushStyle,
        color,
        isRainbowColored,
        minCircleDiameter,
        maxCircleDiameter,
      ];

  @override
  BrushLine getBrushLineWithSettings() {
    return BeadsBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return BeadsBrushSettings(
      color: color,
      isRainbowColored: isRainbowColored,
      minCircleDiameter: minCircleDiameter * scaleFactor,
      maxCircleDiameter: maxCircleDiameter * scaleFactor,
      continueRainbow: continueRainbow,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.beads.name,
      "color": color?.value,
      "isRainbowColored": isRainbowColored,
      "minCircleDiameter": minCircleDiameter,
      "maxCircleDiameter": maxCircleDiameter,
    };
  }

  BeadsBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.beads) {
    color = json["color"] != null ? Color(json["color"] as int) : null;
    isRainbowColored = json["isRainbowColored"] as bool;
    minCircleDiameter = json["minCircleDiameter"] as double;
    maxCircleDiameter = json["maxCircleDiameter"] as double;
    continueRainbow = true;
  }
}

class BeadsBrushLine extends BrushLine {
  BeadsBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final BeadsBrushSettings settings;

  @override
  void endLine() {
    _line = _getLineWithMinimumDistanceEnforced();
    super.endLine();
  }

  List<Offset> _getLineWithMinimumDistanceEnforced() {
    if (_line.isEmpty) {
      return [];
    }

    final List<Offset> lineCopy = [];
    lineCopy.add(_line.first);

    for (int i = 1; i < _line.length; i++) {
      final xDiff = _line[i].dx - lineCopy.last.dx;
      final yDiff = _line[i].dy - lineCopy.last.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      if (realDistance >= settings.minCircleDiameter) {
        lineCopy.add(_line[i]);
      }
    }

    return lineCopy;
  }

  @override
  List<Offset> _getEndedLine() {
    return _line;
  }

  @override
  List<Offset> _getLineWhileUserIsDrawing() {
    return _getLineWithMinimumDistanceEnforced();
  }

  // Used if continueRainbow is true
  static var rainbowColorIndex = 0.0;
  // Used if continueRainbow is false
  var rciNotContinued = 0.0;
  var rainbowColorStep = 8;
  late var paint = Paint()
    ..style = PaintingStyle.fill
    ..color = settings.color ?? Colors.transparent;

  Paint getNextPaint() {
    if (settings.isRainbowColored) {
      var nextPaint = Paint()
        ..color = HSVColor.fromAHSV(
                1.0,
                settings.continueRainbow ? rainbowColorIndex : rciNotContinued,
                1.0,
                1.0)
            .toColor();
      settings.continueRainbow
          ? rainbowColorIndex += rainbowColorStep
          : rciNotContinued += rainbowColorStep;
      if ((settings.continueRainbow ? rainbowColorIndex : rciNotContinued) >
          360.0) {
        settings.continueRainbow ? rainbowColorIndex = 0 : rciNotContinued = 0;
      }

      return nextPaint;
    } else {
      return paint;
    }
  }

  var lastRenderedPoint = const Offset(-1, -1);
  //List<double> circleRadiuses = [];

  @override
  void updatePathAndPaint() {
    if (lastRenderedPoint == getLine().last) {
      return;
    }
    if (getLine().length > 1) {
      final p0 = getLine()[getLine().length - 2];
      final p1 = getLine().last;

      final xDiff = p1.dx - p0.dx;
      final yDiff = p1.dy - p0.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);

      if (realDistance > settings.maxCircleDiameter) {
        final circlesCount = realDistance ~/ (settings.maxCircleDiameter);
        final partLength = realDistance / circlesCount;

        for (int m = 0; m < circlesCount; m++) {
          final t = (partLength / realDistance) * (m + 0.5);

          var path = Path()
            ..addOval(Rect.fromCircle(
                center: Offset.lerp(p0, p1, t)!, radius: partLength / 2));
          pathsAndPaints.add(Tuple2(path, getNextPaint()));
          //circleRadiuses.add(partLength / 2);
        }
      } else {
        //final radius = realDistance - circleRadiuses.last;
        var path = Path()
          ..addOval(Rect.fromCircle(
              center: Offset.lerp(p0, p1, 0.5)!, radius: realDistance / 2));
        pathsAndPaints.add(Tuple2(path, getNextPaint()));
        //circleRadiuses.add(realDistance / 2);
      }
    } else if (getLine().length == 1) {
      var path = Path()
        ..addOval(Rect.fromCircle(
            center: getLine().first, radius: settings.minCircleDiameter / 2));
      pathsAndPaints.add(Tuple2(path, getNextPaint()));
      //circleRadiuses.add(settings.minCircleDiameter / 2);
    }
    lastRenderedPoint = getLine().last;
  }
}

/// [BrushStyle.angledThick] implementations
///
///

class AngledThickBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  AngledThickBrushSettings({
    required this.color,
    required this.width,
  }) : super(BrushStyle.angledThick);

  late final Color color;
  late final double width;

  @override
  AngledThickBrushSettings copyWith({
    Color? color,
    double? width,
  }) {
    return AngledThickBrushSettings(
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }

  @override
  List<Object?> get props => [super.brushStyle, color, width];

  @override
  BrushLine getBrushLineWithSettings() {
    return AngledThickBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return AngledThickBrushSettings(
      color: color,
      width: width * scaleFactor,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.angledThick.name,
      "color": color.value,
      "width": width,
    };
  }

  AngledThickBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.angledThick) {
    color = Color(json["color"] as int);
    width = json["width"] as double;
  }
}

class AngledThickBrushLine extends BrushLine {
  AngledThickBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final AngledThickBrushSettings settings;

  List<List<Offset>> _computedLines = [];

  List<List<Offset>> getComputedLines() {
    if (userIsCurrentlyDrawing) {
      return _getComputedLines();
    } else {
      return _computedLines;
    }
  }

  @override
  void endLine() {
    _computedLines = _getComputedLines();
    super.endLine();
  }

  List<List<Offset>> _getComputedLines() {
    List<List<Offset>> calculatedLines = [];
    bool? xDirWasPositive;
    bool? yDirWasPositive;
    int lastNewLineIndex = 0;
    bool lastLineIsClosed = false;
    double xTranslate = 0.0;
    double yTranslate = 0.0;

    for (int i = 2; i < getLine().length; i++) {
      if (i == 2) {
        final xDiff = getLine()[i].dx - getLine().first.dx;
        final yDiff = getLine()[i].dy - getLine().first.dy;
        xDirWasPositive = !xDiff.isNegative;
        yDirWasPositive = !yDiff.isNegative;

        final xDiffProportion = xDiff.abs() / (xDiff.abs() + yDiff.abs());
        final yDiffProportion = yDiff.abs() / (xDiff.abs() + yDiff.abs());

        xTranslate = xDirWasPositive
            ? settings.width * yDiffProportion
            : -settings.width * yDiffProportion;
        yTranslate = yDirWasPositive
            ? -settings.width * xDiffProportion
            : settings.width * xDiffProportion;

        calculatedLines.add([
          Offset(getLine().first.translate(xTranslate, yTranslate).dx,
              getLine().first.translate(xTranslate, yTranslate).dy)
        ]);
      }

      bool xDirIsPositive = getLine()[i].dx > getLine()[i - 1].dx;
      bool yDirIsPositive = getLine()[i].dy > getLine()[i - 1].dy;

      calculatedLines.last.add(Offset(
          getLine()[i].translate(xTranslate, yTranslate).dx,
          getLine()[i].translate(xTranslate, yTranslate).dy));

      if (xDirIsPositive != xDirWasPositive ||
          yDirIsPositive != yDirWasPositive) {
        ///Close last path and make new one.
        for (int m = i - 0; m >= lastNewLineIndex; m--) {
          calculatedLines.last.add(Offset(
              getLine()[m].translate(-xTranslate, -yTranslate).dx,
              getLine()[m].translate(-xTranslate, -yTranslate).dy));
        }
        lastNewLineIndex = i - 0;

        calculatedLines.last.add(calculatedLines.last.first);

        List<Offset> newCalculatedLine = [
          Offset(getLine()[i - 0].translate(xTranslate, yTranslate).dx,
              getLine()[i - 0].translate(xTranslate, yTranslate).dy)
        ];
        calculatedLines.add(newCalculatedLine);
        calculatedLines.last.add(Offset(
            getLine()[i].translate(xTranslate, yTranslate).dx,
            getLine()[i].translate(xTranslate, yTranslate).dy));

        lastLineIsClosed = true;
      } else {
        lastLineIsClosed = false;
      }

      xDirWasPositive = xDirIsPositive;
      yDirWasPositive = yDirIsPositive;
    }

    if (calculatedLines.isNotEmpty && !lastLineIsClosed) {
      for (int m = getLine().length - 1; m >= lastNewLineIndex; m--) {
        calculatedLines.last.add(Offset(
            getLine()[m].translate(-xTranslate, -yTranslate).dx,
            getLine()[m].translate(-xTranslate, -yTranslate).dy));
      }
      calculatedLines.last.add(calculatedLines.last.first);
    }

    return calculatedLines;
  }

  late final paint = Paint()
    ..color = settings.color
    ..style = PaintingStyle.fill;

  int currentLineIndex = -1;

  @override
  void updatePathAndPaint() {
    pathsAndPaints = [];
    for (final line in getComputedLines()) {
      var path = Path()..moveTo(line.first.dx, line.first.dy);
      for (final point in line) {
        path.lineTo(point.dx, point.dy);
      }

      pathsAndPaints.add(Tuple2(path, paint));
    }

    /*final lines = getComputedLines();
    if (lines.isNotEmpty /*&& lines.length != currentLineIndex*/) {
      final path = Path()..moveTo(lines.last.first.dx, lines.last.first.dy);
      path..lineTo(lines.last.last.dx, lines.last.last.dy);
      pathsAndPaints.add(Tuple2(path, paint));
      currentLineIndex = lines.length;
    }

    if (lines.isNotEmpty && lines.last.length > 0) {
      for (final point in lines.last) {
        pathsAndPaints.last.item1.lineTo(point.dx, point.dy);
      }
    }*/
  }
}

/// [BrushStyle.starryNight] implementations
///
///

class StarryNightBrushSettings extends BrushSettings {
  StarryNightBrushSettings({
    required this.color,
    required this.grainLength,
    required this.grainThickness,
    required this.strokeWidth,
    this.sprawl = 0.25,
    this.lerps = 6,
    Color? secondColor,
  })  : assert(sprawl >= 0 && sprawl <= 1,
            'randomness must be between 0 and 1 inclusive.'),
        assert(lerps.isEven && lerps >= 2 && lerps <= 12,
            'lerps does not satisfy requirements'),
        super(BrushStyle.starryNight) {
    this.secondColor = secondColor ?? color;
  }

  late final Color color;
  late final Color secondColor;
  late final double grainLength;
  late final double grainThickness;
  late final double strokeWidth;
  late final double sprawl;

  @override
  StarryNightBrushSettings copyWith({
    Color? color,
    Color? secondColor,
    double? grainLength,
    double? grainThickness,
    double? strokeWidth,
    double? sprawl,
  }) {
    return StarryNightBrushSettings(
      color: color ?? this.color,
      secondColor: secondColor ?? this.secondColor,
      grainLength: grainLength ?? this.grainLength,
      grainThickness: grainThickness ?? this.grainThickness,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      sprawl: sprawl ?? this.sprawl,
    );
  }

  @override
  List<Object?> get props => [
        super.brushStyle,
        color,
        secondColor,
        grainLength,
        grainThickness,
        strokeWidth,
        sprawl,
      ];

  /// Must be an even number
  late final int lerps;

  @override
  BrushLine getBrushLineWithSettings() {
    return StarryNightBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return StarryNightBrushSettings(
      color: color,
      grainLength: grainLength * scaleFactor,
      grainThickness: grainThickness * scaleFactor,
      strokeWidth: strokeWidth * scaleFactor,
      sprawl: sprawl,
      lerps: lerps,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.starryNight.name,
      "color": color.value,
      "secondColor": secondColor.value,
      "grainLength": grainLength,
      "grainThickness": grainThickness,
      "width": strokeWidth,
      "sprawl": sprawl,
      "lerps": lerps,
    };
  }

  StarryNightBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.starryNight) {
    color = Color(json["color"] as int);
    secondColor = Color(json["secondColor"] as int);
    grainLength = json["grainLength"] as double;
    grainThickness = json["grainThickness"] as double;
    strokeWidth = json["width"] as double;
    sprawl = json["sprawl"] as double;
    lerps = json["lerps"] as int;
  }
}

class StarryNightBrushLine extends BrushLine {
  StarryNightBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final StarryNightBrushSettings settings;
  final List<Offset> rawPoints = [];
  final _random = Random();

  @override
  void addPoint(Offset point) {
    if (rawPoints.isNotEmpty) {
      final xDiff = point.dx - rawPoints.last.dx;
      final yDiff = point.dy - rawPoints.last.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      if (realDistance >= settings.grainLength / 2) {
        rawPoints.add(point);
        _addStrokes();
      }
    } else {
      rawPoints.add(point);
    }
    updatePathAndPaint();
  }

  void _addStrokes() {
    assert(rawPoints.length > 1, 'rawPoints should have at least 2 points');
    if (rawPoints.length < 2) {
      return;
    }

    final angle = atan2(
      rawPoints.last.dy - rawPoints[rawPoints.length - 2].dy,
      rawPoints.last.dx - rawPoints[rawPoints.length - 2].dx,
    );

    for (int i = 0; i < settings.lerps; i++) {
      final random1 =
          _random.nextBool() ? _random.nextDouble() : -_random.nextDouble();
      final random2 =
          _random.nextBool() ? _random.nextDouble() : -_random.nextDouble();
      final random3 =
          _random.nextBool() ? _random.nextDouble() : -_random.nextDouble();
      final random4 =
          _random.nextBool() ? _random.nextDouble() : -_random.nextDouble();

      var offset1 = rawPoints.last.translate(
          settings.strokeWidth * random1, settings.strokeWidth * random2);
      final offset2 = offset1
          .translate(settings.grainLength * cos(angle),
              settings.grainLength * sin(angle))
          .translate(0.5 * settings.sprawl * settings.strokeWidth * random3,
              0.5 * settings.sprawl * settings.strokeWidth * random4);

      _line.add(offset1);
      _line.add(offset2);
    }
  }

  late final evenPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = settings.color
    ..strokeCap = StrokeCap.round
    ..strokeWidth = settings.grainThickness;

  late final oddPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = settings.secondColor
    ..strokeCap = StrokeCap.round
    ..strokeWidth = settings.grainThickness;

  var colorToggle = true;
  var currentIndex = 0;
  late final numberOfNewPoints = settings.lerps * 2;
  @override
  void updatePathAndPaint() {
    currentIndex = _line.length - numberOfNewPoints;
    if (currentIndex < 0 || currentIndex > _line.length) {
      return;
    }

    for (int i = currentIndex; i < _line.length; i += 2) {
      if (i >= _line.length - 1) {
        break;
      }
      var path = Path()
        ..moveTo(_line[i].dx, _line[i].dy)
        ..lineTo(_line[i + 1].dx, _line[i + 1].dy);
      pathsAndPaints.add(Tuple2(path, colorToggle ? evenPaint : oddPaint));
      colorToggle = !colorToggle;
    }
  }
}

/// [BrushStyle.splatterDots] implementations
///
///

class SplatterDotsBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  SplatterDotsBrushSettings({
    required this.color,
    required this.dotSize,
    required this.strokeWidth,
    this.lerps = 2,
    this.circular = false,
  }) : super(BrushStyle.splatterDots);

  late final Color color;
  late final double dotSize;
  late final double strokeWidth;
  late final int lerps;
  late final bool circular;

  @override
  SplatterDotsBrushSettings copyWith({
    Color? color,
    double? dotSize,
    double? strokeWidth,
    int? lerps,
    bool? circular,
  }) {
    return SplatterDotsBrushSettings(
      color: color ?? this.color,
      dotSize: dotSize ?? this.dotSize,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      lerps: lerps ?? this.lerps,
      circular: circular ?? this.circular,
    );
  }

  @override
  List<Object?> get props => [
        super.brushStyle,
        color,
        dotSize,
        strokeWidth,
        lerps,
        circular,
      ];

  @override
  BrushLine getBrushLineWithSettings() {
    return SplatterDotsBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return SplatterDotsBrushSettings(
      color: color,
      dotSize: dotSize * scaleFactor,
      strokeWidth: strokeWidth * scaleFactor,
      lerps: lerps,
      circular: circular,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.splatterDots.name,
      "color": color.value,
      "dotSize": dotSize,
      "strokeWidth": strokeWidth,
      "lerps": lerps,
      "circular": circular,
    };
  }

  SplatterDotsBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.splatterDots) {
    color = Color(json["color"] as int);
    dotSize = json["dotSize"] as double;
    strokeWidth = json["strokeWidth"] as double;
    lerps = json["lerps"] as int;
    circular = json["circular"] as bool;
  }
}

class SplatterDotsBrushLine extends BrushLine {
  SplatterDotsBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final SplatterDotsBrushSettings settings;

  final _random = Random();

  @override
  void addPoint(Offset point) {
    if (settings.circular) {
      final r = settings.strokeWidth / 2;
      final rSquared = r * r;

      for (int j = 0; j < settings.lerps; j++) {
        final double randomX = _random.nextBool()
            ? _random.nextDouble() * r
            : _random.nextDouble() * -r;
        final double randomY = _random.nextBool()
            ? sqrt(rSquared - randomX * randomX) * _random.nextDouble()
            : -sqrt(rSquared - randomX * randomX) * _random.nextDouble();

        _line.add(point.translate(randomX, randomY));
      }
    } else {
      for (int j = 0; j < settings.lerps; j++) {
        final width = settings.strokeWidth ~/ 2;
        final randomX = _random.nextBool()
            ? _random.nextInt(width).toDouble()
            : -_random.nextInt(width).toDouble();
        final randomY = _random.nextBool()
            ? _random.nextInt(width).toDouble()
            : -_random.nextInt(width).toDouble();

        _line.add(point.translate(randomX, randomY));
      }
    }
    updatePathAndPaint();
  }

  late final paint = Paint()
    ..style = PaintingStyle.fill
    ..color = settings.color
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = settings.dotSize;

  var currentIndex = 0;
  late final numberOfNewPoints = settings.lerps;
  @override
  void updatePathAndPaint() {
    currentIndex = _line.length - numberOfNewPoints;
    if (currentIndex < 0 || currentIndex > _line.length) {
      return;
    }

    for (int i = currentIndex; i < _line.length; i++) {
      pathsAndPaints.add(Tuple2(
          Path()
            ..addOval(Rect.fromCircle(
              center: _line[i],
              radius: settings.dotSize,
            )),
          paint));
    }
  }
}

/// [BrushStyle.triangles] implementations
///
///

class TriangleBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  TriangleBrushSettings({
    required this.strokeWidth,
    required this.color,
    required this.minBaseWidth,
    required this.maxBaseWidth,
    this.heightFactor = 1.0,
    this.secondColor,
  }) : super(BrushStyle.triangles);

  late final Color color;
  late final Color? secondColor;
  late final double strokeWidth;
  late final double maxBaseWidth;
  late final double minBaseWidth;
  late final double heightFactor;

  @override
  TriangleBrushSettings copyWith({
    Color? color,
    Color? secondColor,
    double? strokeWidth,
    double? maxBaseWidth,
    double? minBaseWidth,
    double? heightFactor,
  }) {
    return TriangleBrushSettings(
      color: color ?? this.color,
      secondColor: secondColor ?? this.secondColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      maxBaseWidth: maxBaseWidth ?? this.maxBaseWidth,
      minBaseWidth: minBaseWidth ?? this.minBaseWidth,
      heightFactor: heightFactor ?? this.heightFactor,
    );
  }

  @override
  List<Object?> get props => [
        super.brushStyle,
        color,
        secondColor,
        strokeWidth,
        maxBaseWidth,
        minBaseWidth,
        heightFactor,
      ];

  @override
  BrushLine getBrushLineWithSettings() {
    return TriangleBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return TriangleBrushSettings(
      strokeWidth: strokeWidth * scaleFactor,
      color: color,
      secondColor: secondColor,
      heightFactor: heightFactor,
      minBaseWidth: minBaseWidth * scaleFactor,
      maxBaseWidth: maxBaseWidth * scaleFactor,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.triangles.name,
      "color": color.value,
      "secondColor": secondColor?.value,
      "strokeWidth": strokeWidth,
      "maxBaseWidth": maxBaseWidth,
      "minBaseWidth": minBaseWidth,
      "heightFactor": heightFactor,
    };
  }

  TriangleBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.triangles) {
    color = Color(json["color"] as int);
    secondColor =
        json["secondColor"] != null ? Color(json["secondColor"] as int) : null;
    strokeWidth = json["strokeWidth"] as double;
    maxBaseWidth = json["maxBaseWidth"] as double;
    minBaseWidth = json["minBaseWidth"] as double;
    heightFactor = json["heightFactor"] as double;
  }
}

class TriangleBrushLine extends BrushLine {
  TriangleBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final TriangleBrushSettings settings;

  final List<Tuple3<Offset, Offset, Offset>> _triangles = [];

  List<Tuple3<Offset, Offset, Offset>> get triangles => _triangles;

  @override
  void addPoint(Offset point) {
    if (_line.isNotEmpty) {
      final xDiff = point.dx - _line.last.dx;
      final yDiff = point.dy - _line.last.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      if (realDistance >= settings.minBaseWidth) {
        _line.add(point);
        _addTriangle();
        updatePathAndPaint();
      }
    } else {
      _line.add(point);
    }
  }

  void _addTriangle() {
    assert(_line.length > 1, '_line needs at least two points');
    if (!(_line.length > 1)) {
      return;
    }

    final pointA = _line.last;
    final pointB = _line[_line.length - 2];
    final xDiff = pointA.dx - pointB.dx;
    final yDiff = pointA.dy - pointB.dy;
    final midPoint = Offset.lerp(pointA, pointB, 0.5)!.translate(
        -settings.heightFactor * yDiff, settings.heightFactor * xDiff);

    _triangles.add(Tuple3(pointA, midPoint, pointB));
  }

  late final fillPaint = Paint()
    ..strokeWidth = settings.strokeWidth
    ..strokeJoin = StrokeJoin.bevel
    ..style = PaintingStyle.fill
    ..color = settings.color
    ..strokeCap = StrokeCap.round;

  late final strokePaint = Paint()
    ..strokeWidth = settings.strokeWidth
    ..strokeJoin = StrokeJoin.bevel
    ..style = PaintingStyle.stroke
    ..color = settings.secondColor ?? settings.color
    ..strokeCap = StrokeCap.round;

  @override
  void updatePathAndPaint() {
    final pathToDraw = Path()
      ..moveTo(triangles.last.item1.dx, triangles.last.item1.dy)
      ..lineTo(triangles.last.item2.dx, triangles.last.item2.dy)
      ..lineTo(triangles.last.item3.dx, triangles.last.item3.dy)
      ..close();

    pathsAndPaints.add(Tuple2(
      pathToDraw,
      fillPaint,
    ));

    pathsAndPaints.add(Tuple2(
      pathToDraw,
      strokePaint,
    ));
  }
}

/// [BrushStyle.rainbow] implementations
///
///

class RainbowBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  RainbowBrushSettings({
    required this.width,
  }) : super(BrushStyle.rainbow);

  late final double width;

  @override
  RainbowBrushSettings copyWith({
    double? width,
  }) {
    return RainbowBrushSettings(
      width: width ?? this.width,
    );
  }

  @override
  List<Object?> get props => [super.brushStyle, width];

  @override
  BrushLine getBrushLineWithSettings() {
    return RainbowBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return RainbowBrushSettings(width: width * scaleFactor);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.rainbow.name,
      "width": width,
    };
  }

  RainbowBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.rainbow) {
    width = json["width"] as double;
  }
}

class RainbowBrushLine extends BrushLine {
  RainbowBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final RainbowBrushSettings settings;

  final List<List<Offset>> _rainbowLines = [[], [], [], [], [], [], []];

  static const List<Color> _colors = [
    Color(0xFFFE0500),
    Color(0xFFFD8001),
    Color(0xFFFFFF05),
    Color(0xFF02FF00),
    Color(0xFF09D2FF),
    Color(0xFF0000FE),
    Color(0xFF8001FF),
  ];

  /*
   List<Color> _colors = [
    Color(0xFFFF0000),
    Color(0xFFFF7F00),
    Color(0xFFFFFF00),
    Color(0xFF00FF00),
    Color(0xFF0000FF),
    Color(0xFF4B0082),
    Color(0xFF9400D3),
  ];*/

  @override
  void addPoint(Offset point) {
    if (_line.isNotEmpty) {
      final xDiff = point.dx - _line.last.dx;
      final yDiff = point.dy - _line.last.dy;
      var realDistance = sqrt(xDiff * xDiff + yDiff * yDiff);
      if (realDistance >= 2.0) {
        _line.add(point);
        _addRainbowPoints();
        updatePathAndPaint();
      }
    } else {
      _line.add(point);
    }
  }

  void _addRainbowPoints() {
    assert(_line.length > 1, '_line needs at least two points');
    if (!(_line.length > 1)) {
      return;
    }

    final pointA = _line.last;
    final pointB = _line[_line.length - 2];

    final xDiff = pointA.dx - pointB.dx;
    final yDiff = pointA.dy - pointB.dy;

    final midPoint = pointA;
    final endPoint = pointA.translate(1.0 * yDiff, -1.0 * xDiff);

    final xDiffCross = midPoint.dx - endPoint.dx;
    final yDiffCross = midPoint.dy - endPoint.dy;

    final realDistance =
        sqrt(xDiffCross * xDiffCross + yDiffCross * yDiffCross);

    for (int i = 0; i < 3; i++) {
      final desiredDistance = settings.width * (3 - i);
      final t = desiredDistance / realDistance;

      final Offset rainbowPoint = Offset(
          ((1 - t) * midPoint.dx + (t * endPoint.dx)),
          ((1 - t) * midPoint.dy + (t * endPoint.dy)));

      _rainbowLines[i].add(rainbowPoint);
    }

    _rainbowLines[3].add(midPoint);

    for (int i = 4; i < 7; i++) {
      final desiredDistance = -settings.width * (i - 3);
      final t = desiredDistance / realDistance;

      final Offset rainbowPoint = Offset(
          ((1 - t) * midPoint.dx + (t * endPoint.dx)),
          ((1 - t) * midPoint.dy + (t * endPoint.dy)));

      _rainbowLines[i].add(rainbowPoint);
    }
  }

  @override
  void updatePathAndPaint() {
    for (int i = 0; i < _rainbowLines.length; i++) {
      final lineLength = _rainbowLines[i].length;
      if (lineLength == 1) {
        Path path = Path()
          ..moveTo(_rainbowLines[i].first.dx, _rainbowLines[i].first.dy);
        pathsAndPaints.add(Tuple2(
          path,
          Paint()
            ..strokeWidth = settings.width
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..color = _colors[i],
        ));
      } else if (lineLength > 1) {
        final p0 = _rainbowLines[i][lineLength - 2];
        final p1 = _rainbowLines[i][lineLength - 1];
        if (pathsAndPaints.length > i) {
          pathsAndPaints[i].item1.quadraticBezierTo(
              p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        }
      }
    }
  }
}

/// [BrushStyle.eraser] implementations
///
///

class EraserBrushSettings extends BrushSettings {
  // ignore: prefer_const_constructors_in_immutables
  EraserBrushSettings({
    this.color = monsterCanvasColor,
    required this.width,
    this.opacity = 1.0,
  })  : assert(opacity <= 1.0 && opacity >= 0.0, 'Opacity is out of range'),
        super(BrushStyle.eraser);

  late final Color color;
  late final double width;
  late final double opacity;

  @override
  EraserBrushSettings copyWith({
    double? width,
    double? opacity,
  }) {
    return EraserBrushSettings(
      width: width ?? this.width,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  List<Object?> get props => [super.brushStyle, color, width, opacity];

  @override
  BrushLine getBrushLineWithSettings() {
    return EraserBrushLine(this);
  }

  @override
  BrushSettings withScaleFactor(double scaleFactor) {
    return EraserBrushSettings(
      width: width * scaleFactor,
      color: color,
      opacity: opacity,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "style": BrushStyle.eraser.name,
      "color": color.value,
      "width": width,
      "opacity": opacity,
    };
  }

  EraserBrushSettings.fromJson(Map<String, dynamic> json)
      : super(BrushStyle.eraser) {
    color = Color(json["color"] as int);
    width = json["width"] as double;
    opacity = json["opacity"] as double;
  }
}

class EraserBrushLine extends BrushLine {
  EraserBrushLine(this.settings) : super(settings);

  @override
  // ignore: overridden_fields
  final EraserBrushSettings settings;

  @override
  void updatePathAndPaint() {
    if (_line.length == 1) {
      Path path = Path()..moveTo(_line.first.dx, _line.first.dy);
      path.lineTo(_line.first.dx, _line.first.dy);

      pathsAndPaints.add(Tuple2(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = settings.color.withOpacity(settings.opacity)
          ..strokeWidth = settings.width,
      ));
    } else if (_line.length > 1) {
      final p0 = _line[_line.length - 2];
      final p1 = _line[_line.length - 1];
      pathsAndPaints.first.item1.quadraticBezierTo(
          p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
    }
  }
}

/*class PerfectHandBrushSettings extends BrushSettings {
  PerfectHandBrushSettings({required this.color}) : super(BrushStyle.singleStroke);

  final Color color;

  @override
  BrushLine getBrushLineWithSettings() {
    return PerfectHandBrushLine(this);
  }
}

class PerfectHandBrushLine extends BrushLine {
  PerfectHandBrushLine(this.settings) : super(settings);

  @override
  final PerfectHandBrushSettings settings;

  @override
  List<Tuple2<Path, Paint>> getPathsAndPaints() {
    final List<freehand.Point> points = _line.map((offset) => freehand.Point(offset.dx, offset.dy)).toList();

    final outlinePoints = freehand.getStroke(points, simulatePressure: false, size: 12);

    final path = Path();

    if (outlinePoints.isEmpty) {
      return [];
    } else if (outlinePoints.length < 2) {
      // If the path only has one line, draw a dot.
      path.addOval(Rect.fromCircle(center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
    } else {
      // Otherwise, draw a line that connects each point with a curve.
      path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        path.quadraticBezierTo(p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
      }
    }

    return [
      Tuple2<Path, Paint>(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = settings.color
          ..strokeWidth = 2.0,
      )
    ];
  }
}*/

extension TranslateWithOffset on Offset {
  Offset translateWithOffset(Offset translation) {
    return translate(translation.dx, translation.dy);
  }
}
