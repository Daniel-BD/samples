// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:monstermaker/controllers/game_controller.dart';
// import 'package:monstermaker/models/gallery_monster.dart';
//
// class MonsterGalleryController extends GetxController {
//   static MonsterGalleryController get to => Get.find();
//
//   StreamSubscription<List<GalleryMonster>?>? monsterGallerySubscription;
//   List<GalleryMonster>? galleryMonsters;
//
//   @override
//   void onInit() {
//     super.onInit();
//     if (!Get.find<GameController>().isLoggedIn().value) {
//       ever(Get.find<GameController>().isLoggedIn(), (_) {
//         if (Get.find<GameController>().isLoggedIn().value) {
//           _startMonsterGallerySubscription();
//         }
//       });
//     } else {
//       _startMonsterGallerySubscription();
//     }
//   }
//
//   @override
//   void onClose() {
//     _stopMonsterGallerySubscription();
//     super.onClose();
//   }
//
//   void _startMonsterGallerySubscription() {
//     final monsterGalleryStream = Get.find<GameController>().streamMonsterGallery();
//     assert(monsterGalleryStream != null, 'Monster gallery stream is null. In MonsterGalleryController');
//     if (monsterGalleryStream == null) {
//       return;
//       //TODO: retry?
//     }
//     monsterGalleryStream.listen((monsters) {
//       galleryMonsters = monsters;
//       update();
//     });
//   }
//
//   void _stopMonsterGallerySubscription() {
//     monsterGallerySubscription?.cancel();
//   }
//
//   /// - MARK: User Intents
//   Future<void> likeUnlikeMonster(GalleryMonster monster, {required bool like}) async {
//     Get.find<GameController>().likeUnlikeMonster(monster, like: like);
//   }
// }
