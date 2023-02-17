import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/theme/text_styles.dart';

import '../theme/colors.dart' as game_colors;
import 'background_clouds.dart';
import 'buttons.dart';
import 'ui_constants.dart';

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
  final bool minimizeBottomClouds, hideAppBar;

  /// If [cloudPosition] is .top and [placeChildInClouds] is true, places [firstChild] starting inside the clouds.
  /// Otherwise places [firstChild] directly below were clouds end.
  final bool placeChildInClouds;

  const CloudsBackgroundScreen({
    super.key,
    required this.cloudPosition,
    required this.topLeftButton,
    this.onTopLeftButtonPressed,
    required this.firstChild,
    this.secondChild,
    this.title,
    this.placeChildInClouds = false,
    this.minimizeBottomClouds = false,
    this.hideAppBar = false,
  })  : assert(
            !(topLeftButton == TopLeftButtonType.none &&
                onTopLeftButtonPressed != null),
            "topLeftButton can't be none if an onTopLeftButtonPressed callback is non-null"),
        assert(
            !(topLeftButton == TopLeftButtonType.quitButton &&
                onTopLeftButtonPressed == null),
            "If topLeftButton is a quitButton, onTopLeftButtonPressed must be non-null."),
        assert(
          (cloudPosition == CloudPosition.middle && secondChild != null) ||
              (cloudPosition != CloudPosition.middle && secondChild == null),
          "If cloudPosition is middle, both firstChild and secondChild must be non-null, if cloudPosition is top or bottom, then secondChild must be null",
        );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final Widget? appBar = hideAppBar
        ? null
        : _GameAppBar(
            leadingButton: topLeftButton,
            onPressed: onTopLeftButtonPressed ?? () {},
            title: title,
          );

    if (cloudPosition == CloudPosition.top) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (appBar != null) appBar,
              if (!placeChildInClouds)
                const BackgroundClouds(asSmallAsPossible: true),
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
                              color: game_colors.backgroundCloudWhite,
                            ),
                          ),
                        ],
                      ),
                    if (placeChildInClouds)
                      Padding(
                        padding:
                            EdgeInsets.only(top: mediaQuery.size.width * 0.02),
                        child: firstChild,
                      ),
                    if (!placeChildInClouds)
                      Container(
                        color: game_colors.backgroundCloudWhite,
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
              if (appBar != null) appBar,
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
                  height: mediaQuery.size.height *
                      AppConstants.skyPercentageOfHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (appBar != null) appBar,
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
                    height: mediaQuery.size.height *
                        AppConstants.skyPercentageOfHeight,
                  ),
                  const BackgroundClouds(),
                  if (cloudPosition != CloudPosition.bottom)
                    Expanded(
                      child: Container(
                        color: game_colors.backgroundCloudWhite,
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
                        height: mediaQuery.size.height *
                                AppConstants.skyPercentageOfHeight +
                            mediaQuery.size.width * 0.02,
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
}

class _GameAppBar extends StatelessWidget {
  final EdgeInsets padding;
  final String? title;
  final VoidCallback onPressed;
  final TopLeftButtonType leadingButton;
  const _GameAppBar({
    required this.leadingButton,
    required this.onPressed,
    this.title,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppConstants.horizontalEdgePadding,
      vertical: AppConstants.smallVerticalSpacing,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    late final Widget? button;

    switch (leadingButton) {
      case TopLeftButtonType.none:
        button = null;
        break;
      case TopLeftButtonType.backButton:
        button = BackGameButton(
          onPressed: onPressed,
        );
        break;
      case TopLeftButtonType.quitButton:
        button = QuitGameButton(onPressed: onPressed);
        break;
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (button != null) button,
          Flexible(
            child: AutoSizeText(
              title ?? "",
              style: GameTextStyles.titleTextStyle(media: mediaQuery),
              maxLines: 1,
            ),
          ),
          if (button != null)
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainInteractivity: false,
              maintainState: true,
              maintainSemantics: false,
              child: button,
            ),
        ],
      ),
    );
  }
}
