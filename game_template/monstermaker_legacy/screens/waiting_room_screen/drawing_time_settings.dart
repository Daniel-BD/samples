import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/colors.dart' as app_colors;
import 'package:monstermaker/widgets/segmented_controller.dart';

class DrawingTimeSetting extends StatefulWidget {
  const DrawingTimeSetting({Key? key, required this.drawingTime}) : super(key: key);

  final DrawingTimerMinutes drawingTime;

  @override
  _DrawingTimeSettingState createState() => _DrawingTimeSettingState();
}

class _DrawingTimeSettingState extends State<DrawingTimeSetting> {
  var isChangingTime = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GetBuilder<GameController>(builder: (gameController) {
      return gameController.currentGameRoom == null
          ? Container()
          : isChangingTime
              ? SegmentedController(
                  controllerType: SegmentedControllerType.drawingTimer,
                  drawingTime: gameController.currentGameRoom!.drawingTime,
                  timerCallBack: (DrawingTimerMinutes drawingTimer) async {
                    gameController.changeDrawingTime(drawingTimer);
                    setState(() {});
                    await Future.delayed(const Duration(milliseconds: 400));
                    setState(() => isChangingTime = false);
                  },
                )
              : Column(
                  children: [
                    Text(
                      "Drawing Time:",
                      textAlign: TextAlign.center,
                      style: AppConstants.standardTextStyle(media: mediaQuery),
                    ),
                    Text(
                      getDrawTimeText(widget.drawingTime),
                      textAlign: TextAlign.center,
                      style: AppConstants.boldTextStyle(media: mediaQuery),
                    ),
                    if (gameController.currentGameRoom!.isHost)
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                        onPressed: () => setState(() => isChangingTime = true),
                        child: Text(
                          "Change",
                          textAlign: TextAlign.center,
                          style: AppConstants.boldTextStyle(media: mediaQuery)
                              .copyWith(color: app_colors.blueTextButtonColor),
                        ),
                      )
                  ],
                );
    });
  }

  String getDrawTimeText(DrawingTimerMinutes drawingTime) {
    if (drawingTime == DrawingTimerMinutes.one) {
      return '1 minute';
    } else if (drawingTime == DrawingTimerMinutes.three) {
      return '3 minutes';
    } else if (drawingTime == DrawingTimerMinutes.five) {
      return '5 minutes';
    } else {
      return 'No Limit';
    }
  }
}
