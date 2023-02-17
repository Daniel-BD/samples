import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/screens/waiting_room_screen/waiting_room_screen.dart';
import 'package:monstermaker/widgets/buttons.dart';
import 'package:monstermaker/colors.dart' as appColors;

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({Key? key}) : super(key: key);

  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  bool showErrorMessage = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return CloudsBackgroundScreen(
      title: 'Enter Game Code',
      cloudPosition: CloudPosition.bottom,
      topLeftButton: TopLeftButtonType.backButton,
      firstChild: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.smallVerticalSpacing),
                  child: RoomCodeTextField(textController: textController),
                ),
                Text(
                  'Ask the game host for the code',
                  style: AppConstants.boldTextStyle(media: mediaQuery),
                ),
                Visibility(
                  visible: showErrorMessage,
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.mediumVerticalSpacing,
                    ),
                    child: Text(
                      'Failed to join game\nMake sure the code is correct',
                      textAlign: TextAlign.center,
                      style: AppConstants.boldTextStyle(media: mediaQuery).copyWith(color: appColors.errorTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppConstants.mediumVerticalSpacing,
            ),
            child: AppButton(
              assetNormal: 'assets/images/Join game normal.png',
              assetPressedDown: 'assets/images/Join game pressed.png',
              onPressed: () async {
                final String roomCode = textController.text.toUpperCase();
                final success = await Get.find<GameController>().joinGame(roomCode);
                if (success) {
                  showErrorMessage = false;
                  Get.to(() => const WaitingRoomScreen(), transition: Transition.fadeIn);
                } else {
                  setState(() {
                    showErrorMessage = true;
                  });
                  debugPrint('Failed to join room');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoomCodeTextField extends StatefulWidget {
  final TextEditingController textController;
  const RoomCodeTextField({Key? key, required this.textController}) : super(key: key);

  @override
  _RoomCodeTextFieldState createState() => _RoomCodeTextFieldState();
}

class _RoomCodeTextFieldState extends State<RoomCodeTextField> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    const OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.5,
      ),
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: AppConstants.bigButtonWidth(media: mediaQuery),
      ),
      child: TextField(
        controller: widget.textController,
        style: AppConstants.roomCodeTextFieldStyle(media: mediaQuery),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          fillColor: appColors.backgroundCloudWhite,
          filled: true,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
        autocorrect: false,
        textCapitalization: TextCapitalization.characters,
      ),
    );
  }
}
