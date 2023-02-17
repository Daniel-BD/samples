import 'package:flutter/material.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/colors.dart' as appColors;
import 'package:monstermaker/widgets/background_clouds.dart';
import 'package:monstermaker/widgets/buttons.dart';

enum CloudPosition { middle, top, bottom }

enum TopLeftButtonType { none, backButton, quitButton }

class CloudsBackgroundScreen extends StatelessWidget {
  /// Where to position the clouds.
  /// If [CloudPosition.middle], then both [firstChild] and [secondChild] must be given.
  /// If [CloudPosition.top] or [CloudPosition.bottom], only [firstChild] can be given.
  final CloudPosition cloudPosition;
  final TopLeftButtonType topLeftButton;
  final VoidCallback? onTopLeftButtonPressed;
  final Widget firstChild;
  final Widget? secondChild;
  final String? title;
  final bool minimizeBottomClouds;

  /// If [cloudPosition] is .top and [placeChildInClouds] is true, places [firstChild] starting inside the clouds.
  /// Otherwise places [firstChild] directly below were clouds end.
  final bool placeChildInClouds;

  const CloudsBackgroundScreen({
    Key? key,
    required this.cloudPosition,
    required this.topLeftButton,
    this.onTopLeftButtonPressed,
    required this.firstChild,
    this.secondChild,
    this.title,
    this.placeChildInClouds = false,
    this.minimizeBottomClouds = false,
  })  : assert(!(topLeftButton == TopLeftButtonType.none && onTopLeftButtonPressed != null),
            "topLeftButton can't be none if an onTopLeftButtonPressed callback is non-null"),
        assert(!(topLeftButton == TopLeftButtonType.quitButton && onTopLeftButtonPressed == null),
            "If topLeftButton is a quitButton, onTopLeftButtonPressed must be non-null."),
        assert(
          (cloudPosition == CloudPosition.middle && secondChild != null) ||
              (cloudPosition != CloudPosition.middle && secondChild == null),
          "If cloudPosition is middle, both firstChild and secondChild must be non-null, if cloudPosition is top or bottom, then secondChild must be null",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Querying the current media causes this widget to rebuild whenever the underlying data changes.
    //This makes sure that the layout adapts correctly when changing screen orientation on iPads.
    final mediaQuery = MediaQuery.of(context);

    if (cloudPosition == CloudPosition.top) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _topBar(mediaQuery),
              if (!placeChildInClouds) const BackgroundClouds(asSmallAsPossible: true),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (placeChildInClouds)
                      Column(
                        children: [
                          const BackgroundClouds(asSmallAsPossible: true),
                          Expanded(
                            child: Container(
                              color: appColors.backgroundCloudWhite,
                            ),
                          ),
                        ],
                      ),
                    if (placeChildInClouds)
                      Padding(
                        padding: EdgeInsets.only(top: mediaQuery.size.width * 0.02),
                        child: firstChild,
                      ),
                    if (!placeChildInClouds)
                      Container(
                        color: appColors.backgroundCloudWhite,
                        //child: firstChild,
                      ),
                    if (!placeChildInClouds) firstChild,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (cloudPosition == CloudPosition.bottom) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          left: false,
          right: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _topBar(mediaQuery),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: firstChild,
                ),
              ),
              BackgroundClouds(asSmallAsPossible: minimizeBottomClouds),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              /// Top part of the home screen with logo and two big buttons (Play and Monster Gallery)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: mediaQuery.size.height * AppConstants.skyPercentageOfHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _topBar(mediaQuery),
                      Flexible(
                        child: firstChild,
                      ),
                    ],
                  ),
                ),
              ),

              /// The cloud background
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * AppConstants.skyPercentageOfHeight,
                  ),
                  const BackgroundClouds(),
                  if (cloudPosition != CloudPosition.bottom)
                    Expanded(
                      child: Container(
                        color: appColors.backgroundCloudWhite,
                      ),
                    ),
                ],
              ),

              /// The bottom part of the home screen
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            mediaQuery.size.height * AppConstants.skyPercentageOfHeight + mediaQuery.size.width * 0.02,
                      ),
                      Flexible(
                        child: secondChild!,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _topBar(MediaQueryData mediaQuery) {
    if (topLeftButton == TopLeftButtonType.backButton) {
      return BackButtonRow(
        onPressed: onTopLeftButtonPressed,
        title: title,
      );
    } else if (topLeftButton == TopLeftButtonType.quitButton) {
      return QuitButtonRow(
        onPressed: onTopLeftButtonPressed!,
        title: title,
      );
    } else if (topLeftButton == TopLeftButtonType.none && title != null) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(title!, style: AppConstants.titleTextStyle(media: mediaQuery))]);
    } else {
      return Container();
    }
  }
}
