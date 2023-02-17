import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/monster_gallery_controller.dart';
import 'package:monstermaker/models/gallery_monster.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/widgets/monster_gallery_carousel.dart';

class CloseUpFramedMonsterScreen extends StatefulWidget {
  const CloseUpFramedMonsterScreen({
    Key? key,
    required this.monster,
    required this.monsterIndex,
    required this.galleryType,
  })  : assert(galleryType == MonsterGalleryType.newMonsters || galleryType == MonsterGalleryType.mostPopular,
            "CloseUpFramedMonsterScreen gallery type invalid: $galleryType"),
        super(key: key);

  final MonsterGalleryType galleryType;
  final GalleryMonster monster;
  final int monsterIndex;

  @override
  _CloseUpFramedMonsterScreenState createState() => _CloseUpFramedMonsterScreenState();
}

class _CloseUpFramedMonsterScreenState extends State<CloseUpFramedMonsterScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double signWidth = min(mediaQuery.size.width * 0.5, 280.0);

    return GetBuilder<MonsterGalleryController>(builder: (monsterGalleryController) {
      return CloudsBackgroundScreen(
        cloudPosition: CloudPosition.top,
        placeChildInClouds: true,
        topLeftButton: TopLeftButtonType.backButton,
        firstChild: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: signWidth,
                child: Image.asset('assets/images/Type=' +
                    (widget.galleryType == MonsterGalleryType.newMonsters ? 'New monsters.png' : 'Most popular.png')),
              ),
              Flexible(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppConstants.mediumVerticalSpacing),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: mediaQuery.size.width * (400 / 375) +
                            AppConstants.galleryMonsterInfoAndControlsHeight(mediaQuery),
                      ),
                      child: MonsterGalleryCarousel(
                        info: GalleryMonsterInfo.likesAndDate,
                        hasControls: true,
                        autoPlay: false,
                        clickableMonsters: false,
                        galleryType: MonsterGalleryType.closeUp,
                        initialPage: widget.monsterIndex,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
