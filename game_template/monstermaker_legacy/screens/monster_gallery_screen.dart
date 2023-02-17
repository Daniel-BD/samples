import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/monster_gallery_controller.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/widgets/monster_gallery_carousel.dart';

class MonsterGalleryScreen extends StatefulWidget {
  const MonsterGalleryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MonsterGalleryScreenState createState() => _MonsterGalleryScreenState();
}

class _MonsterGalleryScreenState extends State<MonsterGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double signWidth = AppConstants.signWidth(media: mediaQuery, isSmall: true);

    return CloudsBackgroundScreen(
      cloudPosition: CloudPosition.top,
      topLeftButton: TopLeftButtonType.backButton,
      placeChildInClouds: true,
      firstChild: GetBuilder<MonsterGalleryController>(builder: (monsterGalleryController) {
        if (monsterGalleryController.galleryMonsters == null) {
          return const CircularProgressIndicator.adaptive();
        } else {
          return SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: signWidth,
                  child: Image.asset('assets/images/Type=New monsters.png'),
                ),
                const SizedBox(height: AppConstants.smallVerticalSpacing),
                const Expanded(
                  child: MonsterGalleryCarousel(
                    info: GalleryMonsterInfo.onlyLikes,
                    galleryType: MonsterGalleryType.newMonsters,
                  ),
                ),
                const SizedBox(height: AppConstants.smallVerticalSpacing),
                SizedBox(
                  width: signWidth,
                  child: Image.asset('assets/images/Type=Most popular.png'),
                ),
                const SizedBox(height: AppConstants.smallVerticalSpacing),
                const Expanded(
                  child: MonsterGalleryCarousel(
                    info: GalleryMonsterInfo.onlyLikes,
                    galleryType: MonsterGalleryType.mostPopular,
                  ),
                ),
                const SizedBox(height: AppConstants.smallVerticalSpacing),
              ],
            ),
          );
        }
      }),
    );
  }
}
