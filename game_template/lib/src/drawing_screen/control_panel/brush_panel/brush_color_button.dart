import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/text_styles.dart';
import '../../../ui_components/ui_constants.dart';
import '../close_panel_button.dart';
import '../pop_up_panel_decoration.dart';
import 'brush_settings_widgets.dart';
import 'checkers_background.dart';

class BrushColorSettingsButton extends StatelessWidget {
  const BrushColorSettingsButton({
    super.key,
    required this.oldColor,
    required this.onColorChanged,
    this.oldSecondColor,
    this.isRainbowColored = false,
    this.onSecondColorChanged,
  });

  final Color oldColor;
  final Color? oldSecondColor;
  final bool isRainbowColored;
  final void Function(Color) onColorChanged;
  final void Function(Color)? onSecondColorChanged;

  @override
  Widget build(BuildContext context) {
    final twoColors = oldSecondColor != null && onSecondColorChanged != null;

    return !twoColors
        ? IntrinsicWidth(
            child: SettingsPanelColorPicker(
              oldColor: oldColor,
              colorNumber: twoColors ? 1 : null,
              onColorChanged: onColorChanged,
              isRainbowColored: isRainbowColored,
            ),
          )
        : Row(
            mainAxisAlignment: twoColors
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsPanelColorPicker(
                  oldColor: oldColor,
                  colorNumber: twoColors ? 1 : null,
                  onColorChanged: onColorChanged,
                ),
              ),
              SettingsSpacing(),
              Expanded(
                child: SettingsPanelColorPicker(
                  oldColor: oldSecondColor!,
                  colorNumber: 2,
                  onColorChanged: onSecondColorChanged!,
                ),
              ),
            ],
          );
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

    return SettingsContainer(
      padding: EdgeInsets.zero,
      child: CupertinoButton(
        minSize: settingButtonHeight,
        padding: EdgeInsets.symmetric(horizontal: 12),
        borderRadius: null,
        onPressed: () {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GameTextStyles.boldTextStyle(
                media: MediaQuery.of(context),
                isLandscape: true,
              ),
            ),
            const SizedBox(width: AppConstants.smallHorizontalSpacing),
            CheckersBackground(
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRainbowColored ? null : oldColor,
                  border: Border.all(
                    width: 2.0,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  gradient: isRainbowColored
                      ? SweepGradient(
                          colors: [
                            for (double i = 0; i < 360; i += 36)
                              rainbowColor(i),
                          ],
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color rainbowColor(double hue) {
    assert(hue <= 360.0 && hue >= 0.0);
    return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
  }
}

const _circleSize = 48.0;

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

  @override
  Widget build(BuildContext context) {
    List<double> hue = [0, 30, 58, 120, 176, 224, 277, 325];
    //List<double> saturation = [0.9, 0.7, 0.5, 0.5]; //[1, 1, 1, 1];
    List<double> lightness = [0.2, 0.45, 0.65, 0.75, 0.9];

    List<List<Color>> brushColorListTEMP = [
      [
        HSLColor.fromAHSL(1.0, 0, 0, 0).toColor(),
        HSLColor.fromAHSL(1.0, 0, 0, 0.2).toColor(),
        HSLColor.fromAHSL(1.0, 0, 0, 0.5).toColor(),
        HSLColor.fromAHSL(1.0, 0, 0, 0.75).toColor(),
        HSLColor.fromAHSL(1.0, 0, 0, 1).toColor(),
      ],
      for (int i = 0; i < 8; i++)
        [
          for (int j = 0; j < 5; j++)
            HSLColor.fromAHSL(
              1.0,
              hue[i],
              1, //saturation[j],
              lightness[j],
            ).toColor(),
        ]
    ];

    final media = MediaQuery.of(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
        child: PopUpPanelDecoration(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.smallVerticalSpacing,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
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
                          CheckersBackground(
                            child: Container(
                              height: _circleSize,
                              width: _circleSize,
                              decoration: BoxDecoration(
                                color: _newColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (final colorList in brushColorListTEMP)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final color in colorList)
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: _ColorButton(
                                          color: color,
                                          onPressed: () {
                                            setState(() {
                                              _newColor = color;
                                            });
                                          }),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ClosePanelButton(
                    onTapped: () {
                      widget.onColorChanged(_newColor);
                      Navigator.of(context).maybePop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const _ColorButton({
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: Container(
        height: _circleSize,
        width: _circleSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            width: 3.0,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
