import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/theme/text_styles.dart';
import '../../../custom_painting/brushes/brushes.dart';
import '../../../theme/colors.dart';
import '../../../ui_components/ui_constants.dart';
import 'brush_color_button.dart';

class BrushSettingsPanel extends StatelessWidget {
  const BrushSettingsPanel({
    super.key,
    required this.oldSettings,
    required this.onNewSettings,
  });

  final BrushSettings oldSettings;
  final void Function(BrushSettings) onNewSettings;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Builder(builder: (context) {
              switch (oldSettings.brushStyle) {
                case BrushStyle.singleStroke:
                  final settings = (oldSettings as SingleStrokeBrushSettings);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.color,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(color: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        value: settings.width,
                        minValue: SingleStrokeBrushSettings.minWidth,
                        maxValue: SingleStrokeBrushSettings.maxWidth,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(width: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.stripedStroke:
                  final settings = (oldSettings as StripedStrokeBrushSettings);
                  return Column(
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.firstColor,
                        oldSecondColor: settings.secondColor,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(firstColor: color));
                        },
                        onSecondColorChanged: (color) {
                          onNewSettings(settings.copyWith(secondColor: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelToggle(
                        label: 'Rounded',
                        value: settings.rounded,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(rounded: value),
                        ),
                      ),
                      SettingsSpacing(),
                      Row(
                        children: [
                          Expanded(
                            child: SettingsPanelSlider(
                              value: settings.width,
                              minValue: StripedStrokeBrushSettings.minWidth,
                              maxValue: StripedStrokeBrushSettings.maxWidth,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(width: value),
                              ),
                            ),
                          ),
                          SettingsSpacing(),
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Stripe length',
                              value: settings.minStripeLength,
                              minValue:
                                  StripedStrokeBrushSettings.minMinStripeLength,
                              maxValue:
                                  StripedStrokeBrushSettings.maxMinStripeLength,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(minStripeLength: value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                case BrushStyle.doubleStroke:
                  final settings = (oldSettings as DoubleStrokeBrushSettings);
                  return Column(
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.firstColor,
                        oldSecondColor: settings.secondColor,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(firstColor: color));
                        },
                        onSecondColorChanged: (color) {
                          onNewSettings(settings.copyWith(secondColor: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        value: settings.width,
                        minValue: DoubleStrokeBrushSettings.minWidth,
                        maxValue: DoubleStrokeBrushSettings.maxWidth,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(width: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.wiggleFilled:
                  final settings = (oldSettings as WiggleBrushSettings);
                  return Column(
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.color,
                        oldSecondColor: settings.secondColor,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(color: color));
                        },
                        onSecondColorChanged: (color) {
                          onNewSettings(settings.copyWith(secondColor: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        label: 'Diameter',
                        value: settings.minDiameter,
                        minValue: WiggleBrushSettings.minDiameterRange,
                        maxValue: WiggleBrushSettings.maxDiameterRange,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(minDiameter: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.wiggleNotFilled:
                  final settings = (oldSettings as WiggleBrushSettings);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.color,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(color: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        value: settings.strokeWidth,
                        minValue: WiggleBrushSettings.minStrokeWidth,
                        maxValue: WiggleBrushSettings.maxStrokeWidth,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(strokeWidth: value),
                        ),
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        label: 'Diameter',
                        value: settings.minDiameter,
                        minValue: WiggleBrushSettings.minDiameterRange,
                        maxValue: WiggleBrushSettings.maxDiameterRange,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(minDiameter: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.beads:
                  final settings = (oldSettings as BeadsBrushSettings);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SettingsPanelToggle(
                              label: 'Rainbow',
                              value: settings.isRainbowColored,
                              onValueChanged: (value) {
                                onNewSettings(
                                  settings.copyWith(
                                    color: value ? null : brushColors.first,
                                    isRainbowColored: value,
                                  ),
                                );
                              },
                            ),
                          ),
                          SettingsSpacing(),
                          Expanded(
                            child: BrushColorSettingsButton(
                              isRainbowColored: settings.isRainbowColored,
                              oldColor: settings.color ?? brushColors.first,
                              onColorChanged: (color) {
                                onNewSettings(
                                  settings.copyWith(
                                    color: color,
                                    isRainbowColored: false,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        label: 'Diameter',
                        value: settings.minCircleDiameter,
                        minValue: BeadsBrushSettings.minDiameter,
                        maxValue: BeadsBrushSettings.maxDiameter,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(minCircleDiameter: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.angledThick:
                  final settings = (oldSettings as AngledThickBrushSettings);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.color,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(color: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        value: settings.width,
                        minValue: AngledThickBrushSettings.minWidth,
                        maxValue: AngledThickBrushSettings.maxWidth,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(width: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.starryNight:
                  final settings = (oldSettings as StarryNightBrushSettings);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.color,
                        oldSecondColor: settings.secondColor,
                        onSecondColorChanged: (color) {
                          onNewSettings(
                            settings.copyWith(
                              secondColor: color,
                            ),
                          );
                        },
                        onColorChanged: (color) {
                          onNewSettings(
                            settings.copyWith(
                              color: color,
                            ),
                          );
                        },
                      ),
                      SettingsSpacing(),
                      Row(
                        children: [
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Width',
                              value: settings.strokeWidth,
                              minValue: StarryNightBrushSettings.minStrokeWidth,
                              maxValue: StarryNightBrushSettings.maxStrokeWidth,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(strokeWidth: value),
                              ),
                            ),
                          ),
                          SettingsSpacing(),
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Sprawl',
                              value: settings.sprawl,
                              minValue: StarryNightBrushSettings.minSprawl,
                              maxValue: StarryNightBrushSettings.maxSprawl,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(sprawl: value),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SettingsSpacing(),
                      Row(
                        children: [
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Grain length',
                              value: settings.grainLength,
                              minValue: StarryNightBrushSettings.minGrainLength,
                              maxValue: StarryNightBrushSettings.maxGrainLength,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(grainLength: value),
                              ),
                            ),
                          ),
                          SettingsSpacing(),
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Grain thickness',
                              value: settings.grainThickness,
                              minValue:
                                  StarryNightBrushSettings.minGrainThickness,
                              maxValue:
                                  StarryNightBrushSettings.maxGrainThickness,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(grainThickness: value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                case BrushStyle.splatterDots:
                  final settings = (oldSettings as SplatterDotsBrushSettings);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: BrushColorSettingsButton(
                              oldColor: settings.color,
                              onColorChanged: (color) {
                                onNewSettings(settings.copyWith(color: color));
                              },
                            ),
                          ),
                          SettingsSpacing(),
                          Expanded(
                            child: SettingsPanelToggle(
                              label: 'Circular',
                              value: settings.circular,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(circular: value),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        value: settings.strokeWidth,
                        minValue: SplatterDotsBrushSettings.minStrokeWidth,
                        maxValue: SplatterDotsBrushSettings.maxStrokeWidth,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(strokeWidth: value),
                        ),
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        label: 'Particle size',
                        value: settings.dotSize,
                        minValue: SplatterDotsBrushSettings.minDotSize,
                        maxValue: SplatterDotsBrushSettings.maxDotSize,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(dotSize: value),
                        ),
                      ),
                    ],
                  );
                case BrushStyle.triangles:
                  final settings = (oldSettings as TriangleBrushSettings);
                  return Column(
                    children: [
                      BrushColorSettingsButton(
                        oldColor: settings.color,
                        oldSecondColor: settings.secondColor,
                        onColorChanged: (color) {
                          onNewSettings(settings.copyWith(color: color));
                        },
                        onSecondColorChanged: (color) {
                          onNewSettings(settings.copyWith(secondColor: color));
                        },
                      ),
                      SettingsSpacing(),
                      SettingsPanelSlider(
                        value: settings.strokeWidth,
                        minValue: TriangleBrushSettings.minStrokeWidth,
                        maxValue: TriangleBrushSettings.maxStrokeWidth,
                        onValueChanged: (value) => onNewSettings(
                          settings.copyWith(strokeWidth: value),
                        ),
                      ),
                      SettingsSpacing(),
                      Row(
                        children: [
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Triangle height',
                              value: settings.heightFactor,
                              minValue: TriangleBrushSettings.minHeightFactor,
                              maxValue: TriangleBrushSettings.maxHeightFactor,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(heightFactor: value),
                              ),
                            ),
                          ),
                          SettingsSpacing(),
                          Expanded(
                            child: SettingsPanelSlider(
                              label: 'Triangle size',
                              value: settings.minBaseWidth,
                              minValue: TriangleBrushSettings.minBaseWidthValue,
                              maxValue: TriangleBrushSettings.maxBaseWidthValue,
                              onValueChanged: (value) => onNewSettings(
                                settings.copyWith(minBaseWidth: value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                case BrushStyle.rainbow:
                  final settings = (oldSettings as RainbowBrushSettings);

                  return SettingsPanelSlider(
                    label: 'Width',
                    value: settings.width,
                    minValue: RainbowBrushSettings.minWidth,
                    maxValue: RainbowBrushSettings.maxWidth,
                    onValueChanged: (value) => onNewSettings(
                      settings.copyWith(width: value),
                    ),
                  );
                case BrushStyle.eraser:
                  assert(false, 'This should never happen');
                  break;
              }

              return Container();
            }),
          ),
        ),
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({
    required this.child,
    this.height,
    this.padding,
    super.key,
  });

  final Widget child;
  final double? height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFD0D0D0), //Colors.black.withOpacity(0.1),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: child,
    );
  }
}

class SettingsPanelSlider extends StatelessWidget {
  const SettingsPanelSlider({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onValueChanged,
    this.label = 'Stroke width',
    this.divisions,
    super.key,
  });

  final String label;
  final double value, minValue, maxValue;
  final int? divisions;
  final void Function(double) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label,
            style: GameTextStyles.boldTextStyle(
              media: MediaQuery.of(context),
              isLandscape: true,
            ),
          ),
          const SizedBox(width: AppConstants.smallHorizontalSpacing),
          CupertinoSlider(
            value: value,
            divisions: divisions,
            onChanged: onValueChanged,
            min: minValue,
            max: maxValue,
          ),
        ],
      ),
    );
  }
}

class SettingsPanelToggle extends StatelessWidget {
  const SettingsPanelToggle({
    required this.label,
    required this.value,
    required this.onValueChanged,
    super.key,
  });

  final String label;
  final bool value;
  final void Function(bool) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      height: settingButtonHeight,
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
          CupertinoSwitch(
            value: value,
            onChanged: onValueChanged,
          ),
        ],
      ),
    );
  }
}

class SettingsSpacing extends StatelessWidget {
  const SettingsSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 4,
      width: 4,
    );
  }
}

const settingButtonHeight = 54.0;
