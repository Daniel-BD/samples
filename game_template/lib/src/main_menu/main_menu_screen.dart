import 'package:flutter/material.dart';
import 'package:game_template/src/main_menu/signs.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../ui_components/buttons.dart';
import '../ui_components/clouds_background_page.dart';
import '../ui_components/monster_gallery_carousel.dart';
import '../ui_components/ui_constants.dart';
import 'monster_maker_logo.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return CloudsBackgroundScreen(
      hideAppBar: true,
      cloudPosition: CloudPosition.middle,
      topLeftButton: TopLeftButtonType.none,
      firstChild: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                GameButton(
                    assetPath: 'assets/images/Pressed=false, Type=Play.png',
                    onPressed: () async {
                      //TODO: GO TO NEW GAME SCREEN
                      //This solves the issue where the carousel has the wrong viewPortFraction until
                      // it rebuilds if the screen orientation has changed since last on this screen
                      //Future.microtask(() => setState(() {}));
                    }),
                GameButton(
                    assetPath:
                        'assets/images/Pressed=false, Type=MonsterGallery.png',
                    onPressed: () async {
                      //TODO: Go to monster maker gallery
                      //This solves the issue where the carousel has the wrong viewPortFraction until
                      // it rebuilds if the screen orientation has changed since last on this screen
                      // Future.microtask(() => setState(() {}));
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
            child: MonsterSign(type: SignType.newMonsters),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.smallVerticalSpacing),
              child: MonsterGalleryCarousel(
                galleryType: MonsterGalleryType.newMonsters,
                enlargeCenterPage:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? true
                        : false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppConstants.horizontalEdgePadding,
              right: AppConstants.horizontalEdgePadding,
              bottom: AppConstants.smallVerticalSpacing,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/drawing_playground'),
                  child: Text('Drawing playground'),
                ),
                GameButton(
                  assetPath: 'assets/images/Pressed=false, Type=About.png',
                  onPressed: () => context.go('/about'),
                  buttonType: ButtonType.about,
                ),
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
              ],
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   backgroundColor: backgroundSky,
    //   body: ResponsiveScreen(
    //     mainAreaProminence: 0.45,
    //     squarishMainArea: Center(
    //       child: Transform.rotate(
    //         angle: -0.1,
    //         child: const Text(
    //           'Flutter Game Template!',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontFamily: 'Permanent Marker',
    //             fontSize: 55,
    //             height: 1,
    //           ),
    //         ),
    //       ),
    //     ),
    //     rectangularMenuArea: Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         ElevatedButton(
    //           onPressed: () {
    //             audioController.playSfx(SfxType.buttonTap);
    //             GoRouter.of(context).go('/play');
    //           },
    //           child: const Text('Play'),
    //         ),
    //         _gap,
    //         if (gamesServicesController != null) ...[
    //           _hideUntilReady(
    //             ready: gamesServicesController.signedIn,
    //             child: ElevatedButton(
    //               onPressed: () => gamesServicesController.showAchievements(),
    //               child: const Text('Achievements'),
    //             ),
    //           ),
    //           _gap,
    //           _hideUntilReady(
    //             ready: gamesServicesController.signedIn,
    //             child: ElevatedButton(
    //               onPressed: () => gamesServicesController.showLeaderboard(),
    //               child: const Text('Leaderboard'),
    //             ),
    //           ),
    //           _gap,
    //         ],
    //         ElevatedButton(
    //           onPressed: () => GoRouter.of(context).go('/settings'),
    //           child: const Text('Settings'),
    //         ),
    //         _gap,
    //         ElevatedButton(
    //           onPressed: () => GoRouter.of(context).go('/playground'),
    //           child: const Text('Playground'),
    //         ),
    //         _gap,
    //         Padding(
    //           padding: const EdgeInsets.only(top: 32),
    //           child: ValueListenableBuilder<bool>(
    //             valueListenable: settingsController.muted,
    //             builder: (context, muted, child) {
    //               return IconButton(
    //                 onPressed: () => settingsController.toggleMuted(),
    //                 icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
    //               );
    //             },
    //           ),
    //         ),
    //         _gap,
    //         const Text('Music by Mr Smith'),
    //         _gap,
    //       ],
    //     ),
    //   ),
    // );
  }

  // /// Prevents the game from showing game-services-related menu items
  // /// until we're sure the player is signed in.
  // ///
  // /// This normally happens immediately after game start, so players will not
  // /// see any flash. The exception is folks who decline to use Game Center
  // /// or Google Play Game Services, or who haven't yet set it up.
  // Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
  //   return FutureBuilder<bool>(
  //     future: ready,
  //     builder: (context, snapshot) {
  //       // Use Visibility here so that we have the space for the buttons
  //       // ready.
  //       return Visibility(
  //         visible: snapshot.data ?? false,
  //         maintainState: true,
  //         maintainSize: true,
  //         maintainAnimation: true,
  //         child: child,
  //       );
  //     },
  //   );
  // }
  //
  // static const _gap = SizedBox(height: 10);
}
