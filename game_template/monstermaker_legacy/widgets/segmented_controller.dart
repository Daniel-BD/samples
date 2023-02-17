import 'package:flutter/material.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';

enum SegmentedControllerType { numberOfPlayers, drawingTimer }

class SegmentedController extends StatelessWidget {
  const SegmentedController({
    Key? key,
    required this.controllerType,
    this.numberOfPlayers,
    this.drawingTime,
    this.playersCallBack,
    this.timerCallBack,
  })  : assert(
            (controllerType == SegmentedControllerType.numberOfPlayers &&
                    numberOfPlayers != null &&
                    playersCallBack != null) ||
                (controllerType == SegmentedControllerType.drawingTimer &&
                    drawingTime != null &&
                    timerCallBack != null),
            "SegmentedController has been given incorrect combination of arguments."),
        super(key: key);

  final SegmentedControllerType controllerType;
  final NumberOfPlayers? numberOfPlayers;
  final DrawingTimerMinutes? drawingTime;
  final void Function(DrawingTimerMinutes drawingTime)? timerCallBack;
  final void Function(NumberOfPlayers numberOfPlayers)? playersCallBack;
  static const selectorColor = Color(0xFFF6FCFF);
  static const selectorRadius = 3.0;
  static const maxWidth = 500.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalEdgePadding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: selectorColor,
            borderRadius: BorderRadius.circular(selectorRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 4; i++)
                SegmentedControllerButton(
                  buttonType: buttonType(i),
                  selected: isSelected(i),
                  index: i,
                  onPressed: () {
                    if (controllerType == SegmentedControllerType.numberOfPlayers) {
                      playersCallBack!(NumberOfPlayers.values[i]);
                    } else if (controllerType == SegmentedControllerType.drawingTimer) {
                      timerCallBack!(DrawingTimerMinutes.values[i]);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  SegmentedControllerButtonType buttonType(int buttonIndex) {
    assert(buttonIndex >= 0 && buttonIndex <= 3, 'buttonIndex is out of range');
    if (controllerType == SegmentedControllerType.numberOfPlayers) {
      return SegmentedControllerButtonType.number;
    } else if (controllerType == SegmentedControllerType.drawingTimer && buttonIndex != 3) {
      return SegmentedControllerButtonType.time;
    }
    return SegmentedControllerButtonType.noLimit;
  }

  bool isSelected(int buttonIndex) {
    assert(buttonIndex >= 0 && buttonIndex <= 3, 'buttonIndex is out of range');
    return controllerType == SegmentedControllerType.numberOfPlayers
        ? numberOfPlayers == NumberOfPlayers.values[buttonIndex]
        : drawingTime == DrawingTimerMinutes.values[buttonIndex];
  }
}

enum SegmentedControllerButtonType { number, time, noLimit }

class SegmentedControllerButton extends StatelessWidget {
  const SegmentedControllerButton({
    Key? key,
    required this.buttonType,
    required this.selected,
    required this.index,
    required this.onPressed,
  })  : assert(index >= 0 && index <= 3, 'index is out of range'),
        super(key: key);

  final SegmentedControllerButtonType buttonType;
  final bool selected;
  final int index;
  final VoidCallback onPressed;
  static const selectorTextColor = Color(0xFF6D6D6D);
  static const selectedBorderWidth = 2.0;
  static const selectorRadius = 3.0;
  static const buttonHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final selectorTextStyle = getButtonTextStyle(mediaQuery);
    final buttonText = getButtonText();

    return Expanded(
      child: SizedBox(
        height: buttonHeight,
        child: TextButton(
          onPressed: onPressed,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Stack(
                children: [
                  Container(
                    child: Center(
                      child: Stack(
                        children: [
                          if (selected)
                            Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: selectorTextStyle.copyWith(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = buttonType == SegmentedControllerButtonType.noLimit ? 2.0 : 3.0
                                  ..color = Colors.black,
                              ),
                            ),
                          Text(
                            buttonText,
                            textAlign: TextAlign.center,
                            style: selectorTextStyle.copyWith(
                              color: selected ? Colors.white : selectorTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: selected
                        ? BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: selectedBorderWidth,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectorRadius,
                            ),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFE833), Color(0xFFFFC601)],
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle getButtonTextStyle(MediaQueryData media) {
    return AppConstants.standardTextStyle(media: media).copyWith(
        color: selectorTextColor,
        fontSize: buttonType == SegmentedControllerButtonType.number
            ? 40
            : buttonType == SegmentedControllerButtonType.time
                ? 30
                : 20);
  }

  String getButtonText() {
    if (buttonType == SegmentedControllerButtonType.time || buttonType == SegmentedControllerButtonType.noLimit) {
      switch (index) {
        case 0:
          return "1m";
        case 1:
          return "3m";
        case 2:
          return "5m";
        case 3:
          return "No\nLimit";
        default:
          return "";
      }
    } else {
      switch (index) {
        case 0:
          return "2";
        case 1:
          return "3";
        case 2:
          return "4";
        case 3:
          return "5";
        default:
          return "";
      }
    }
  }
}
