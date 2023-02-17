// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:monstermaker/app_constants.dart';
// import 'package:monstermaker/controllers/game_controller.dart';
// import 'package:monstermaker/database/database_service.dart';
// import 'package:monstermaker/models/drawing.dart';
// import 'package:monstermaker/models/monster_drawing.dart';
// import 'package:tuple/tuple.dart';
//
// class GameRoom {
//   GameRoom({
//     required this.roomCode,
//     required this.numberOfPlayersGameMode,
//     required this.drawingTime,
//     required this.createdAt,
//     required this.activePlayers,
//     required this.startedGame,
//     required this.isHost,
//     required this.playerIndex,
//     required this.startAnimation,
//     required this.animateAllAtOnce,
//     required this.monsterIndex,
//     required this.topDrawings,
//     required this.midDrawings,
//     required this.bottomDrawings,
//     required this.monsterSharingAgreements,
//     required this.monsterDrawings,
//   }); //: //assert(monsterIndex == 1 || monsterIndex == 2 || monsterIndex == 3),
//   //assert(monsterSharingAgreements.length == GameState.numberOfPlayersGameMode),
//   //assert(monsterDrawings.length == 3);
//
//   /// The room code of the room
//   final String roomCode;
//
//   /// How may players this game room is for
//   final NumberOfPlayers numberOfPlayersGameMode;
//
//   /// How much time players have to draw each part
//   final DrawingTimerMinutes drawingTime;
//
//   /// When the room was created, can be null (for rooms created before creation timestamps were recorded)
//   final DateTime? createdAt;
//
//   /// How many players are currently in the room
//   final int activePlayers;
//
//   /// Weather the current player is the host of this room or not
//   final bool isHost;
//
//   /// Weather the game has begun or is still waiting for host to start
//   final bool startedGame;
//
//   /// The player number the current player has, where 1 means first player, 2 means second player etc
//   final int playerIndex;
//
//   /// Weather to start the animation of the monster on the finished screen. Controlled by the room host.
//   final bool startAnimation;
//
//   /// Weather to animate all three drawings at once, or one at a time (top to bottom).
//   final bool animateAllAtOnce;
//
//   /// What monster to show on the finished screen. Controlled by the room host.
//   final int monsterIndex;
//
//   /// Maps of the drawings done so far. The player number is the key, the string is the drawing in json.
//   final Map<int, String> topDrawings;
//   final Map<int, String> midDrawings;
//   final Map<int, String> bottomDrawings;
//
//   /// List of maps of what users have agreed (or not) to share what monster drawings to the monster gallery.
//   /// The map at index 0 is monster 1, index 1 is monster 2, etc.
//   /// The map for each monster looks like this (example): {Player1 : true, Player 2 : false}, note that Player 3 isn't in the map, since
//   /// player 3 hasn't responded yet.
//   final List<Map<String, dynamic>> monsterSharingAgreements;
//
//   /// A list of [MonsterDrawing] representation of all drawings, index 0 is monster 1, index 1 is monster 2 etc.
//   final List<MonsterDrawing> monsterDrawings;
//
//   /// A [MonsterDrawing] representation of the current monster according to [monsterIndex].
//   MonsterDrawing currentMonsterDrawing() {
//     if (monsterDrawings.length < monsterIndex - 1) {
//       assert(false, 'monsterDrawings is of wrong length!');
//     }
//
//     return monsterDrawings[monsterIndex - 1];
//   }
//
//   bool allTopDrawingsDone() => topDrawings.length == 3;
//   bool allMidDrawingsDone() => midDrawings.length == 3;
//   bool allBottomDrawingsDone() => bottomDrawings.length == 3;
//
//   bool myTopDrawingDone() => topDrawings[playerIndex] != null;
//   bool myMidDrawingDone() => midDrawings[playerIndex] != null;
//   bool myBottomDrawingDone() => bottomDrawings[playerIndex] != null;
//
//   /// Returns true if the current player has already submitted a drawing in the current phase (top, mid, bottom).
//   /// [phase] is expected to be 0, 1 or 2 to represent top, mid, bottom respectively.
//   bool haveAlreadySubmittedDrawing() {
//     if (!allTopDrawingsDone() && !myTopDrawingDone()) {
//       return false;
//     } else if (allTopDrawingsDone() && !allMidDrawingsDone() && !myMidDrawingDone()) {
//       return false;
//     }
//     if (allTopDrawingsDone() && allMidDrawingsDone() && !allBottomDrawingsDone() && !myBottomDrawingDone()) {
//       return false;
//     }
//
//     return true;
//   }
//
//   Drawing? getDrawingToContinueFrom() {
//     debugPrint('Running getDrawingToContinueFrom in GameRoom in models.dart');
//     //assert(allTopDrawingsDone(), 'All top drawings need to be done before this is accessed.');
//
//     if (allTopDrawingsDone() && !allMidDrawingsDone()) {
//       final topDrawingJson = topDrawings[_drawingIndex(playerIndex)];
//       if (topDrawingJson == null) {
//         return null;
//       }
//       return Drawing.fromJson(jsonDecode(topDrawingJson));
//     } else if (allTopDrawingsDone() && allMidDrawingsDone()) {
//       final midDrawingJson = midDrawings[_drawingIndex(playerIndex)];
//       if (midDrawingJson == null) {
//         return null;
//       }
//       return Drawing.fromJson(jsonDecode(midDrawingJson));
//     } else {
//       return null;
//     }
//   }
//
//   /// Returns null if there's no prompt to show, otherwise returns an int with the index (int) and name (String) of the monster
//   /// that the users needs to agree or not agree to share.
//   Tuple2<int, String>? showAgreeToShareMonsterPrompt() {
//     for (int i = 1; i < 4; i++) {
//       final monster = monsterSharingAgreements[i - 1];
//       if (monster.isEmpty ||
//           (monster.containsKey('Player$playerIndex') &&
//               (monster['Player$playerIndex'] == true || monster['Player$playerIndex'] == false))) {
//         /// If there is no response from the player at all, or the response has been invalidated (set to null by host)
//       } else if (monster.containsKey(monsterNameKeyString)) {
//         return Tuple2(i, monster[monsterNameKeyString]);
//       }
//     }
//     return null;
//   }
//
//   ///How many players have not yet responded to if they agree or not to share the monster to the monster gallery.
//   int nrOfPlayersNotAnsweredToShareMonster(int monsterIndex) {
//     assert(monsterIndex > 0 && monsterIndex < AppConstants.getRealNumberOfPlayers(numberOfPlayersGameMode) + 1,
//         'waitingForUsersToAgreeToShareMonster in GameRoom: monsterIndex invalid');
//
//     int numberOfPlayersWeAreWaitingFor = AppConstants.getRealNumberOfPlayers(numberOfPlayersGameMode);
//
//     for (int i = 1; i < AppConstants.getRealNumberOfPlayers(numberOfPlayersGameMode) + 1; i++) {
//       final monsterData = monsterSharingAgreements[monsterIndex - 1];
//
//       if (monsterData.containsKey('Player$i')) {
//         if (monsterData['Player$i'] != null) {
//           numberOfPlayersWeAreWaitingFor--;
//         }
//       }
//     }
//
//     return numberOfPlayersWeAreWaitingFor;
//   }
//
//   /// Returns true if all players have agreed to share the drawing to the monster gallery, false if not.
//   bool isSubmittedToMonsterGallery(int monsterIndex) {
//     assert(monsterIndex > 0 && monsterIndex < AppConstants.getRealNumberOfPlayers(numberOfPlayersGameMode) + 1,
//         'isSubmittedToMonsterGallery in GameRoom: monsterIndex invalid');
//
//     bool result = true;
//
//     for (int i = 1; i < AppConstants.getRealNumberOfPlayers(numberOfPlayersGameMode) + 1; i++) {
//       if (monsterSharingAgreements[monsterIndex - 1].containsKey("Player$i")) {
//         if (monsterSharingAgreements[monsterIndex - 1]["Player$i"] != true) {
//           /// One or more players have responded that they don't want to share it.
//           result = false;
//         }
//       } else {
//         /// Not all players have responded yet
//         result = false;
//       }
//     }
//
//     return result;
//   }
//
//   /// If the monster with [monsterIndex] is submitted to the monster gallery, this function returns the name of that monster.
//   /// If the monster isn't submitted, this returns null.
//   String? nameOfSubmittedMonster(int monsterIndex) {
//     assert(monsterIndex > 0 && monsterIndex < AppConstants.getRealNumberOfPlayers(numberOfPlayersGameMode) + 1,
//         'isSubmittedToMonsterGallery in GameRoom: monsterIndex invalid');
//
//     if (isSubmittedToMonsterGallery(monsterIndex) &&
//         monsterSharingAgreements[monsterIndex - 1].containsKey('MonsterName')) {
//       return monsterSharingAgreements[monsterIndex - 1]['MonsterName'];
//     }
//
//     return null;
//   }
//
//   @override
//   String toString() {
//     return 'Room Code: $roomCode, active players: $activePlayers, game has started: $startedGame, current player is host: $isHost, player: $playerIndex, startAnimation: $startAnimation, animateAllAtOnce: $animateAllAtOnce, monsterIndex: $monsterIndex';
//   }
// }
//
// int? _drawingIndex(int playerIndex) {
//   assert(playerIndex >= 1 && playerIndex <= 3);
//   int? index;
//
//   switch (playerIndex) {
//     case 1:
//       index = 3;
//       break;
//     case 2:
//       index = 1;
//       break;
//     case 3:
//       index = 2;
//       break;
//     default:
//       assert(false, 'player was not 1, 2 or 3...');
//   }
//
//   assert(index != null, 'index is null');
//   return index;
// }
