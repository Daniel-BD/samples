import 'package:flutter/material.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/game_controller.dart';

class ActivePlayers extends StatelessWidget {
  ActivePlayers({Key? key, required this.activePlayers, required this.numberOfPlayers})
      : assert(activePlayers > 0 && activePlayers <= AppConstants.getRealNumberOfPlayers(numberOfPlayers)),
        super(key: key);

  final int activePlayers;
  final NumberOfPlayers numberOfPlayers;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConstants.largeWidthBreakPoint + AppConstants.horizontalEdgePadding,
      ),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallHorizontalSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < AppConstants.getRealNumberOfPlayers(numberOfPlayers); i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallHorizontalSpacing),
                  child: PlayerIcon(playerNumber: i + 1, isActive: activePlayers > i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerIcon extends StatelessWidget {
  final int playerNumber;
  final bool isActive;
  const PlayerIcon({
    Key? key,
    required this.playerNumber,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SizedBox(
      height: mediaQuery.size.width > AppConstants.largeWidthBreakPoint ? 100 : 70,
      child: Stack(
        children: [
          Visibility(
            visible: isActive,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            maintainInteractivity: false,
            child: Image.asset('assets/images/Player icon $playerNumber.png'),
          ),
          Visibility(
            visible: !isActive,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            maintainInteractivity: false,
            child: Image.asset('assets/images/Player icon empty.png'),
          ),
        ],
      ),
    );
  }
}
