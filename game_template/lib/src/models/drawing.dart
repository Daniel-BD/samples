import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../theme/colors.dart';

/// OLD DRAWING MODEL - WILL DELETE
class Drawing {
  late double _originalHeight;
  late double _originalWidth;

  double get originalHeight => _originalHeight;
  double get originalWidth => _originalWidth;

  void updateOriginalSize(double height, double width) {
    _originalHeight = height;
    _originalWidth = width;
    //debugPrint('Original size of drawing set to: HEIGHT: $_originalHeight, WIDTH: $_originalWidth');
    // update();
  }

  Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 12
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;

  Paint get paint => _paint;
  set paint(Paint value) {
    _paint = value;
    // update();
  }

  void _setInitialPaintWithRandomColor() {
    final i = Random().nextInt(brushColors.length);
    _paint = Paint()
      ..color = brushColors[i].withOpacity(0.25)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
  }

  /// This is essentially a list of paths, even though it may be hard to see. The inner list is a list of points (dx dy),
  /// which is the same thing as a path really. The outer list is a list of those, meaning a list of paths.
  List<List<Path>> _superPaths = [];
  List<List<Paint>> _superPaints = [];
  List<List<List<Tuple2<double, double>>>> _superDeconstructedPaths = [];

  final List<List<Path>> _undonePaths = [];
  final List<List<Paint>> _undonePaints = [];
  final List<List<List<Tuple2<double, double>>>> _undoneDeconstructedPaths = [];

  void clearDrawing() {
    _superPaths.clear();
    _superPaints.clear();
    _superDeconstructedPaths.clear();
    _undonePaths.clear();
    _undonePaints.clear();
    _undoneDeconstructedPaths.clear();
    // update();
  }

  void undoLastPath() {
    if (_superDeconstructedPaths.isEmpty) {
      return;
    }
    _undoneDeconstructedPaths.add(_superDeconstructedPaths.removeLast());
    _undonePaths.add(_superPaths.removeLast());
    _undonePaints.add(_superPaints.removeLast());
    assert(_assertLengths());
    // update();
  }

  void redoLastUndonePath() {
    if (_undoneDeconstructedPaths.isEmpty) {
      return;
    }
    _superDeconstructedPaths.add(_undoneDeconstructedPaths.removeLast());
    _superPaths.add(_undonePaths.removeLast());
    _superPaints.add(_undonePaints.removeLast());
    assert(_assertLengths());
    // update();
  }

  void startNewPath(double dx, double dy, Paint paint) {
    _superPaths.add([Path()..moveTo(dx, dy)]);
    _superPaths.last.last.lineTo(dx, dy);
    _superPaints.add([paint]);

    _superDeconstructedPaths.add([
      [Tuple2<double, double>(dx, dy)]
    ]);

    assert(_assertLengths());
    // update();
  }

  void endPath() {}

  /// Adds a new point to the current path
  void addPoint(double dx, double dy) {
    _superPaths.last.last.lineTo(dx, dy);
    _superDeconstructedPaths.last.last.add(Tuple2<double, double>(dx, dy));
    // update();
  }

  List<Path> getOriginalPaths() {
    List<Path> paths = [];
    for (var pathList in _superPaths) {
      for (var path in pathList) {
        if (path.computeMetrics().isEmpty) {
          var pathToAdd = Path.from(path);
          pathToAdd.relativeLineTo(0.01, 0.01);
          paths.add(pathToAdd);
        } else {
          paths.add(path);
        }
      }
    }
    assert(_assertLengths());
    return paths;
  }

  List<Paint> getOriginalPaints() {
    List<Paint> paints = [];
    for (var paintList in _superPaints) {
      for (var paint in paintList) {
        paints.add(paint);
      }
    }
    assert(_assertLengths());
    return paints;
  }

