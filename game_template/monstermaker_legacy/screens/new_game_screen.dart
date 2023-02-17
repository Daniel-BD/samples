import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/screens/game_settings_screen.dart';
import 'package:monstermaker/screens/join_game_screen.dart';
import 'package:monstermaker/widgets/buttons.dart';
import 'package:monstermaker/widgets/monster_maker_logo.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return CloudsBackgroundScreen(
      cloudPosition: CloudPosition.bottom,
      topLeftButton: TopLeftButtonType.backButton,
      firstChild: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalEdgePadding,
        ),
        child: Column(
          children: [
            SizedBox(
              height: AppConstants.largeAdaptiveVerticalSpacing(media: mediaQuery),
            ),
            const MonsterMakerLogo(),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    assetNormal: 'assets/images/Host game normal.png',
                    assetPressedDown: 'assets/images/Host game pressed.png',
                    onPressed: () {
                      Get.to(() => const GameSettingsScreen());
                    },
                  ),
                  SizedBox(
                    height: AppConstants.largeAdaptiveVerticalSpacing(media: mediaQuery),
                  ),
                  AppButton(
                    assetNormal: 'assets/images/Join game normal.png',
                    assetPressedDown: 'assets/images/Join game pressed.png',
                    onPressed: () => Get.to(() => const JoinGameScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
