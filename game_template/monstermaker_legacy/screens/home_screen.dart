import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/controllers/monster_gallery_controller.dart';
import 'package:monstermaker/screens/about_screen.dart';
import 'package:monstermaker/screens/clouds_background_screen.dart';
import 'package:monstermaker/screens/monster_gallery_screen.dart';
import 'package:monstermaker/screens/new_game_screen.dart';
import 'package:monstermaker/widgets/buttons.dart';
import 'package:monstermaker/widgets/monster_gallery_carousel.dart';
import 'package:monstermaker/widgets/monster_maker_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //Querying the current media causes this widget to rebuild whenever the underlying data changes.
    //This makes sure that the layout adapts correctly when changing screen orientation on iPads.
    final mediaQuery = MediaQuery.of(context);

    return CloudsBackgroundScreen(
      cloudPosition: CloudPosition.middle,
      topLeftButton: TopLeftButtonType.none,
      firstChild: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              left: AppConstants.horizontalEdgePadding,
              right: AppConstants.horizontalEdgePadding,
              top: AppConstants.horizontalEdgePadding,
            ),
            child: MonsterMakerLogo(),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                    assetNormal: 'assets/images/Pressed=false, Type=Play.png',
                    assetPressedDown:
                        'assets/images/Pressed=true, Type=Play.png',
                    onPressed: () async {
                      await Get.to(
                        () => const NewGameScreen(),
                        transition: Transition.fadeIn,
                      );
                      //This solves the issue where the carousel has the wrong viewPortFraction until
                      // it rebuilds if the screen orientation has changed since last on this screen
                      Future.microtask(() => setState(() {}));
                    }),
                AppButton(
                    assetNormal:
                        'assets/images/Pressed=false, Type=MonsterGallery.png',
                    assetPressedDown:
                        'assets/images/Pressed=true, Type=MonsterGallery.png',
                    onPressed: () async {
                      await Get.to(
                        () => GetBuilder<MonsterGalleryController>(
                            init: MonsterGalleryController(),
                            builder: (_) {
                              return const MonsterGalleryScreen();
                            }),
                        transition: Transition.fadeIn,
                      );
                      //This solves the issue where the carousel has the wrong viewPortFraction until
                      // it rebuilds if the screen orientation has changed since last on this screen
                      Future.microtask(() => setState(() {}));
                    }),
              ],
            ),
          ),
        ],
      ),
      secondChild: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: SizedBox(
              width: AppConstants.signWidth(media: mediaQuery),
              child: Image.asset('assets/images/Type=New monsters.png'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.smallVerticalSpacing),
              child: GetBuilder<MonsterGalleryController>(
                init: MonsterGalleryController(),
                builder: (_) {
                  return MonsterGalleryCarousel(
                    galleryType: MonsterGalleryType.newMonsters,
                    enlargeCenterPage: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? true
                        : false,
                  );
                },
              ),
            ),
          ),
          const InstagramAndAbout(),
        ],
      ),
    );
  }
}

class InstagramAndAbout extends StatelessWidget {
  const InstagramAndAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.horizontalEdgePadding,
        right: AppConstants.horizontalEdgePadding,
        bottom: AppConstants.smallVerticalSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /*AppButton(
            assetNormal: 'assets/images/Instagram.png',
            assetPressedDown: 'assets/images/Instagram.png',
            onPressed: () async {
              const String url = 'https://www.instagram.com/monstermakergame/';
              final bool canLaunchUrl = await canLaunch(url);
              if (canLaunchUrl) {
                await launch(url);
              }
            },
            buttonType: ButtonType.instagram,
          ),*/
          AppButton(
            assetNormal: 'assets/images/Pressed=false, Type=About.png',
            assetPressedDown: 'assets/images/Pressed=true, Type=About.png',
            onPressed: () {
              Get.to(() => const AboutScreen(), transition: Transition.fadeIn);
            },
            buttonType: ButtonType.about,
          ),
        ],
      ),
    );
  }
}
