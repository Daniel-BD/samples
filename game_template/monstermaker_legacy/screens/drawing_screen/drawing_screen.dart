import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monstermaker/custom_painting/painting_widgets/painter.dart';
import 'package:monstermaker/custom_painting/painting_widgets/brush_painter.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/colors.dart' as appColors;
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/models/drawing.dart';
import 'package:monstermaker/models/experimental_drawing.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/control_panel_controller.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/control_panel_widget.dart';
import 'package:monstermaker/screens/drawing_screen/dashed_line.dart';
import 'package:monstermaker/screens/drawing_screen/drawing_controller.dart';
import 'package:monstermaker/screens/drawing_screen/drawing_timer.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Get.put<DrawingController>(DrawingController());
    Get.put<ControlPanelController>(ControlPanelController());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GetBuilder<GameController>(builder: (gameController) {
        return Scaffold(
          backgroundColor: appColors.drawingControlPanelColor,
          body: SafeArea(
            bottom: false,
            top: false,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      GetBuilder<ControlPanelController>(
                        builder: (controlPanelController) {
                          return SizedBox(
                            width: controlPanelController.showingPanel ? 120 : 0,
                          );
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AspectRatio(
                            aspectRatio: (AppConstants.drawingSectionAspectRatio),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    RepaintBoundary(
                                      child: DrawingCanvas(
                                        availableSize: constraints.biggest,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: DrawingTimer(
                                          time: gameController.currentGameRoom?.drawingTime,
                                          onTimesUp: () {
                                            //TODO: Pop up the hand in drawing modal here
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<DrawingController>(
                  builder: (drawingController) {
                    return drawingController.brushController != null
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              final panelHeight = ExperimentalDrawing.canvasSizeCalculator(
                                constraints.biggest,
                              ).height;
                              return ControlPanel(height: panelHeight, alwaysShown: false);
                            },
                          )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  DrawingCanvas({
    Key? key,
    required this.availableSize,
    this.drawingToContinueOn,
    this.scale = 1.0,
  }) : super(key: key) {
    Get.find<DrawingController>().setOriginalCanvasSize(availableSize);
  }

  final Size availableSize;
  final Drawing? drawingToContinueOn;
  final double scale;

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late final Drawing _myDrawing;
  late final DrawingController _drawingController;
  late final Size _originalCanvasSize;
  late Size _canvasSize;

  @override
  void initState() {
    super.initState();
    _drawingController = Get.find<DrawingController>();
    _originalCanvasSize = ExperimentalDrawing.canvasSizeCalculator(widget.availableSize);
  }

  Offset scaleCoordinate(Offset original, double scale) {
    return Offset(original.dx * scale, original.dy * scale);
  }

  @override
  Widget build(BuildContext context) {
    _canvasSize = ExperimentalDrawing.canvasSizeCalculator(widget.availableSize);
    final customPaintScale = _canvasSize.width / _originalCanvasSize.width;

    return Container(
      color: appColors.monsterCanvasColor,
      child: GetBuilder<GameController>(builder: (gameController) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            _drawingController.startNewLine(
              startPoint: scaleCoordinate(details.localPosition, _originalCanvasSize.width / _canvasSize.width),
            );
          },
          onPanUpdate: (details) {
            _drawingController.addPoint(
              scaleCoordinate(details.localPosition, _originalCanvasSize.width / _canvasSize.width),
            );
          },
          onPanEnd: (details) {
            _drawingController.endCurrentLine();
          },
          child: Stack(
            children: <Widget>[
              if (widget.drawingToContinueOn != null)
                Positioned(
                  top: -(_myDrawing.originalHeight * (5 / 6)),
                  child: SizedBox(
                    width: widget.availableSize.width,
                    child: ClipRect(
                      child: CustomPaint(
                        size: _canvasSize,
                        painter: MyPainter(
                          widget.drawingToContinueOn!.getScaledPaths(outputHeight: _myDrawing.originalHeight),
                          widget.drawingToContinueOn!.getScaledPaints(outputHeight: _myDrawing.originalHeight),
                        ),
                      ),
                    ),
                  ),
                ),
              ClipRect(
                child: GetBuilder<DrawingController>(builder: (drawingController) {
                  return CustomPaint(
                    size: _canvasSize,
                    isComplex: true,
                    painter: BrushPainter(drawingController.lines, customPaintScale),
                  );
                }),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: DashedLine(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/*class TestAnimation extends StatelessWidget {
  const TestAnimation({Key? key, required this.drawing, this.scale = 1.0}) : super(key: key);

  final ExperimentalDrawing drawing;
  final double scale;

  @override
  Widget build(BuildContext context) {
    List<Path> paths = [];
    List<Paint> paints = [];

    for (final brushLine in drawing.lines) {
      for (var pathAndPaint in brushLine.getPathsAndPaints()) {
        paths.add(pathAndPaint.item1);
        paints.add(pathAndPaint.item2);
      }
    }

    if (paths.isNotEmpty) {
      return ClipRect(
        child: Container(
          color: monsterCanvasColor,
          child: AnimatedDrawing.paths(
            paths,
            paints: paints,
            run: true,
            animationCurve: Curves.linear,
            animationOrder: PathOrders.original,
            scaleToViewport: false,
            duration: Duration(seconds: 3),
            scale: scale,
          ),
        ),
      );
    } else {
      return Container(
        color: monsterCanvasColor,
      );
    }
  }
}*/

/// TODO: Only used for testing brushes, remove when done testing
/*class BrushSelector extends StatelessWidget {
  BrushSelector({Key? key, required this.playCallback}) : super(key: key);

  final VoidCallback playCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var brushStyle in BrushStyle.values)
          CupertinoButton(
            onPressed: () {
              Get.find<BrushController>().currentBrush = brushStyle.randomizedBrush;
            },
            child: Text(
              "${brushStyle.humanReadableName}",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        CupertinoButton(
          child: Text('Clear'),
          onPressed: () {
            Get.find<ExperimentalDrawing>().clearDrawing();
          },
        ),
        CupertinoButton(
          child: Text('Play'),
          onPressed: playCallback,
        ),
      ],
    );
  }
}*/
