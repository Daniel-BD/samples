import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_rotation/animated_rotation.dart' as rotator;
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/screens/how_to_play_screen.dart';
import 'package:monstermaker/screens/waiting_room_screen/active_players.dart';
import 'package:monstermaker/screens/waiting_room_screen/drawing_time_settings.dart';
import 'package:monstermaker/screens/waiting_room_screen/room_code_text.dart';
import 'package:monstermaker/widgets/buttons.dart';
import 'package:monstermaker/colors.dart' as app_colors;

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({Key? key}) : super(key: key);

  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  bool _showErrorMessage = false;
  double _textAngle = 0.0;
  final Duration _animationDuration = const Duration(milliseconds: 75);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GetBuilder<GameController>(builder: (gameController) {
      if (gameController.currentGameRoom != null && gameController.currentGameRoom!.startedGame) {
        debugPrint('Game has started: ${gameController.currentGameRoom!.startedGame}');
        Future.microtask(() {
          Get.offAll(() => const HowToPlayScreen());
        });
      }

      return WillPopScope(
        onWillPop: () async {
          gameController.leaveGame();
          Get.back();
          return false;
        },
        child: CloudsBackgroundScreen(
          title: "Game Code",
          cloudPosition: CloudPosition.bottom,
          topLeftButton: TopLeftButtonType.quitButton,
          onTopLeftButtonPressed: () {
            gameController.leaveGame();
            Get.back();
          },
          firstChild: Column(
            children: [
              Flexible(
                child: gameController.currentGameRoom == null
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: AppConstants.smallVerticalSpacing),
                                child: RoomCodeText(code: gameController.currentGameRoom!.roomCode),
                              ),
                              Text(
                                'Invite your friends to join with the game code',
                                style: AppConstants.standardTextStyle(media: mediaQuery),
                              ),
                            ],
                          ),
                          DrawingTimeSetting(drawingTime: gameController.currentGameRoom!.drawingTime),
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppConstants.mediumVerticalSpacing),
                            child: _playersSection(gameController, mediaQuery),
                          ),
                        ],
                      ),
              ),
              if (gameController.currentGameRoom != null) _startGameButton(gameController)
            ],
          ),
        ),
      );
    });
  }

  /// Showing how many players are in the room and info text above and below
  Widget _playersSection(GameController gameController, MediaQueryData mediaQuery) {
    return Column(
      children: [
        AnimatedText(
            text:
                '${AppConstants.getRealNumberOfPlayers(gameController.currentGameRoom!.numberOfPlayersGameMode)} players are needed to play',
            textAngle: _textAngle,
            animationDuration: _animationDuration,
            mediaQuery: mediaQuery,
            showErrorMessage: _showErrorMessage),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.mediumVerticalSpacing),
          child: ActivePlayers(
            activePlayers: gameController.currentGameRoom!.activePlayers,
            numberOfPlayers: gameController.currentGameRoom!.numberOfPlayersGameMode,
          ),
        ),
        AnimatedText(
            text: gameController.currentGameRoom!.activePlayers == 1
                ? "1 player have joined the game\n(it's only you in here)"
                : '${gameController.currentGameRoom!.activePlayers} players have joined the game\n ',
            textAngle: _textAngle,
            animationDuration: _animationDuration,
            mediaQuery: mediaQuery,
            showErrorMessage: _showErrorMessage),
      ],
    );
  }

  /// The start game button, only visible for the host
  Widget _startGameButton(GameController gameController) {
    final bool isEnabled = gameController.currentGameRoom!.activePlayers ==
        AppConstants.getRealNumberOfPlayers(gameController.currentGameRoom!.numberOfPlayersGameMode);

    return Visibility(
      visible: gameController.currentGameRoom!.isHost,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppConstants.mediumVerticalSpacing,
        ),
        child: AppButton(
          assetNormal:
              'assets/images/Pressed=false, Type=StartGame, Enabled=' + (isEnabled ? 'true' : 'false') + '.png',
          assetPressedDown:
              'assets/images/Pressed=true, Type=StartGame, Enabled=' + (isEnabled ? 'true' : 'false') + '.png',
          onPressed: () async {
            if (isEnabled) {
              final success = await gameController.startGame();
              if (success) {
                //TODO: Navigate to next screen
              } else {
                //TODO: error handling
              }
            } else {
              _animateErrorMessage();
            }
          },
        ),
      ),
    );
  }

  void _animateErrorMessage() async {
    if (_showErrorMessage) {
      //If already animating, don't start this again.
      return;
    }
    setState(() {
      _textAngle = 6.0;
      _showErrorMessage = true;
    });
    await Future.delayed(_animationDuration);
    setState(() {
      _textAngle = -6.0;
    });
    await Future.delayed(_animationDuration);
    setState(() {
      _textAngle = 6.0;
    });
    await Future.delayed(_animationDuration);
    setState(() {
      _textAngle = -6.0;
    });
    await Future.delayed(_animationDuration);
    setState(() {
      _textAngle = 6.0;
    });
    await Future.delayed(_animationDuration);
    setState(() {
      _textAngle = 0.0;
    });
    await Future.delayed(_animationDuration * 8);
    setState(() {
      _showErrorMessage = false;
    });
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    Key? key,
    required this.text,
    required this.textAngle,
    required this.mediaQuery,
    required this.animationDuration,
    required this.showErrorMessage,
  }) : super(key: key);

  final String text;
  final double textAngle;
  final Duration animationDuration;
  final MediaQueryData mediaQuery;
  final bool showErrorMessage;

  @override
  Widget build(BuildContext context) {
    return rotator.AnimatedRotation(
      angle: textAngle,
      duration: animationDuration,
      curve: Curves.easeInOut,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppConstants.boldTextStyle(media: mediaQuery).copyWith(
          color: showErrorMessage ? app_colors.errorTextColor : Colors.black,
        ),
      ),
    );
  }
}
