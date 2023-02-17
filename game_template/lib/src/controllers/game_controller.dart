// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:monstermaker/database/database_service.dart';
// import 'package:monstermaker/models/gallery_monster.dart';
// import 'package:monstermaker/models/game_room.dart';
//
// class GameController extends GetxController {
//   final _dataBaseService = DatabaseService();
//
//   static GameController get to => Get.find();
//
//   bool _loadingHandIn = false;
//   bool get loadingHandIn => _loadingHandIn;
//   set loadingHandIn(bool value) {
//     _loadingHandIn = value;
//     update();
//   }
//
//   StreamSubscription<GameRoom?>? gameRoomSubscription;
//   GameRoom? currentGameRoom;
//
//   void _startGameRoomSubscription({required String roomCode}) {
//     _dataBaseService.streamGameRoom(roomCode).listen((room) {
//       debugPrint('GameController: New room in game room subscription: $roomCode');
//       currentGameRoom = room;
//       update();
//     });
//   }
//
//   /// - MARK: Model access
//
//   Rx<bool> isLoggedIn() => _dataBaseService.isLoggedIn;
//
//   //int numberOfPlayersGameMode() => currentGameRoom.numberOfPlayersGameMode;
//
//   /// - MARK: User Intents
//
//   /// Create a new game
//   /// Returns true if successful.
//   Future<bool> createGameRoom(GameSettings settings) async {
//     final roomCode = await _dataBaseService.createNewRoom(settings);
//     if (roomCode != null) {
//       _startGameRoomSubscription(roomCode: roomCode);
//       return true;
//     }
//     return false;
//   }
//
//   /// Joins game with [roomCode]
//   /// Returns true if successful.
//   Future<bool> joinGame(String roomCode) async {
//     final result = await _dataBaseService.joinRoom(roomCode);
//     if (result) {
//       _startGameRoomSubscription(roomCode: roomCode);
//     }
//     return result;
//   }
//
//   /// Starts the game room.
//   /// Returns true if successful.
//   Future<bool> startGame() async {
//     debugPrint("GameController - start game");
//     if (currentGameRoom != null && currentGameRoom!.isHost) {
//       return _dataBaseService.startGame(room: currentGameRoom!);
//     } else {
//       return false;
//     }
//   }
//
//   /// Leaves the game room
//   /// Returns true if successful.
//   Future<bool> leaveGame() async {
//     if (currentGameRoom != null) {
//       gameRoomSubscription?.cancel();
//       return _dataBaseService.leaveRoom(room: currentGameRoom!);
//     } else {
//       return false;
//     }
//   }
//
//   /// Updates the draw time settings for the current room
//   Future<void> changeDrawingTime(DrawingTimerMinutes drawTime) async {
//     if (currentGameRoom != null && currentGameRoom!.isHost) {
//       _dataBaseService.changeDrawTime(room: currentGameRoom!, drawTime: drawTime);
//     }
//   }
//
//   /// Returns a monster gallery stream.
//   Stream<List<GalleryMonster>>? streamMonsterGallery() {
//     return _dataBaseService.streamMonsterGallery();
//   }
//
//   /// Like/unlike the given gallery monster
//   Future<void> likeUnlikeMonster(GalleryMonster monster, {required bool like}) async {
//     await _dataBaseService.likeUnlikeGalleryMonster(monster, like: like);
//   }
// }
//
// enum NumberOfPlayers { two, three, four, five }
//
// enum DrawingTimerMinutes { one, three, five, noLimit }
//
// class GameSettings {
//   NumberOfPlayers numberOfPlayers = NumberOfPlayers.three;
//   DrawingTimerMinutes drawingTimerMinutes = DrawingTimerMinutes.five;
// }
//
// /*class OtherPlayerDrawing {
//   DrawingStorage drawing;
// }*/
//
// /*
// class DrawingControlsState extends GetxController {
//   /// Whether to show or hide the drawing controls
//   bool _showButtons = true;
//   bool get showButtons => _showButtons;
//   set showButtons(bool value) {
//     _showButtons = value;
//     if (!_showButtons) {
//       _showBrushSettings = false;
//     }
//     update();
//   }
//
//   /// Whether to show or hide the brush controls (color + size)
//   bool _showBrushSettings = false;
//   bool get showBrushSettings => _showBrushSettings;
//   set showBrushSettings(bool value) {
//     _showBrushSettings = value;
//     update();
//   }
// } */
