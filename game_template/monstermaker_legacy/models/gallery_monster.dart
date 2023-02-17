import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monstermaker/models/monster_drawing.dart';

class GalleryMonster {
  final MonsterDrawing monster;
  final String name;
  final int likes;
  final Timestamp uploadDate;
  final String id;
  final bool likedByUser;

  GalleryMonster({
    required this.id,
    required this.monster,
    required this.name,
    required this.likes,
    required this.uploadDate,
    required this.likedByUser,
  });
}