  List<Path> getScaledPaths({required double outputHeight}) {
    List<Path> scaledPaths = [];

    List<List<Path>> tempPaths = [];
    for (var pathList in _superDeconstructedPaths) {
      List<Path> tempList = [];

      for (var fakePath in pathList) {
        tempList.add(Path()
          ..moveTo(
              _scaleNumber(
                  inputScale: originalHeight,
                  outputScale: outputHeight,
                  number: fakePath.first.item1),
              _scaleNumber(
                  inputScale: originalHeight,
                  outputScale: outputHeight,
                  number: fakePath.first.item2))
          ..lineTo(
              _scaleNumber(
                  inputScale: originalHeight,
                  outputScale: outputHeight,
                  number: fakePath.first.item1),
              _scaleNumber(
                  inputScale: originalHeight,
                  outputScale: outputHeight,
                  number: fakePath.first.item2)));

        for (int i = 1; i < fakePath.length; i++) {
          tempList.last.lineTo(
              _scaleNumber(
                  inputScale: originalHeight,
                  outputScale: outputHeight,
                  number: fakePath[i].item1),
              _scaleNumber(
                  inputScale: originalHeight,
                  outputScale: outputHeight,
                  number: fakePath[i].item2));
        }
      }

      tempPaths.add(tempList);
    }

    for (var pathList in tempPaths) {
      for (var path in pathList) {
        if (path.computeMetrics().isEmpty) {
          var pathToAdd = Path.from(path);
          pathToAdd.relativeLineTo(0.01, 0.01);
          scaledPaths.add(pathToAdd);
        } else {
          scaledPaths.add(path);
        }
      }
    }
    return scaledPaths;
  }

  List<Paint> getScaledPaints({required double outputHeight}) {
    List<Paint> paints = [];

    for (var paintList in _superPaints) {
      for (var paint in paintList) {
        paints.add(Paint()
          ..color = paint.color
          ..strokeJoin = paint.strokeJoin
          ..strokeCap = paint.strokeCap
          ..style = paint.style
          ..strokeWidth = _scaleNumber(
              inputScale: originalHeight,
              outputScale: outputHeight,
              number: paint.strokeWidth));
      }
    }
    assert(_assertLengths());
    return paints;
  }

  double _scaleNumber(
      {required double inputScale,
      required double outputScale,
      required double number}) {
    return number * (outputScale / inputScale);
  }

