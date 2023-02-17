import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/widgets/buttons.dart';

import '../src/ui_components/colors.dart';

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
  static const fontSizeMin = 12.0;
  static const fontSizeMax = 30.0;
  static double smallFontSize({required MediaQueryData media}) {
    return (media.size.width > largeWidthBreakPoint &&
            media.size.height > largeHeightBreakPoint)
        ? 18
        : 12;
  }

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

  static TextStyle standardTextStyle(
      {required MediaQueryData media, bool isLandscape = false}) {
    return GoogleFonts.rubik(
      fontSize: media.size.width >
              (isLandscape
                  ? largeWidthBreakPointLandscape
                  : largeWidthBreakPoint)
          ? 22
          : 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  static TextStyle drawingTimerTextStyle(
      {required MediaQueryData media, bool isLandscape = true}) {
    return GoogleFonts.inter(
      fontSize: media.size.width >
              (isLandscape
                  ? largeWidthBreakPointLandscape
                  : largeWidthBreakPoint)
          ? 30
          : 22,
      fontWeight: FontWeight.w500,
      color: Colors.black.withOpacity(0.7),
    );
  }

  static TextStyle smallTextStyle(
      {required MediaQueryData media, bool isLandscape = false}) {
    return standardTextStyle(media: media).copyWith(
      fontSize: media.size.width >
              (isLandscape
                  ? largeWidthBreakPointLandscape
                  : largeWidthBreakPoint)
          ? 18
          : 12,
    );
  }

  static TextStyle boldTextStyle(
      {required MediaQueryData media, bool isLandscape = false}) {
    return standardTextStyle(media: media, isLandscape: isLandscape)
        .copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle thinTextStyle({required MediaQueryData media}) {
    return standardTextStyle(media: media)
        .copyWith(fontWeight: FontWeight.w300);
  }

  static TextStyle paragraphTextStyle({required MediaQueryData media}) {
    return GoogleFonts.rubik(
      textStyle: TextStyle(
        fontSize: media.size.width > largeWidthBreakPoint ? fontSizeMax : 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static TextStyle titleTextStyle({required MediaQueryData media}) {
    return GoogleFonts.gaegu(
      fontSize: media.size.width > largeWidthBreakPoint ? 50 : 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle roomCodeTextFieldStyle({required MediaQueryData media}) {
    return GoogleFonts.rubik(
      fontSize: media.size.width > largeWidthBreakPoint ? 48.0 : 32.0,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle alertTitleTextStyle() {
    return GoogleFonts.rubik(
      fontSize: 20, //todo: make it bigger for iPad?
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle alertButtonTextStyle() {
    return GoogleFonts.rubik(
      fontSize: 18, //todo: make it bigger for iPad?
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle brushPanelButtonTextStyle() {
    return GoogleFonts.rubik(
      fontSize: 16, //todo: make it bigger for iPad?
      fontWeight: FontWeight.w500,
      color: brushButtonTextColor,
    );
  }

  static double signWidth(
      {required MediaQueryData media, bool isSmall = false}) {
    if (isSmall) {
      return min(media.size.width * 0.45, 280.0);
    } else {
      return min(media.size.width * 0.55, 320.0);
    }
  }

  static double buttonWidth(ButtonType buttonType, MediaQueryData media) {
    final width = media.size.width;

    switch (buttonType) {
      case ButtonType.big:
        return width > largeWidthBreakPoint ? 392.0 : 280.0;
      case ButtonType.small:
        return width > largeWidthBreakPoint ? 80.0 : 55.0;
      case ButtonType.about:
        return width > largeWidthBreakPoint ? 120.0 : 85.0;
      case ButtonType.instagram:
        return width > largeWidthBreakPoint ? 320.0 : 192.0;
    }
  }

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

  static int getRealNumberOfPlayers(NumberOfPlayers numberOfPlayers) {
    return numberOfPlayers.index + 2;
  }
}
