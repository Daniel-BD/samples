import 'dart:ui';

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  List<Path> paths;
  List<Paint> paints;

  MyPainter(this.paths, this.paints);

  Picture? lastPicture;

  @override
  void paint(Canvas canvas, Size size) {
    //assert(paths.length == paints.length, 'The length of Paths and Paints are not the same');
    //var strokeWidth = paints.first.strokeWidth;

    if (lastPicture != null) {
      canvas.drawPicture(lastPicture!);
      debugPrint('Drawing last picture');
      return;
    }

    final recorder = PictureRecorder();
    final recordedCanvas = Canvas(recorder);

    for (var i = 0; i < paths.length; i++) {
      recordedCanvas.drawPath(paths[i], paints[i]);
    }

    final picture = recorder.endRecording();
    canvas.drawPicture(picture);
    lastPicture = picture;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
