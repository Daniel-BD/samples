import 'package:flutter/material.dart';

import 'buttons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:monstermaker/controllers/game_controller.dart';
// import 'package:monstermaker/widgets/buttons.dart';
//
// import 'colors.dart';

class AppConstants {
  static const drawingSectionAspectRatio = 16 / 9;

  static const largeWidthBreakPoint = 600.0;
  static const largeWidthBreakPointLandscape = 1000.0;
  static const largeHeightBreakPoint = 600.0;
  static const horizontalEdgePadding = 16.0;
  static const smallHorizontalSpacing = 8.0;
  static const mediumHorizontalSpacing = 16.0;
  static const largeHorizontalSpacing = 32.0;
  static const smallVerticalSpacing = 8.0;
  static const tinyVerticalSpacing = 4.0;
  static const mediumVerticalSpacing = 16.0;
  static double largeAdaptiveVerticalSpacing({required MediaQueryData media}) {
    return media.size.width < largeWidthBreakPoint ? 32.0 : 64.0;
  }

  static double largeAdaptiveHorizontalSpacing(
      {required MediaQueryData media}) {
    return media.size.width < largeWidthBreakPoint ? 32.0 : 64.0;
  }

  static const logoMaxWidth = largeWidthBreakPoint;
  static const skyPercentageOfHeight = 0.4;
  static const cloudsPercentageOfHeight = 1.0 - skyPercentageOfHeight;
  static const textMaxWidth = 600.0;

  static double bigButtonWidth({required MediaQueryData media}) {
    return media.size.width > largeWidthBreakPoint ? 392.0 : 280;
  }

  static double smallButtonWidth({required MediaQueryData media}) {
    return media.size.width > largeWidthBreakPoint ? 80.0 : 55.0;
  }

  static double aboutButtonWidth({required MediaQueryData media}) {
    return media.size.width > largeWidthBreakPoint ? 120.0 : 85.0;
  }

  static double instagramButtonWidth({required MediaQueryData media}) {
    return media.size.width > largeWidthBreakPoint ? 320.0 : 192.0;
  }

//
//   static double buttonWidth(ButtonType buttonType, MediaQueryData media) {
//     final width = media.size.width;
//
//     switch (buttonType) {
//       case ButtonType.big:
//         return width > largeWidthBreakPoint ? 392.0 : 280.0;
//       case ButtonType.small:
//         return width > largeWidthBreakPoint ? 80.0 : 55.0;
//       case ButtonType.about:
//         return width > largeWidthBreakPoint ? 120.0 : 85.0;
//       case ButtonType.instagram:
//         return width > largeWidthBreakPoint ? 320.0 : 192.0;
//     }
//   }
//
  static double buttonHeight(ButtonType buttonType, MediaQueryData media) {
    final width = media.size.width;

    switch (buttonType) {
      case ButtonType.big:
        return width > largeWidthBreakPoint
            ? 72.5
            : smallScreenSmallButtonHeight;
      case ButtonType.small:
        return width > largeWidthBreakPoint
            ? 72.5
            : smallScreenSmallButtonHeight;
      case ButtonType.about:
        return width > largeWidthBreakPoint ? 56.5 : 40.0;
      case ButtonType.instagram:
        return width > largeWidthBreakPoint ? 50 : 30.0;
    }
  }

  static const smallScreenSmallButtonHeight = 50.0;
  static const _smallInfoAndControlsHeight = 40.0;
  static const _bigInfoAndControlsHeight = 60.0;

  static double galleryMonsterInfoAndControlsHeight(MediaQueryData media) {
    return (mediumVerticalSpacing * 2) +
        buttonHeight(ButtonType.small, media) +
        likeAndUploadDateHeight(media);
  }

  static double likeAndUploadDateHeight(MediaQueryData media) {
    final double likeAndUploadDateHeight;
    if (media.size.height < media.size.width ||
        media.size.width < largeWidthBreakPoint) {
      likeAndUploadDateHeight = _smallInfoAndControlsHeight;
    } else {
      likeAndUploadDateHeight = _bigInfoAndControlsHeight;
    }
    return likeAndUploadDateHeight;
  }
//
//   static int getRealNumberOfPlayers(NumberOfPlayers numberOfPlayers) {
//     return numberOfPlayers.index + 2;
//   }
}