  Drawing(Size sizeAvailable) {
    _setInitialPaintWithRandomColor();

    var size = canvasSizeCalculator(sizeAvailable);

    _originalHeight = size.height;
    _originalWidth = size.width;

    /*if (canvasSize.height * (16 / 9) <= canvasSize.width) {
      _originalHeight = canvasSize.height;
      _originalWidth = canvasSize.height * (16 / 9);
    } else {
      _originalHeight = canvasSize.width * (9 / 16);
      _originalWidth = canvasSize.width;
    }*/
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

  List<List<Path>> _createPathsFromDeconstructed() {
    List<List<Path>> createdList = [];

    for (var pathList in _superDeconstructedPaths) {
      List<Path> tempList = [];

      for (var fakePath in pathList) {
        tempList.add(Path()
          ..moveTo(fakePath.first.item1, fakePath.first.item2)
          ..lineTo(fakePath.first.item1, fakePath.first.item2));

        for (int i = 1; i < fakePath.length; i++) {
          tempList.last.lineTo(fakePath[i].item1, fakePath[i].item2);
        }
      }

      createdList.add(tempList);
    }

    return createdList;
  }

  // Drawing.fromJson(
  //   Map<String, dynamic> json,
  // ) {
  //   _setInitialPaintWithRandomColor();
  //   List<List<List<Tuple2<double, double>>>> listOfListsOfPaths = [];
  //   List<List<Paint>> listOfListsOfPaints = [];
  //   List<String> listOfPathListStrings = json['paths'].split('/');
  //   List<String> listOfPaintListStrings = json['paints'].split('/');
  //
  //   /// Reading size
  //   final List<String> originalSize = json['size'].toString().split(',');
  //   updateOriginalSize(
  //       double.parse(originalSize[0]), double.parse(originalSize[1]));
  //
  //   /// Reading paths
  //   for (var pathList in listOfPathListStrings) {
  //     List<List<Tuple2<double, double>>> tempPathList = [];
  //
  //     for (var path in pathList.split(':')) {
  //       List<Tuple2<double, double>> pathCoordinates = [];
  //       List<String> pathCoordinatesString = path.split(',');
  //
  //       for (var i = 0; i < pathCoordinatesString.length; i += 2) {
  //         double X = double.parse(pathCoordinatesString[i]);
  //         double Y = double.parse(pathCoordinatesString[i + 1]);
  //
  //         pathCoordinates.add(Tuple2(X, Y));
  //       }
  //
  //       tempPathList.add(pathCoordinates);
  //     }
  //
  //     listOfListsOfPaths.add(tempPathList);
  //   }
  //
  //   /// Readings paints
  //   for (var paintList in listOfPaintListStrings) {
  //     List<Paint> tempPaintList = [];
  //
  //     for (var paint in paintList.split(':')) {
  //       List<String> values = paint.split(',');
  //       assert(double.parse(values[0]).runtimeType == double ||
  //           double.parse(values[0]).runtimeType == int);
  //       assert(int.parse(values[1]).runtimeType == int);
  //
  //       tempPaintList.add(Paint()
  //         ..color = Color(int.parse(values[1]))
  //         ..strokeWidth = double.parse(values[0])
  //         ..strokeCap = StrokeCap.round
  //         ..strokeJoin = StrokeJoin.round
  //         ..style = PaintingStyle.stroke);
  //     }
  //
  //     listOfListsOfPaints.add(tempPaintList);
  //   }
  //
  //   _superDeconstructedPaths = listOfListsOfPaths;
  //   _superPaints = listOfListsOfPaints;
  //   _superPaths = _createPathsFromDeconstructed();
  //
  //   assert(_assertLengths());
  // }

  Map<String, dynamic> toJson() {
    assert(_assertLengths());

    Map<String, dynamic> json = {};
    var pathsString = StringBuffer();
    var paintsString = StringBuffer();

    /// For every list of paths...
    for (var i = 0; i < _superDeconstructedPaths.length; i++) {
      /// Go through every path, and for every path...
      for (var j = 0; j < _superDeconstructedPaths[i].length; j++) {
        /// Go through every coordinate in that path...
        for (var k = 0; k < _superDeconstructedPaths[i][j].length; k++) {
          /// Write down the X and Y coordinate, separated with a comma
          pathsString.write(
              '${_superDeconstructedPaths[i][j][k].item1},${_superDeconstructedPaths[i][j][k].item2}');

          /// Don't write a comma after the last coordinate
          if (k < _superDeconstructedPaths[i][j].length - 1) {
            pathsString.write(',');
          }

          /// If there's only one coordinate in this path, add a second one right next to it.
          /// This is to prevent dots (path with one coordinate) not rendering in the animation library.
          if (_superDeconstructedPaths[i][j].length == 1) {
            pathsString.write(',');
            pathsString.write(
                '${_superDeconstructedPaths[i][j][k].item1 + 0.001},${_superDeconstructedPaths[i][j][k].item2 + 0.001}');
          }
        }

        /// Separate every path with a colon, but don't write a colon after the last path
        if (j < _superDeconstructedPaths[i].length - 1) {
          pathsString.write(':');
        }
      }

      /// Separate every list of paths with a slash, but don't write a slash after the last list of paths
      if (i < _superDeconstructedPaths.length - 1) {
        pathsString.write('/');
      }
    }

    /// For every list of paints...
    for (var i = 0; i < _superPaints.length; i++) {
      /// Go through every paint
      for (var j = 0; j < _superPaints[i].length; j++) {
        /// Write down the stroke width and color value, separated with a comma
        paintsString.write(
            '${_superPaints[i][j].strokeWidth},${_superPaints[i][j].color.value}');

        /// Separate every paint with a colon, but don't write a colon after the last paint
        if (j < _superPaints[i].length - 1) {
          paintsString.write(':');
        }
      }

      /// Separate every list of paints with a slash, but don't write a slash after the last list of paints
      if (i < _superPaints.length - 1) {
        paintsString.write('/');
      }
    }

    json['paths'] = pathsString.toString();
    json['paints'] = paintsString.toString();
    json['size'] = '$originalHeight, $originalWidth';

    return json;
  }

  bool _assertLengths() {
    assert(_superPaths.length == _superPaints.length,
        'The length of SuperPaths and SuperPaints are not the same');
    assert(_superPaths.length == _superDeconstructedPaths.length,
        'The length of SuperPaths and SuperDeconstructedPaths are not the same');

    for (var i = 0; i < _superPaths.length; i++) {
      assert(_superPaths[i].length == _superPaints[i].length,
          'The length of Paths and Paints are not the same at $i');
    }
    for (var i = 0; i < _superPaths.length; i++) {
      assert(_superPaths[i].length == _superDeconstructedPaths[i].length,
          'The length of Paths and DeconstructedPaths are not the same at $i');
    }

    // for the undone stuff
    assert(_undonePaths.length == _undonePaints.length,
        'The length of UndonePathsList and UndonePaintsList are not the same');
    assert(_undonePaths.length == _undoneDeconstructedPaths.length,
        'The length of UndonePathsList and UndoneDeconstructedList are not the same');

    for (var i = 0; i < _undonePaths.length; i++) {
      assert(_undonePaths[i].length == _undonePaints[i].length,
          'The length of UndonePaths and UndonePaints are not the same at $i');
    }
    for (var i = 0; i < _undonePaths.length; i++) {
      assert(_undonePaths[i].length == _undoneDeconstructedPaths[i].length,
          'The length of UndonePaths and UndoneDeconstructed are not the same at $i');
    }

    return true;
  }
}
