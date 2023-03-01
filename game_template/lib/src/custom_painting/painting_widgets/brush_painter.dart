import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../drawing_screen/drawing_state.dart';
import '../../theme/colors.dart';
import '../brushes/brushes.dart';

class BrushPainter extends CustomPainter {
  BrushPainter({
    required this.drawingState,
    required this.scale,
    this.canvasColor = monsterCanvasColor,
  }) : super(repaint: drawingState);

  final double scale;
  final Color canvasColor;
  late final DrawingState drawingState;
  ui.Image? _imageCache;
  int _lastBrushLineCached = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(canvasColor, BlendMode.src);
    _simplePaint(canvas, size);
  }

  @override
  bool shouldRepaint(BrushPainter oldDelegate) {
    return false;
    // return drawingState.lines.last.userIsCurrentlyDrawing ||
    //     oldDelegate.drawingState.lines.length != drawingState.lines.length;
  }

  @override
  bool shouldRebuildSemantics(BrushPainter oldDelegate) => false;

  void _invalidateImageCache() {
    _imageCache?.dispose();
    _imageCache = null;
    _lastBrushLineCached = 0;
  }

  void _drawCachedImage(Canvas canvas, {bool scaleCanvas = true}) {
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    final image = _imageCache?.clone();
    if (image == null) return;

    canvas.save();
    if (scaleCanvas) {
      canvas.scale((1 / devicePixelRatio));
    }
    canvas.drawImage(image, Offset.zero, Paint());
    image.dispose();
    canvas.restore();
  }

  void _drawBrushLines(Canvas canvas, List<BrushLine> brushLines) {
    for (final brushLine in brushLines) {
      Paint? eraserPaint;
      if (brushLine is EraserBrushLine) {
        eraserPaint = brushLines.last.pathsAndPaints.first.item2;
        eraserPaint.color = canvasColor.withOpacity(eraserPaint.color.opacity);
      }
      for (final pathAndPaint in brushLine.getPathsAndPaints()) {
        canvas.drawPath(pathAndPaint.item1, eraserPaint ?? pathAndPaint.item2);
      }
    }
  }

  void _simplePaint(Canvas canvas, Size size) {
    final brushLines = drawingState.lines;
    if (brushLines.isEmpty) {
      _invalidateImageCache();
      return;
    }

    if (brushLines.last.userIsCurrentlyDrawing) {
      _drawCachedImage(canvas);
      canvas.scale(scale);
      _drawBrushLines(canvas, [brushLines.last]);
      return;
    }

    if (_lastBrushLineCached == brushLines.length) {
      _drawCachedImage(canvas);
      return;
    }

    if (_lastBrushLineCached < brushLines.length ||
        _lastBrushLineCached > brushLines.length) {
      final repaintAll = !(_lastBrushLineCached == brushLines.length - 1);
      final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
      final recorder = ui.PictureRecorder();
      final recordedCanvas = Canvas(recorder);
      if (!repaintAll) {
        _drawCachedImage(recordedCanvas, scaleCanvas: false);
      }
      recordedCanvas.scale(devicePixelRatio * scale);
      List<BrushLine> brushLinesToDraw = [];
      if (repaintAll) {
        brushLinesToDraw.addAll(brushLines);
      } else {
        brushLinesToDraw.add(brushLines.last);
      }

      _drawBrushLines(recordedCanvas, brushLinesToDraw);

      final picture = recorder.endRecording();
      canvas.scale((1 / devicePixelRatio));
      canvas.drawPicture(picture);
      final image = picture.toImageSync(
        (size.width * devicePixelRatio).floor(),
        (size.height * devicePixelRatio).floor(),
      );
      _invalidateImageCache();
      _imageCache = image.clone();
      image.dispose();
      _lastBrushLineCached = brushLines.length;

      return;
    }

    assert(false, 'This should never happen');
  }
}

class BrushPreviewPainter extends CustomPainter {
  final List<BrushLine> brushLines;
  final double scale;

  BrushPreviewPainter({required this.brushLines, this.scale = 1});

