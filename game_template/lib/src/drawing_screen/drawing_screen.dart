import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_template/src/drawing_screen/drawing_state.dart';
import 'package:provider/provider.dart';

import '../custom_painting/painting_widgets/brush_painter.dart';
import '../custom_painting/painting_widgets/painter.dart';
import '../models/drawing.dart';
import '../models/experimental_drawing.dart';
import '../theme/colors.dart';
import '../ui_components/ui_constants.dart';
import 'control_panel/brush_panel/brush_settings_controller.dart';
import 'control_panel/control_panel_controller.dart';
import 'control_panel/control_panel_widget.dart';
import 'dashed_line.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DrawingState(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => BrushState(),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => ControlPanelController()),
        ChangeNotifierProvider(
          create: (_) => BrushSettingsController(),
          lazy: false,
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Builder(
          builder: (context) {
            // GameController
            return Scaffold(
              backgroundColor: drawingControlPanelColor,
              body: SafeArea(
                bottom: false,
                top: false,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Selector<ControlPanelController, bool>(
                            selector: (_, controlPanel) =>
                                controlPanel.showingPanel,
                            builder: (_, showingPanel, __) {
                              return SizedBox(
                                width: showingPanel ? 120 : 0,
                              );
                            },
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AspectRatio(
                                aspectRatio:
                                    (AppConstants.drawingSectionAspectRatio),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Stack(
                                      children: [
                                        RepaintBoundary(
                                          child: DrawingCanvas(
                                            availableSize: constraints.biggest,
                                          ),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.topRight,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.all(16.0),
                                        //     child: DrawingTimer(
                                        //       time: gameController
                                        //           .currentGameRoom?.drawingTime,
                                        //       onTimesUp: () {
                                        //         //TODO: Pop up the hand in drawing modal here
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
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
                    Builder(builder: (context) {
                      final initialized = context
                          .select<DrawingState, bool>((s) => s.initialized);
                      return initialized
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                final panelHeight =
                                    ExperimentalDrawing.canvasSizeCalculator(
                                  constraints.biggest,
                                ).height;
                                return ControlPanel(
                                  height: panelHeight,
                                  alwaysShown: false,
                                );
                              },
                            )
                          : Container();
                    })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({
    super.key,
    required this.availableSize,
    this.drawingToContinueOn,
    this.scale = 1.0,
  });

  final Size availableSize;
  final Drawing? drawingToContinueOn;
  final double scale;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late final Drawing _myDrawing;
  late final Size _originalCanvasSize;
  late Size _canvasSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DrawingState>().setOriginalCanvasSize(widget.availableSize);
      context.read<BrushState>().setOriginalCanvasSize(widget.availableSize);
    });
    _originalCanvasSize =
        ExperimentalDrawing.canvasSizeCalculator(widget.availableSize);
  }

  Offset scaleCoordinate(Offset original, double scale) {
    return Offset(original.dx * scale, original.dy * scale);
  }

  @override
  Widget build(BuildContext context) {
    _canvasSize =
        ExperimentalDrawing.canvasSizeCalculator(widget.availableSize);
    final customPaintScale = _canvasSize.width / _originalCanvasSize.width;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        context.read<DrawingState>().startNewLine(
              startPoint: scaleCoordinate(details.localPosition,
                  _originalCanvasSize.width / _canvasSize.width),
              brushSettings:
                  context.read<BrushState>().currentBrush.currentBrushOrEraser,
            );
      },
      onPanUpdate: (details) {
        context.read<DrawingState>().addPoint(
              scaleCoordinate(details.localPosition,
                  _originalCanvasSize.width / _canvasSize.width),
            );
      },
      onPanEnd: (details) {
        context.read<DrawingState>().endCurrentLine();
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
                      widget.drawingToContinueOn!.getScaledPaths(
                          outputHeight: _myDrawing.originalHeight),
                      widget.drawingToContinueOn!.getScaledPaints(
                          outputHeight: _myDrawing.originalHeight),
                    ),
                  ),
                ),
              ),
            ),
          ClipRect(
            child: RepaintBoundary(
              child: CustomPaint(
                size: _canvasSize,
                isComplex: true,
                painter: BrushPainter(
                  drawingState: context.read<DrawingState>(),
                  scale: customPaintScale,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: DashedLine(),
          ),
        ],
      ),
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
