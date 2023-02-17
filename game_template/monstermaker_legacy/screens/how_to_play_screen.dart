import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/screens/drawing_screen/drawing_screen.dart';
import 'package:monstermaker/widgets/buttons.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

  @override
  _HowToPlayScreenState createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CloudsBackgroundScreen(
        cloudPosition: CloudPosition.bottom,
        title: 'How To Play',
        minimizeBottomClouds: true,
        topLeftButton: TopLeftButtonType.none,
        firstChild: GetBuilder<GameController>(builder: (gameController) {
          final texts =
              _getTimeText(gameController.currentGameRoom!.drawingTime);

          return Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  top: false,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All players will draw 3 parts: top, middle, bottom.\nThe drawings will be stitched together into monsters' +
                                '\n\nMake sure to draw below the dashed line so the next\nplayer have something to continue on.\n ',
                            style: AppConstants.standardTextStyle(
                                media: mediaQuery, isLandscape: true),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < texts.length; i++)
                                Text(
                                  texts[i],
                                  style: i == 1
                                      ? AppConstants.boldTextStyle(
                                          media: mediaQuery, isLandscape: true)
                                      : AppConstants.standardTextStyle(
                                          media: mediaQuery, isLandscape: true),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.smallVerticalSpacing),
                child: AppButton(
                  assetNormal:
                      'assets/images/Pressed=false, Type=Draw, Enabled=true.png',
                  assetPressedDown:
                      'assets/images/Pressed=true, Type=Draw, Enabled=true.png',
                  onPressed: () {
                    Get.offAll(() => const DrawingScreen());
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  List<String> _getTimeText(DrawingTimerMinutes drawTime) {
    List<String> text = [];

    if (drawTime == DrawingTimerMinutes.one) {
      text.add('You have');
      text.add(' 1 minute');
      text.add(' to complete each drawing.');
      return text;
    } else if (drawTime == DrawingTimerMinutes.three) {
      text.add('You have');
      text.add(' 3 minutes');
      text.add(' to complete each drawing.');
      return text;
    } else if (drawTime == DrawingTimerMinutes.five) {
      text.add('You have');
      text.add(' 5 minutes');
      text.add(' to complete each drawing.');
      return text;
    } else {
      text.add('There is');
      text.add(' no time limit');
      text.add(' for drawing.');
      return text;
    }
  }
}