  @override
  void paint(canvas, size) {
    canvas.scale(scale);
    for (final line in brushLines) {
      for (final pathAndPaint in line.getPathsAndPaints()) {
        canvas.drawPath(
          pathAndPaint.item1,
          pathAndPaint.item2..strokeJoin = StrokeJoin.bevel,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/*
void advancedPaint(Canvas canvas, Size size) {
    final brushLines = drawingState.lines;
    debugPrint('Start Paint!, brushLine nr: ${brushLines.length}');
    final devicePixelRatio =
        WidgetsBinding.instance.window.devicePixelRatio * 2;
    double imageScaleFactor() {
      final canvasPixelHeight = size.height * devicePixelRatio;
      if (_imageList.isNotEmpty &&
          _imageList.last.height != canvasPixelHeight) {
        return canvasPixelHeight / _imageList.last.height;
      }
      return 1;
    }

    if (brushLines.isEmpty) {
      debugPrint('RETURN: brushLines.isEmpty');
      return;
    }

    ui.Image? lastImage;
    if (_imageList.isNotEmpty) {
      // final canvasPixelHeight = size.height * devicePixelRatio;
      // if (_imageList.last.height != canvasPixelHeight) {
      //   lastImage = copyResize(_imageList.last, height: canvasPixelHeight);
      // }
      lastImage = _imageList.last.clone();
    }

    debugPrint('lastImage: $lastImage, last image nr: ${_imageList.length}');
    debugPrint(
        'canvas size, width: ${size.width * devicePixelRatio}, height: ${size.height * devicePixelRatio}');

    if (brushLines.last.userIsCurrentlyDrawing) {
      debugPrint(
          'RETURN: brushLines.last.userIsCurrentlyDrawing line nr: ${brushLines.length}, image nr: ${_imageList.length}');
      if (lastImage != null) {
        canvas.save();
        canvas.scale((1 / devicePixelRatio) * imageScaleFactor());
        canvas.drawImage(lastImage, Offset.zero, Paint());
        lastImage.dispose();
        canvas.restore();
      }

      canvas.scale(scale);
      for (var pathAndPaint in brushLines.last.getPathsAndPaints()) {
        canvas.drawPath(pathAndPaint.item1, pathAndPaint.item2);
      }

      return;
    }

    //User is not currently drawing, meaning last brush line is finished
    if (_imageList.length != brushLines.length) {
      debugPrint(
          'RETURN: !_imageMap.containsKey(brushLines.length), nr: ${brushLines.length}');
      final recorder = ui.PictureRecorder();
      final recordedCanvas = Canvas(recorder);
      if (lastImage != null) {
        recordedCanvas.save();
        recordedCanvas.scale(imageScaleFactor());
        recordedCanvas.drawImage(lastImage, Offset.zero, Paint());
        recordedCanvas.restore();
        lastImage.dispose();
      }

      recordedCanvas.scale(devicePixelRatio * scale);

      for (var pathAndPaint in brushLines.last.getPathsAndPaints()) {
        recordedCanvas.drawPath(pathAndPaint.item1, pathAndPaint.item2);
      }

      final picture = recorder.endRecording();
      canvas.scale((1 / devicePixelRatio));
      canvas.drawPicture(picture);
      final image = picture.toImageSync(
        (size.width * devicePixelRatio).floor(),
        (size.height * devicePixelRatio).floor(),
      );

      debugPrint('Saved image width: ${image.width}, height: ${image.height}');
      debugPrint(
          'Canvas Size width: ${size.width * devicePixelRatio}, height: ${size.height * devicePixelRatio}');

      _imageList.add(image.clone());
      image.dispose();

      return;
    }

    if (_imageList.length == brushLines.length) {
      debugPrint(
          'RETURN: _imageMap.containsKey(brushLines.length), nr: ${brushLines.length}');
      if (lastImage != null) {
        canvas.scale((1 / devicePixelRatio) * imageScaleFactor());
        canvas.drawImage(lastImage, Offset.zero, Paint());
        lastImage.dispose();
      }

      return;
    }

    debugPrint('RETURN: This should NEVER happen');
    assert(false);
  }
 */
