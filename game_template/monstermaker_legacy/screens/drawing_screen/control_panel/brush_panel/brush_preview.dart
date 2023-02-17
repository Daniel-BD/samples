import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/controllers/brush_settings_controller.dart';
import 'package:monstermaker/custom_painting/brushes/brush_extensions.dart';
import 'package:monstermaker/custom_painting/brushes/brushes.dart';
import 'package:monstermaker/custom_painting/painting_widgets/brush_painter.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/close_panel_button.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/pop_up_panel_decoration.dart';
import '../../../../app_constants.dart';
import '../../../../../src/ui_components/colors.dart';
import '../../drawing_controller.dart';
import '../control_panel_controller.dart';
import 'brush_settings_widgets.dart';

class BrushPreview extends StatefulWidget {
  const BrushPreview({
    Key? key,
    required this.brushSettings,
    this.isFavorite = false,
    this.favoriteIndex,
  })  : assert(!(isFavorite && favoriteIndex == null), 'Invalid arguments'),
        super(key: key);

  final BrushSettings brushSettings;
  final bool isFavorite;
  final int? favoriteIndex;

  @override
  State<BrushPreview> createState() => _BrushPreviewState();
}

class _BrushPreviewState extends State<BrushPreview> {
  final _brushController = Get.find<DrawingController>().brushController;
  final _controlPanelController = Get.find<ControlPanelController>();
  bool showSettings = false;

  @override
  Widget build(BuildContext context) {
    assert(_brushController != null, 'brushController should not be null');
    var brushSetting = widget.brushSettings;
    if (brushSetting is BeadsBrushSettings && brushSetting.isRainbowColored) {
      brushSetting = brushSetting.copyWith(continueRainbow: false);
    }
    var brushLine = brushSetting
        .withScaleFactor(_brushController!.scaleFactor)
        .getBrushLineWithSettings();

    return Container(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
      padding: EdgeInsets.only(
          left: 8.0, right: 8.0, bottom: 8.0, top: widget.isFavorite ? 8.0 : 0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (!widget.isFavorite)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BrushPreviewButton(
                  buttonType: BrushPreviewButtonType.addToFavorites,
                  onPressed: () {
                    Get.find<BrushSettingsController>()
                        .addNewFavorite(widget.brushSettings);
                  },
                ),
              ],
            ),
          RepaintBoundary(
            child: CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                _brushController!.setCurrentBrush(widget.brushSettings);
                _controlPanelController.panelState = ControlPanelState.none;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: monsterCanvasColor,
                  border: Border.all(
                    color: panelDarkColor.withOpacity(0.1),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 1,
                  child: LayoutBuilder(builder: (context, constraints) {
                    final box = Size(
                      constraints.biggest.width * 0.6,
                      constraints.biggest.height * 0.6,
                    );
                    for (var point in sineWave(box)) {
                      brushLine.addPoint(point);
                    }
                    brushLine.endLine();

                    return ClipRect(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.biggest.width * 0.2,
                          vertical: constraints.biggest.height * 0.2,
                        ),
                        child: CustomPaint(
                          painter: BrushPainter(
                            [brushLine],
                            1.0,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.smallVerticalSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BrushPreviewButton(
                buttonType: showSettings
                    ? BrushPreviewButtonType.hideSettings
                    : BrushPreviewButtonType.showSettings,
                onPressed: () {
                  setState(() {
                    showSettings = !showSettings;
                  });
                },
              ),
              if (widget.isFavorite && widget.favoriteIndex != null)
                BrushPreviewButton(
                  buttonType: BrushPreviewButtonType.removeFromFavorite,
                  onPressed: () {
                    Get.find<BrushSettingsController>()
                        .removeFavorite(widget.favoriteIndex!);
                  },
                ),
              if (!widget.isFavorite)
                BrushPreviewButton(
                  buttonType: BrushPreviewButtonType.shuffle,
                  onPressed: () {
                    final randomSetting =
                        brushSetting.brushStyle.randomizedBrush;
                    Get.find<BrushSettingsController>()
                        .updateBrushSettings(randomSetting);
                  },
                ),
            ],
          ),
          if (showSettings) ...[
            const SizedBox(height: AppConstants.smallVerticalSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: SettingsPanel(
                oldSettings: brushSetting,
                onNewSettings: (newSettings) {
                  Get.find<BrushSettingsController>().updateBrushSettings(
                    newSettings,
                    isFavorite: widget.isFavorite,
                    favoriteIndex: widget.favoriteIndex,
                  );
                  _brushController!.setCurrentBrush(newSettings);
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  List<Offset> sineWave(Size box) {
    List<Offset> points = [];

    var dx = 0.1; // increase for performance vs accuracy
    var s = 0.0;
    var step = 0.15;

    double f(x) {
      return sin(x);
    }

    for (var x = 0.0; x < 2 * pi; x += dx) {
      // method using difference between successive y values to calculate dy
      // NB: in practise you should remember the value of fx from the previous
      // iteration to avoid two evaluations of f(x) per loop
      double fx = f(x);
      double dy = f(x + dx) - fx;
      double ds = sqrt(dx * dx + dy * dy);

      // alternate method using derivative of f(x)
      // var f_x = Math.cos(x);              // from calculus
      // var dy = dx * f_x;                  // dy/dx = f'(x)  -> dy = dx * f'(x)
      // var ds = dx * Math.sqrt(1 + f_x * f_x);

      // add up distance so far
      s += ds;

      if (s >= step) {
        var px = box.width * (x / (2 * pi));
        final halfHeight = (box.height / 2);
        var py = halfHeight * fx;

        points.add(Offset(px, py).translate(0, halfHeight));
        s -= step; // reset segment distance
      }
    }

    return points;
  }
}

enum BrushPreviewButtonType {
  showSettings,
  hideSettings,
  shuffle,
  addToFavorites,
  removeFromFavorite,
}

class BrushPreviewButton extends StatelessWidget {
  const BrushPreviewButton({
    Key? key,
    required this.buttonType,
    this.onPressed,
  }) : super(key: key);

  final BrushPreviewButtonType buttonType;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    String buttonText;
    Color? buttonColor;
    Color? textColor;

    switch (buttonType) {
      case BrushPreviewButtonType.showSettings:
        buttonText = 'Show Settings';
        buttonColor = const Color(0xFFDDE7FA);
        break;
      case BrushPreviewButtonType.hideSettings:
        buttonText = 'Hide Settings';
        buttonColor = const Color(0xFFDDE7FA);
        break;
      case BrushPreviewButtonType.shuffle:
        buttonText = 'Random';
        break;
      case BrushPreviewButtonType.addToFavorites:
        buttonText = 'Add to Favorites';
        break;
      case BrushPreviewButtonType.removeFromFavorite:
        buttonText = 'Remove';
        textColor = const Color(0xFFF16253);
        break;
    }

    return SizedBox(
      height: 35,
      child: CupertinoButton(
        color: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        onPressed: () => onPressed?.call(),
        child: Row(
          children: [
            if (buttonType == BrushPreviewButtonType.shuffle ||
                buttonType == BrushPreviewButtonType.removeFromFavorite)
              Icon(
                buttonType == BrushPreviewButtonType.shuffle
                    ? Icons.shuffle
                    : Icons.delete,
                size: 18.0,
                color: textColor ?? brushButtonTextColor,
              ),
            if (buttonType == BrushPreviewButtonType.shuffle)
              const SizedBox(width: AppConstants.smallHorizontalSpacing),
            Text(
              buttonText,
              style: AppConstants.brushPanelButtonTextStyle().copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
