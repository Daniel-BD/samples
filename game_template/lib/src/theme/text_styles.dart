import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui_components/ui_constants.dart';
import 'colors.dart';

class GameTextStyles {
  static const fontSizeMin = 12.0;
  static const fontSizeMax = 30.0;
  static double smallFontSize({required MediaQueryData media}) {
    return (media.size.width > AppConstants.largeWidthBreakPoint &&
            media.size.height > AppConstants.largeHeightBreakPoint)
        ? 18
        : 12;
  }

  static TextStyle standardTextStyle(
      {required MediaQueryData media, bool isLandscape = false}) {
    return GoogleFonts.rubik(
      fontSize: media.size.width >
              (isLandscape
                  ? AppConstants.largeWidthBreakPointLandscape
                  : AppConstants.largeWidthBreakPoint)
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
                  ? AppConstants.largeWidthBreakPointLandscape
                  : AppConstants.largeWidthBreakPoint)
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
                  ? AppConstants.largeWidthBreakPointLandscape
                  : AppConstants.largeWidthBreakPoint)
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
        fontSize: media.size.width > AppConstants.largeWidthBreakPoint
            ? fontSizeMax
            : 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static TextStyle titleTextStyle({required MediaQueryData media}) {
    return GoogleFonts.gaegu(
      fontSize: media.size.width > AppConstants.largeWidthBreakPoint ? 50 : 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle roomCodeTextFieldStyle({required MediaQueryData media}) {
    return GoogleFonts.rubik(
      fontSize:
          media.size.width > AppConstants.largeWidthBreakPoint ? 48.0 : 32.0,
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
}
