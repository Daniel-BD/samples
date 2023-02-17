import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/models/gallery_monster.dart';
import 'package:game_template/src/ui_components/ui_constants.dart';

import '../models/drawing.dart';
import '../models/monster_drawing.dart';
import '../theme/text_styles.dart';
import 'buttons.dart';
import 'framed_gallery_monster_widget.dart';

enum MonsterGalleryType { newMonsters, mostPopular, closeUp }

enum GalleryMonsterInfo { onlyLikes, likesAndDate, none }

class MonsterGalleryCarousel extends StatefulWidget {
  const MonsterGalleryCarousel({
    super.key,
    required this.galleryType,
    this.enlargeCenterPage = false,
    this.autoPlay = true,
    this.initialPage = 0,
    this.clickableMonsters = true,
    this.hasControls = false,
    this.info = GalleryMonsterInfo.none,
  });

  final MonsterGalleryType galleryType;
  final bool hasControls;
  final GalleryMonsterInfo info;

  ///If true, monsters can be tapped to navigate to a close-up screen of that monster.
  final bool clickableMonsters;
  final bool enlargeCenterPage;
  final bool autoPlay;
  final int initialPage;

  @override
  State<MonsterGalleryCarousel> createState() => _MonsterGalleryCarouselState();
}

class _MonsterGalleryCarouselState extends State<MonsterGalleryCarousel> {
  final GlobalKey _carouselKey = GlobalKey();
  double? _fraction;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateViewportFraction(mediaQuery);
    });

    return CarouselSlider.builder(
      key: _carouselKey,
      itemCount: 3,
      itemBuilder: (context, itemIndex, pageViewIndex) {
        final drawing = Drawing(Size.square(40));
        final monster = GalleryMonster(
            id: 'id',
            monster: MonsterDrawing(
              drawing,
              drawing,
              drawing,
            ),
            name: 'name',
            likes: 3,
            uploadDate: Timestamp.fromDate(DateTime(2021, 1, 1)),
            likedByUser: false);

        if (_fraction == null) {
          return Container();
        } else {
          if (widget.clickableMonsters) {
            return Column(
              children: [
                Expanded(
                  child: FramedMonsterButton(
                    onPressed: () async {
                      //TODO: Go to CloseUpFramedMonsterScreen
                      // This solves the issue where the carousel has the wrong viewPortFraction until
                      // it rebuilds if the screen orientation has changed since last on this screen
                      //Future.microtask(() => setState(() {}));
                    },
                    framedMonster: FramedGalleryMonsterWidget(
                      galleryMonster: monster,
                    ),
                  ),
                ),
                if (widget.info != GalleryMonsterInfo.none)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: AppConstants.tinyVerticalSpacing),
                    child: LikesAndUploadDate(
                      infoToShow: widget.info,
                      monster: monster,
                    ),
                  ),
              ],
            );
          } else {
            //Get.put(AnimatedMonsterController(), tag: monster.id);

            return Column(
              children: [
                // Expanded(
                //   child: FramedGalleryMonsterWidget(
                //     galleryMonster: monster,
                //     canAnimate: true,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: AppConstants.tinyVerticalSpacing),
                  child: LikesAndUploadDate(
                    infoToShow: widget.info,
                    monster: monster,
                  ),
                ),
                if (widget.hasControls)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.mediumVerticalSpacing),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GameButton(
                          //forceSmallestSize: mediaQuery.size.width > mediaQuery.size.height,
                          buttonType: ButtonType.small,
                          assetPath:
                              'assets/images/Type=PlayIcon, Pressed=false.png',
                          onPressed: () {
                            //final AnimatedMonsterController controller = Get.find(tag: monster.id);
                            //controller.startAnimation();
                            //framedGalleryMonsterController.startAnimation();
                          },
                        ),
                        SizedBox(
                          width: mediaQuery.size.width > mediaQuery.size.height
                              ? AppConstants.largeHorizontalSpacing
                              : AppConstants.largeAdaptiveHorizontalSpacing(
                                  media: mediaQuery),
                        ),
                        HeartGameButton(
                          //forceSmallestSize: mediaQuery.size.width > mediaQuery.size.height,
                          filled: monster.likedByUser,
                          onPressed: () {
                            //monsterGalleryController.likeUnlikeMonster(monster, like: !monster.likedByUser);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
        }
      },
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: _fraction ?? 0.8,
        initialPage: widget
            .initialPage, //TODO: Idea: this could be randomized, so you see a different one in the middle each time
        enableInfiniteScroll: true,
        autoPlay: widget.autoPlay,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
        enlargeCenterPage: widget.enlargeCenterPage,
        reverse:
            widget.galleryType == MonsterGalleryType.mostPopular ? true : false,
      ),
    );
  }

  void _calculateViewportFraction(MediaQueryData mediaQuery) {
    final double? height = _carouselKey.currentContext?.size?.height;
    final double? width = _carouselKey.currentContext?.size?.width;
    assert(height != null && width != null,
        '_calculateFraction error in MonsterGalleryScreen');

    double controlHeight = 0;
    if (widget.info == GalleryMonsterInfo.onlyLikes) {
      controlHeight = AppConstants.likeAndUploadDateHeight(mediaQuery) / 2;
    } else if (widget.info == GalleryMonsterInfo.likesAndDate) {
      controlHeight = AppConstants.likeAndUploadDateHeight(mediaQuery);
    } else if (widget.hasControls) {
      controlHeight =
          AppConstants.galleryMonsterInfoAndControlsHeight(mediaQuery);
    }

    final monsterFrameWidth =
        height! * ((230) / (365 + controlHeight + 40.0 + 4.0));
    //final double monsterAspectRatio = 230 / 365;
    //final double viewPortAspectRatio = width / height;
    //final double nrOfMonstersShowingDouble = width / monsterFrameWidth;
    final int nrOfMonstersShowing = width! ~/ monsterFrameWidth;

    final itemWidth = nrOfMonstersShowing >= 6
        ? monsterFrameWidth +
            ((width - (monsterFrameWidth * 5)) / 6) -
            (monsterFrameWidth / (4 * 3))
        : nrOfMonstersShowing >= 4
            ? monsterFrameWidth +
                ((width - (monsterFrameWidth * 3)) / 4) -
                (monsterFrameWidth / (4 * 2))
            : nrOfMonstersShowing >= 2
                ? monsterFrameWidth +
                    ((width - (monsterFrameWidth)) / 2) -
                    (monsterFrameWidth / (4))
                : monsterFrameWidth +
                    ((width - (monsterFrameWidth)) / 2) -
                    (monsterFrameWidth / (8));

    final percentOfViewportWidth = itemWidth / width;
    //final newValue = percentOfViewportWidth * (height / width);
    /*print(
      '\n\n${widget.galleryType}:\nwidth: $width,\nheight: $height,\nitemWidth:$itemWidth,\nspaceLeft:$spaceLeft,\npercent: $percentOfViewportWidth,\nnewValue: $newValue,\nmonsterAspectRatio $monsterAspectRatio,\nviewportAspectRatio: $viewPortAspectRatio\nmonstersFitting: $nrOfMonstersShowingDouble\nnrOfMonstersShowing: $nrOfMonstersShowing\nmonsterFrameWidth: $monsterFrameWidth\n\n');*/

    if (_fraction != percentOfViewportWidth) {
      _fraction = percentOfViewportWidth;
      setState(() {});
    }
  }
}

class LikesAndUploadDate extends StatelessWidget {
  const LikesAndUploadDate(
      {super.key, required this.monster, required this.infoToShow});

  final GalleryMonster monster;
  final GalleryMonsterInfo infoToShow;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (infoToShow == GalleryMonsterInfo.none) {
      return Container();
    }

    final double height = infoToShow == GalleryMonsterInfo.none
        ? 0
        : infoToShow == GalleryMonsterInfo.onlyLikes
            ? AppConstants.likeAndUploadDateHeight(mediaQuery) / 2
            : AppConstants.likeAndUploadDateHeight(mediaQuery);

    return SizedBox(
      height: height,
      child: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 16.0,
                    child: Image.asset('assets/images/Like indicator.png')),
                Text(
                  ' ${monster.likes}',
                  style: GameTextStyles.standardTextStyle(media: mediaQuery),
                ),
              ],
            ),
            if (infoToShow == GalleryMonsterInfo.likesAndDate)
              Text(
                'Uploaded 2 weeks ago',
                style: GameTextStyles.smallTextStyle(media: mediaQuery),
              ),
          ],
        ),
      ),
    );
  }
}
