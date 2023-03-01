import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/drawing_screen/control_panel/control_panel_controller.dart';
import 'package:game_template/src/drawing_screen/control_panel/pop_up_panel_decoration.dart';
import 'package:game_template/src/models/drawing.dart';
import 'package:game_template/src/theme/text_styles.dart';
import 'package:provider/provider.dart';

import '../../theme/colors.dart';
import '../../ui_components/ui_constants.dart';
import '../drawing_state.dart';
import 'brush_panel/brush_panel.dart';
import 'close_panel_button.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({
    super.key,
    required this.height,
    this.alwaysShown = true,
  });
  final double height;
  final bool alwaysShown;

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel>
    with SingleTickerProviderStateMixin {
  static const _buttonSizeMedium = 46.0;
  static const _buttonSizeBig = 56.0;
  static const _buttonSizeSmall = 30.0;

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget _openClose() {
    return CupertinoButton(
      onPressed: () {
        final controlPanelController = context.read<ControlPanelController>();
        controlPanelController.showingPanel =
            !controlPanelController.showingPanel;
        _animationController
            .animateTo(controlPanelController.showingPanel ? 0.0 : 1.0);
      },
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Icon(
        context.read<ControlPanelController>().showingPanel
            ? CupertinoIcons.chevron_compact_left
            : CupertinoIcons.chevron_compact_right,
        size: 36,
        color: controlPanelButtonColor,
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final drawMode = context.read<BrushState>().currentBrush.drawMode;
    final panelState = context.read<ControlPanelController>().panelState;

    return Container(
      color: drawingControlPanelColor.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ControlPanelButton(
              size: _buttonSizeMedium,
              imageAsset: 'assets/images/Settings.png',
              onPressed: () {},
            ),
            ControlPanelButton(
              size: _buttonSizeMedium,
              imageAsset: 'assets/images/Done.png',
              onPressed: () {},
            ),
            ControlPanelButton(
              size: _buttonSizeMedium,
              imageAsset: 'assets/images/Delete.png',
              onPressed: () {
                _showDeleteDrawingDialog(context);
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ControlPanelButton(
                  size: _buttonSizeSmall,
                  imageAsset: 'assets/images/Undo.png',
                  onPressed: () {
                    context.read<DrawingState>().undoBrushLine();
                  },
                ),
                const SizedBox(width: 24.0),
                ControlPanelButton(
                  size: _buttonSizeSmall,
                  imageAsset: 'assets/images/Redo.png',
                  onPressed: () {
                    context.read<DrawingState>().redoBrushLine();
                  },
                ),
              ],
            ),
            SizedBox(
              height: _buttonSizeBig,
              width: _buttonSizeBig,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: drawMode == DrawMode.brush
                            ? brushActiveColor
                            : brushInactiveColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: ControlPanelButton(
                      size: _buttonSizeBig,
                      imageAsset: drawMode == DrawMode.brush
                          ? 'assets/images/Active=true, Type=brush.png'
                          : 'assets/images/Active=false, Type=brush.png',
                      onPressed: () {
                        if (drawMode != DrawMode.brush) {
                          context
                              .read<BrushState>()
                              .setDrawMode(DrawMode.brush);

                          context.read<ControlPanelController>().panelState =
                              ControlPanelState.none;
                        } else {
                          if (panelState == ControlPanelState.brushSettings) {
                            context.read<ControlPanelController>().panelState =
                                ControlPanelState.none;
                          } else {
                            context.read<ControlPanelController>().panelState =
                                ControlPanelState.brushSettings;
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            ControlPanelButton(
              size: _buttonSizeBig,
              imageAsset: drawMode == DrawMode.eraser
                  ? 'assets/images/Active=true, Type=eraser.png'
                  : 'assets/images/Active=false, Type=eraser.png',
              onPressed: () {
                if (drawMode != DrawMode.eraser) {
                  context.read<BrushState>().setDrawMode(DrawMode.eraser);
                  context.read<ControlPanelController>().panelState =
                      ControlPanelState.none;
                } else {
                  if (panelState == ControlPanelState.eraserSettings) {
                    context.read<ControlPanelController>().panelState =
                        ControlPanelState.none;
                  } else {
                    context.read<ControlPanelController>().panelState =
                        ControlPanelState.eraserSettings;
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentBrushState = context.watch<BrushState>().currentBrush;
    final panelState = context
        .select<ControlPanelController, ControlPanelState>((c) => c.panelState);

    return Stack(
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  height: widget.height,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120.0,
                          child: _panel(context),
                        ),
                        if (!widget.alwaysShown)
                          SizedBox(
                            width: 120.0,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _openClose(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (currentBrushState.drawMode == DrawMode.eraser &&
                    panelState == ControlPanelState.eraserSettings)
                  Center(
                    child: _eraserControls(context),
                  ),
              ],
            ),
          ),
        ),
        if (currentBrushState.drawMode == DrawMode.brush &&
            panelState == ControlPanelState.brushSettings)
          Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.height + 100.0,
                maxWidth: 1200.0,
              ),
              child: const BrushPanel(),
            ),
          ),
      ],
    );
  }

  void _showDeleteDrawingDialog(BuildContext context) {
    final drawingState = context.read<DrawingState>();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
          child: SizedBox(
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: errorTextColor, width: 3.0),
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Delete your drawing?',
                      style: GameTextStyles.alertTitleTextStyle(),
                    ),
                    const SizedBox(
                      height: AppConstants.mediumVerticalSpacing,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                          child: Text(
                            'DELETE',
                            style: GameTextStyles.alertButtonTextStyle()
                                .copyWith(color: errorTextColor),
                          ),
                          onPressed: () {
                            drawingState.clearDrawing();
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                          child: Text(
                            'BACK',
                            style: GameTextStyles.alertButtonTextStyle()
                                .copyWith(color: blueTextButtonColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _eraserControls(BuildContext context) {
    var sliderWidth = 160.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopUpPanelDecoration(
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    ClosePanelButton(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: AppConstants.smallHorizontalSpacing,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Size',
                        style: GameTextStyles.smallTextStyle(
                            media: MediaQuery.of(context)),
                      ),
                      SizedBox(
                        width: sliderWidth,
                        child: Slider.adaptive(
                          value: context
                              .read<BrushState>()
                              .currentBrush
                              .currentEraserSize,
                          onChanged: (newValue) => context
                              .read<BrushState>()
                              .setEraserSize(newValue),
                          min: 8.0, //TODO: Replace with const variables?
                          max: 80.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: AppConstants.smallHorizontalSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Opacity',
                        style: GameTextStyles.smallTextStyle(
                            media: MediaQuery.of(context)),
                      ),
                      SizedBox(
                        width: sliderWidth,
                        child: Slider.adaptive(
                          value: context
                              .read<BrushState>()
                              .currentBrush
                              .currentEraserOpacity,
                          onChanged: (newValue) => context
                              .read<BrushState>()
                              .setEraserOpacity(newValue),
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: AppConstants.mediumVerticalSpacing,
        ),
        SizedBox(
          height: 80.0,
          width: 80.0,
          child: Center(
            child: Container(
              height: context.read<BrushState>().currentBrush.currentEraserSize,
              width: context.read<BrushState>().currentBrush.currentEraserSize,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(context
                    .read<BrushState>()
                    .currentBrush
                    .currentEraserOpacity),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ControlPanelButton extends StatelessWidget {
  const ControlPanelButton({
    super.key,
    required this.size,
    required this.imageAsset,
    required this.onPressed,
  });

  final double size;
  final String imageAsset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
        child: Image.asset(imageAsset),
      ),
    );
  }
}
