import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/brush_panel/brush_panel.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/close_panel_button.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/control_panel_controller.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/pop_up_panel_decoration.dart';
import 'package:monstermaker/screens/drawing_screen/drawing_controller.dart';
import '../../../app_constants.dart';
import '../../../../src/ui_components/colors.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({
    Key? key,
    required this.height,
    this.alwaysShown = true,
  }) : super(key: key);
  final double height;
  final bool alwaysShown;

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel>
    with SingleTickerProviderStateMixin {
  final _controlPanelController = Get.find<ControlPanelController>();
  final _brushController = Get.find<DrawingController>().brushController;
  final _drawingController = Get.find<DrawingController>();

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
  void initState() {
    super.initState();
    assert(_brushController != null, 'brushController should not be null');
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget _openClose() {
    return CupertinoButton(
      onPressed: () {
        _controlPanelController.showingPanel =
            !_controlPanelController.showingPanel;
        _animationController
            .animateTo(_controlPanelController.showingPanel ? 0.0 : 1.0);
      },
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Icon(
        _controlPanelController.showingPanel
            ? CupertinoIcons.chevron_compact_left
            : CupertinoIcons.chevron_compact_right,
        size: 36,
        color: controlPanelButtonColor,
      ),
    );
  }

  Widget _panel(BuildContext context) {
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
                    _drawingController.undoBrushLine();
                  },
                ),
                const SizedBox(width: 24.0),
                ControlPanelButton(
                  size: _buttonSizeSmall,
                  imageAsset: 'assets/images/Redo.png',
                  onPressed: () {
                    _drawingController.redoBrushLine();
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
                        color:
                            _brushController!.drawMode.value == DrawMode.brush
                                ? brushActiveColor
                                : brushInactiveColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: ControlPanelButton(
                      size: _buttonSizeBig,
                      imageAsset:
                          _brushController!.drawMode.value == DrawMode.brush
                              ? 'assets/images/Active=true, Type=brush.png'
                              : 'assets/images/Active=false, Type=brush.png',
                      onPressed: () {
                        if (_brushController!.drawMode.value !=
                            DrawMode.brush) {
                          _brushController!.drawMode.value = DrawMode.brush;

                          _controlPanelController.panelState =
                              ControlPanelState.none;
                        } else {
                          if (_controlPanelController.panelState ==
                              ControlPanelState.brushSettings) {
                            _controlPanelController.panelState =
                                ControlPanelState.none;
                          } else {
                            _controlPanelController.panelState =
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
              imageAsset: _brushController!.drawMode.value == DrawMode.eraser
                  ? 'assets/images/Active=true, Type=eraser.png'
                  : 'assets/images/Active=false, Type=eraser.png',
              onPressed: () {
                if (_brushController!.drawMode.value != DrawMode.eraser) {
                  _brushController!.drawMode.value = DrawMode.eraser;

                  _controlPanelController.panelState = ControlPanelState.none;
                } else {
                  if (_controlPanelController.panelState ==
                      ControlPanelState.eraserSettings) {
                    _controlPanelController.panelState = ControlPanelState.none;
                  } else {
                    _controlPanelController.panelState =
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
    return GetBuilder<ControlPanelController>(
        builder: (controlPanelController) {
      return Obx(
        () => Stack(
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
                    if (_brushController!.drawMode.value == DrawMode.eraser &&
                        controlPanelController.panelState ==
                            ControlPanelState.eraserSettings)
                      Center(
                        child: _eraserSizeControl(),
                      ),
                  ],
                ),
              ),
            ),
            if (_brushController!.drawMode.value == DrawMode.brush &&
                controlPanelController.panelState ==
                    ControlPanelState.brushSettings)
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
        ),
      );
    });
  }

  void _showDeleteDrawingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
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
                      style: AppConstants.alertTitleTextStyle(),
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
                            style: AppConstants.alertButtonTextStyle()
                                .copyWith(color: errorTextColor),
                          ),
                          onPressed: () {
                            _drawingController.clearDrawing();
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                          child: Text(
                            'BACK',
                            style: AppConstants.alertButtonTextStyle()
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

  Widget _eraserSizeControl() {
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
                      horizontal: AppConstants.smallHorizontalSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Size',
                        style: AppConstants.smallTextStyle(
                            media: MediaQuery.of(context)),
                      ),
                      SizedBox(
                        width: sliderWidth,
                        child: Slider.adaptive(
                          value: _brushController!.currentEraserSize.value,
                          onChanged: (newValue) => _brushController!
                              .currentEraserSize.value = newValue,
                          min: 8.0,
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
                        style: AppConstants.smallTextStyle(
                            media: MediaQuery.of(context)),
                      ),
                      SizedBox(
                        width: sliderWidth,
                        child: Slider.adaptive(
                          value: _brushController!.currentEraserOpacity.value,
                          onChanged: (newValue) => _brushController!
                              .currentEraserOpacity.value = newValue,
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
              height: _brushController!.currentEraserSize.value,
              width: _brushController!.currentEraserSize.value,
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(_brushController!.currentEraserOpacity.value),
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
    Key? key,
    required this.size,
    required this.imageAsset,
    required this.onPressed,
  }) : super(key: key);

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
        child: Image.asset(imageAsset),
        onPressed: onPressed,
      ),
    );
  }
}
