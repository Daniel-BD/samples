import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/theme/text_styles.dart';
import '../../../custom_painting/brushes/brushes.dart';
import '../../../theme/colors.dart';
import '../../../ui_components/ui_constants.dart';
import '../close_panel_button.dart';
import '../pop_up_panel_decoration.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.oldSettings,
    required this.onNewSettings,
  });

  final BrushSettings oldSettings;
  final void Function(BrushSettings) onNewSettings;

  @override
  Widget build(BuildContext context) {
    switch (oldSettings.brushStyle) {
      case BrushStyle.singleStroke:
        final settings = (oldSettings as SingleStrokeBrushSettings);
        return Column(
          children: [
            SettingsPanelColorPicker(
              oldColor: settings.color,
              onColorChanged: (color) {
                onNewSettings(settings.copyWith(color: color));
              },
            ),
          ],
        );
      case BrushStyle.stripedStroke:
        final settings = (oldSettings as StripedStrokeBrushSettings);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsPanelColorPicker(
                  oldColor: settings.firstColor,
                  colorNumber: 1,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(firstColor: color));
                  },
                ),
                SettingsPanelColorPicker(
                  oldColor: settings.secondColor,
                  colorNumber: 2,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(secondColor: color));
                  },
                ),
              ],
            ),
          ],
        );
      case BrushStyle.doubleStroke:
        final settings = (oldSettings as DoubleStrokeBrushSettings);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsPanelColorPicker(
                  oldColor: settings.firstColor,
                  colorNumber: 1,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(firstColor: color));
                  },
                ),
                SettingsPanelColorPicker(
                  oldColor: settings.secondColor,
                  colorNumber: 2,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(secondColor: color));
                  },
                ),
              ],
            ),
          ],
        );
      case BrushStyle.wiggleFilled:
        final settings = (oldSettings as WiggleBrushSettings);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsPanelColorPicker(
                  oldColor: settings.color,
                  colorNumber: 1,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(color: color));
                  },
                ),
                SettingsPanelColorPicker(
                  oldColor: settings.secondColor ?? settings.color,
                  colorNumber: 2,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(secondColor: color));
                  },
                ),
              ],
            ),
          ],
        );
      case BrushStyle.wiggleNotFilled:
        final settings = (oldSettings as WiggleBrushSettings);
        return Column(
          children: [
            SettingsPanelColorPicker(
              oldColor: settings.color,
              onColorChanged: (color) {
                onNewSettings(settings.copyWith(color: color));
              },
            ),
          ],
        );
      case BrushStyle.beads:
        final settings = (oldSettings as BeadsBrushSettings);
        return Column(
          children: [
            SettingsPanelColorPicker(
              isRainbowColored: settings.isRainbowColored,
              oldColor: settings.color ?? Colors.transparent,
              onColorChanged: (color) {
                onNewSettings(
                  settings.copyWith(
                    color: color,
                    isRainbowColored: false,
                  ),
                );
              },
            ),
          ],
        );
      case BrushStyle.angledThick:
        final settings = (oldSettings as AngledThickBrushSettings);
        return Column(
          children: [
            SettingsPanelColorPicker(
              oldColor: settings.color,
              onColorChanged: (color) {
                onNewSettings(settings.copyWith(color: color));
              },
            ),
          ],
        );
      case BrushStyle.starryNight:
        // TODO: Handle this case.
        break;
      case BrushStyle.splatterDots:
        // TODO: Handle this case.
        break;
      case BrushStyle.triangles:
        final settings = (oldSettings as TriangleBrushSettings);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SettingsPanelColorPicker(
                  oldColor: settings.color,
                  colorNumber: 1,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(color: color));
                  },
                ),
                SettingsPanelColorPicker(
                  oldColor: settings.secondColor ?? settings.color,
                  colorNumber: 2,
                  onColorChanged: (color) {
                    onNewSettings(settings.copyWith(secondColor: color));
                  },
                ),
              ],
            ),
          ],
        );
      case BrushStyle.rainbow:
        // TODO: Handle this case.
        break;
      case BrushStyle.eraser:
        // TODO: Handle this case.
        break;
    }

    return Container();
  }
}

class SettingsPanelColorPicker extends StatelessWidget {
  const SettingsPanelColorPicker({
    super.key,
    required this.oldColor,
    this.colorNumber,
    this.isRainbowColored = false,
    required this.onColorChanged,
  });

  final Color oldColor;
  final int? colorNumber;
  final bool isRainbowColored;
  final void Function(Color) onColorChanged;

  @override
  Widget build(BuildContext context) {
    final label =
        'Color${colorNumber != null ? ' ${colorNumber.toString()}' : ''}';

    return Row(
      children: [
        Text(
          label,
          style: GameTextStyles.boldTextStyle(
            media: MediaQuery.of(context),
            isLandscape: true,
          ),
        ),
        const SizedBox(width: AppConstants.smallHorizontalSpacing),
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              context: context,
              pageBuilder: (buildContext, _, __) {
                return ColorPicker(
                  onColorChanged: onColorChanged,
                  oldColor: oldColor,
                );
              },
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              transitionDuration: const Duration(milliseconds: 150),
            );
          },
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRainbowColored ? null : oldColor,
              gradient: isRainbowColored
                  ? SweepGradient(
                      colors: [
                        for (double i = 0; i < 360; i += 36) rainbowColor(i),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  static Color rainbowColor(double hue) {
    assert(hue <= 360.0 && hue >= 0.0);
    return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
  }
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.onColorChanged,
    required this.oldColor,
  });
  final void Function(Color) onColorChanged;
  final Color oldColor;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late var _newColor = widget.oldColor;
  static const _circleSize = 48.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
        child: PopUpPanelDecoration(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 0),
            child: Material(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.mediumVerticalSpacing,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppConstants.mediumVerticalSpacing,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Opacity',
                                style: GameTextStyles.boldTextStyle(
                                    media: media, isLandscape: true),
                              ),
                              const SizedBox(
                                  width: AppConstants.smallVerticalSpacing),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: media.size.width / 3,
                                ),
                                child: Slider.adaptive(
                                  value: max(_newColor.opacity, 0.3),
                                  min: 0.3,
                                  onChanged: (value) {
                                    setState(() {
                                      _newColor = _newColor.withOpacity(value);
                                    });
                                  },
                                ),
                              ),
                              Container(
                                //TODO: shackrutor bakom
                                height: _circleSize,
                                width: _circleSize,
                                decoration: BoxDecoration(
                                  color: _newColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.smallHorizontalSpacing,
                            ),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 12.0,
                                runSpacing: 12.0,
                                children: [
                                  for (final color in brushColors)
                                    CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          _newColor = color;
                                        });
                                      },
                                      child: Container(
                                        height: _circleSize,
                                        width: _circleSize,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 3.0,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ClosePanelButton(
                            onTapped: () {
                              widget.onColorChanged(_newColor);
                              Navigator.of(context).maybePop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
