import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/screens/waiting_room_screen/waiting_room_screen.dart';
import 'package:monstermaker/widgets/buttons.dart';
import 'package:monstermaker/widgets/segmented_controller.dart';

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({Key? key}) : super(key: key);

  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  final settings = GameSettings().obs;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return CloudsBackgroundScreen(
      title: "Game Settings",
      cloudPosition: CloudPosition.bottom,
      topLeftButton: TopLeftButtonType.backButton,
      firstChild: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Column(
            children: [
              Text(
                'Number of Players',
                style: AppConstants.boldTextStyle(media: mediaQuery),
              ),
              const SizedBox(height: AppConstants.smallVerticalSpacing),
              Obx(
                () => SegmentedController(
                  controllerType: SegmentedControllerType.numberOfPlayers,
                  numberOfPlayers: settings.value.numberOfPlayers,
                  playersCallBack: (NumberOfPlayers numberOfPlayers) {
                    settings.update((value) {
                      value!.numberOfPlayers = numberOfPlayers;
                    });
                  },
                ),
              ),
              SizedBox(height: AppConstants.largeAdaptiveVerticalSpacing(media: mediaQuery)),
              Text(
                'Drawing Time',
                style: AppConstants.boldTextStyle(media: mediaQuery),
              ),
              const SizedBox(height: AppConstants.smallVerticalSpacing),
              Obx(
                () => SegmentedController(
                  controllerType: SegmentedControllerType.drawingTimer,
                  drawingTime: settings.value.drawingTimerMinutes,
                  timerCallBack: (DrawingTimerMinutes drawingTimer) {
                    settings.update((value) {
                      value!.drawingTimerMinutes = drawingTimer;
                    });
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.mediumVerticalSpacing),
            child: AppButton(
              assetNormal: 'assets/images/Create game button not pressed.png',
              assetPressedDown: 'assets/images/Create game button pressed.png',
              onPressed: () async {
                if (!isLoading) {
                  isLoading = true;
                  final success = await Get.find<GameController>().createGameRoom(settings.value);
                  if (success) {
                    Get.to(() => const WaitingRoomScreen());
                  } else {
                    debugPrint('Failed to create game room');
                  }
                  isLoading = false;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
