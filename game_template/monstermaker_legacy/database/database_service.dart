import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/models/gallery_monster.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:monstermaker/models/drawing.dart';
import 'package:monstermaker/models/game_room.dart';
import 'package:monstermaker/models/monster_drawing.dart';

class DatabaseService {
  var isLoggedIn = false.obs;

  DatabaseService() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('DatabaseService: User is currently signed out!');
        isLoggedIn.value = false;
      } else {
        debugPrint('DatabaseService: User is signed in!');
        isLoggedIn.value = true;
      }
    });

    await FirebaseAuth.instance.signInAnonymously();
  }

  /// Joins a [GameRoom] with the given [roomCode].
  /// Returns true if successful.
  Future<bool> joinRoom(String roomCode) async {
    if (!isLoggedIn.value || roomCode.length != 4) {
      return false;
    }

    roomCode = roomCode.toUpperCase();

    bool result = false;

    final _db = FirebaseFirestore.instance;
    final _userUID = FirebaseAuth.instance.currentUser!.uid;

    var roomData = await _db.collection(_home).doc(_roomsDoc).collection(roomCode).get();

    var numberOfPlayersGameMode = 0;
    for (var doc in roomData.docs) {
      if (doc.id == _gameData) {
        var gameData = doc.data();
        numberOfPlayersGameMode = gameData[_numberOfPlayersGameMode] + 2;
      }
    }

    if (roomData.docs.length < 2) {
      debugPrint('No room with that code!');
    } else if (roomData.docs.length > numberOfPlayersGameMode) {
      debugPrint('The room is full!');
    } else {
      _db
          .collection(_home)
          .doc(_roomsDoc)
          .collection(roomCode)
          .doc(_userUID)
          .set({_active: true, _isHost: false, _player: roomData.docs.length});
      result = true;
    }

    return result;
  }

  /// Creates a new room to play in.
  /// Returns a String with the room code if successful.
  Future<String?> createNewRoom(GameSettings settings) async {
    if (!isLoggedIn.value) {
      return null;
    }
    final _db = FirebaseFirestore.instance;
    final _userUID = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot? roomSnapshot;

    Future<String?> generateRoomCode({required int attempt}) async {
      if (attempt > 4) {
        ///Too many failed attempts. Cancel everything.
        assert(false, 'Database Service: something went wrong when creating new room. Code: aaaa');
        return null;
      }
      String roomCode = randomAlpha(4).toUpperCase();
      roomSnapshot = await _db.collection(_home).doc(_roomsDoc).collection(roomCode).get();
      if (roomSnapshot == null || roomSnapshot!.docs.isNotEmpty) {
        assert(false, 'Database Service: something went wrong when creating new room. Code: aaab');
        return generateRoomCode(attempt: attempt + 1);
      }
      return roomCode;
    }

    String? roomCode = await generateRoomCode(attempt: 0);
    if (roomCode == null) {
      return null;
    }

    // ignore: prefer_is_empty
    assert(roomSnapshot?.docs.length == 0, 'RoomCode already exists even though we just checked if it already exists!');
    if (roomSnapshot!.docs.isEmpty) {
      await _db
          .collection(_home)
          .doc(_roomsDoc)
          .collection(roomCode)
          .doc(_userUID)
          .set({_active: true, _isHost: true, _player: 1}).catchError((Object error) {
        roomCode = null;
        assert(false, 'failed to create new room');
      }).whenComplete(() async {
        await _db.collection(_home).doc(_roomsDoc).collection(roomCode!).doc(_gameData).set({
          _startedGame: false,
          _createdAt: DateTime.now(),
          _numberOfPlayersGameMode: settings.numberOfPlayers.index,
          _drawingTimeGameMode: settings.drawingTimerMinutes.index,
        }).catchError((Object error) {
          roomCode = null;
          assert(false, 'failed to create new room');
        }).whenComplete(() {
          return roomCode;
        });
      });
    }

    return roomCode;
  }

  /// The main method of fetching game rooms in the app
  Stream<GameRoom?> streamGameRoom(String roomCode, {isSpectator = false}) {
    roomCode = roomCode.toUpperCase();
    final _db = FirebaseFirestore.instance;
    final _userUID = FirebaseAuth.instance.currentUser!.uid;

    return _db.collection(_home).doc(_roomsDoc).collection(roomCode).snapshots().map((room) {
      if (!isLoggedIn.value || roomCode.isEmpty) {
        return null;
      }

      bool? startedGame;
      bool? isHost;
      NumberOfPlayers? numberOfPlayersGameMode;
      DrawingTimerMinutes? drawingTimeGameMode;
      int? playerIndex;
      bool? startAnimation;
      int? monsterIndex;
      bool? animateAllAtOnce;
      DateTime? createdAt;

      Map<int, String> topDrawings = {};
      Map<int, String> midDrawings = {};
      Map<int, String> bottomDrawings = {};

      final List<Map<String, dynamic>> monsterSharingAgreements = [{}, {}, {}];

      for (var doc in room.docs) {
        if (doc.id == _userUID) {
          isHost = doc.get(_isHost);
          playerIndex = doc.get(_player);
        } else if (doc.id == _gameData) {
          var gameData = doc.data();

          numberOfPlayersGameMode = NumberOfPlayers.values[gameData[_numberOfPlayersGameMode]];
          drawingTimeGameMode = DrawingTimerMinutes.values[gameData[_drawingTimeGameMode]];
          startedGame = gameData[_startedGame];
          startAnimation = gameData[_startAnimation];
          monsterIndex = gameData[_monsterIndex];
          animateAllAtOnce = gameData[_animateAllAtOnce];

          final Timestamp? roomTimeStamp = gameData[_createdAt];
          if (roomTimeStamp != null && roomTimeStamp.runtimeType == Timestamp) {
            createdAt = roomTimeStamp.toDate();
          }

          if (gameData[_top] != null) {
            topDrawings = Map<String, String>.from(gameData[_top])
                .map((key, value) => MapEntry<int, String>(int.parse(key), value));
          }
          if (gameData[_mid] != null) {
            midDrawings = Map<String, String>.from(gameData[_mid])
                .map((key, value) => MapEntry<int, String>(int.parse(key), value));
          }
          if (gameData[_bottom] != null) {
            bottomDrawings = Map<String, String>.from(gameData[_bottom])
                .map((key, value) => MapEntry<int, String>(int.parse(key), value));
          }

          /// Getting the status of what players have or have not agreed to share what monsters to the monster gallery.
          if (gameData[_agreeToShare] != null) {
            try {
              for (int i = 1; i < 4; i++) {
                if (gameData[_agreeToShare]['Monster$i'] != null) {
                  monsterSharingAgreements[i - 1] = Map<String, dynamic>.from(gameData[_agreeToShare]['Monster$i'])
                      .map((key, value) => MapEntry<String, dynamic>(key, value));
                }
              }
            } catch (e) {
              debugPrint('streamGameRoom: ' + e.toString());
            }
          }
        }
      }

      assert(startedGame != null, 'startedGame is null');

      if ((isHost == null || playerIndex == null) && !isSpectator) {
        /// The client trying to access the room shouldn't get access!
        return null;
      } else if ((isHost == null || playerIndex == null) && isSpectator) {
        /// Todo: this may not be the best way, giving spectator host capabilities, depending on how i use it
        isHost = true;
        playerIndex = 1;
      }

      List<MonsterDrawing> monsterDrawings = [];

      for (int i = 1; i < 4; i++) {
        int topIndex = i;
        int midIndex = i == 1
            ? 2
            : i == 2
                ? 3
                : 1;
        int bottomIndex = i == 1
            ? 3
            : i == 2
                ? 1
                : 2;

        final topDrawingJson = topDrawings[topIndex];
        final midDrawingJson = midDrawings[midIndex];
        final bottomDrawingJson = bottomDrawings[bottomIndex];

        if (topDrawingJson != null && midDrawingJson != null && bottomDrawingJson != null) {
          Drawing top = Drawing.fromJson(jsonDecode(topDrawingJson));
          Drawing mid = Drawing.fromJson(jsonDecode(midDrawingJson));
          Drawing bottom = Drawing.fromJson(jsonDecode(bottomDrawingJson));

          monsterDrawings
              .add(MonsterDrawing(top, mid, bottom)); //TODO: Kolla om detta funkar som det ska. Jämför med gammal kod.
        }
      }

      if (startedGame != null &&
          isHost != null &&
          playerIndex != null &&
          numberOfPlayersGameMode != null &&
          drawingTimeGameMode != null) {
        var gameRoom = GameRoom(
          roomCode: roomCode,
          numberOfPlayersGameMode: numberOfPlayersGameMode,
          drawingTime: drawingTimeGameMode,
          createdAt: createdAt,
          activePlayers: room.docs.length - 1,
          startedGame: startedGame,
          isHost: isHost,
          playerIndex: playerIndex,
          startAnimation: startAnimation ?? false,
          monsterIndex: monsterIndex ?? 1,
          animateAllAtOnce: animateAllAtOnce ?? false,
          topDrawings: topDrawings,
          midDrawings: midDrawings,
          bottomDrawings: bottomDrawings,
          monsterDrawings: monsterDrawings,
          monsterSharingAgreements: monsterSharingAgreements,
        );
        return gameRoom;
      } else {
        return null;
      }
    });
  }

  /// Starts the game room.
  /// Returns true if successful.
  Future<bool> startGame({required GameRoom room}) async {
    if (!isLoggedIn.value || !room.isHost) {
      return false;
    }
    final _db = FirebaseFirestore.instance;
    bool result = false;

    await _db.collection(_home).doc(_roomsDoc).collection(room.roomCode).doc(_gameData).set({
      _startedGame: true,
      _startAnimation: false,
      _monsterIndex: 1,
      _animateAllAtOnce: false,
    }, SetOptions(merge: true)).catchError((Object error) {
      assert(false, 'ERROR starting game, $error');
    }).whenComplete(() {
      result = true;
    });

    return result;
  }

  /// Leaves the [GameRoom].
  /// Returns true if successful.
  Future<bool> leaveRoom({required GameRoom room}) async {
    if (!isLoggedIn.value) {
      return false;
    }
    final _db = FirebaseFirestore.instance;
    final _userUID = FirebaseAuth.instance.currentUser!.uid;
    bool result = false;

    await _db
        .collection(_home)
        .doc(_roomsDoc)
        .collection(room.roomCode)
        .doc(_userUID)
        .delete()
        .catchError((Object error) {
      debugPrint('ERROR leaving room, $error');
    }).whenComplete(() async {
      result = true;
    });

    return result;
  }

  /// Changes the draw time setting
  Future<void> changeDrawTime({required GameRoom room, required DrawingTimerMinutes drawTime}) async {
    if (!isLoggedIn.value || !room.isHost) {
      return;
    }
    final _db = FirebaseFirestore.instance;

    await _db.collection(_home).doc(_roomsDoc).collection(room.roomCode).doc(_gameData).set({
      _drawingTimeGameMode: drawTime.index,
    }, SetOptions(merge: true)).catchError((Object error) {
      assert(false, 'ERROR changing draw time, $error');
    });
  }

  Stream<List<GalleryMonster>>? streamMonsterGallery() {
    if (!isLoggedIn.value) {
      return null;
    }

    final _db = FirebaseFirestore.instance;
    final _userUID = FirebaseAuth.instance.currentUser!.uid;

    return _db.collection(_monsterGallery).snapshots().map((galleryMonsters) {
      final List<GalleryMonster> monsters = [];

      for (var monster in galleryMonsters.docs) {
        final monsterData = monster.data();
        String id = monster.id;
        Map<String, bool>? likeMap;

        if (monsterData[_likedBy] != null) {
          likeMap =
              Map<String, bool>.from(monsterData[_likedBy]).map((key, value) => MapEntry<String, bool>(key, value));
        }

        int likes = likeMap?.values.where((like) => like == true).length ?? 0;
        bool likedByUser = likeMap?[_userUID] ?? false;
        String top = monsterData[_top];
        String middle = monsterData[_mid];
        String bottom = monsterData[_bottom];
        String name = monsterData['monsterName'];
        Timestamp uploadDate = monsterData['acceptedAt'];

        monsters.add(
          GalleryMonster(
            id: id,
            monster: MonsterDrawing(
              Drawing.fromJson(jsonDecode(top)),
              Drawing.fromJson(jsonDecode(middle)),
              Drawing.fromJson(jsonDecode(bottom)),
            ),
            name: name,
            likes: likes,
            uploadDate: uploadDate,
            likedByUser: likedByUser,
          ),
        );
      }
      return monsters;
    });
  }

  /// Leaves a like (or removes it) on the given [monster] from the current user.
  Future<void> likeUnlikeGalleryMonster(GalleryMonster monster, {required bool like}) async {
    debugPrint('try to like monster: ${monster.id}, like: $like');
    if (!isLoggedIn.value) {
      return;
    }
    final _db = FirebaseFirestore.instance;
    final _userUID = FirebaseAuth.instance.currentUser!.uid;

    await _db.collection(_monsterGallery).doc(monster.id).set({
      _likedBy: {_userUID: like},
    }, SetOptions(merge: true)).catchError((Object error) {
      assert(false, 'ERROR liking gallery monster, $error');
    });
  }
}

const String _home = 'home';
const String _roomsDoc = 'rooms';
const String _active = 'active';
const String _gameData = 'gameData';
const String _isHost = 'isHost';
const String _numberOfPlayersGameMode = 'numberOfPlayersGameMode';
const String _drawingTimeGameMode = 'drawingTimeGameMode';
const String _startedGame = 'startedGame';
const String _player = 'player';
const String _top = 'top';
const String _mid = 'middle';
const String _bottom = 'bottom';
const String _startAnimation = 'startAnimation';
const String _monsterIndex = 'monsterIndex';
const String _animateAllAtOnce = 'animateAllAtOnce';
const String _agreeToShare = 'agreeToShare';
const String _createdAt = 'createdAt';
const String _monsterGallery = 'monsterGallery';
const String _likedBy = 'likedBy';
const String monsterNameKeyString = 'MonsterName';
