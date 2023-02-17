import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monstermaker/app_constants.dart';

class RoomCodeText extends StatelessWidget {
  final String code;

  const RoomCodeText({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final codeStyle = GoogleFonts.rubik(
      fontSize: mediaQuery.size.width > AppConstants.largeWidthBreakPoint ? 60 : 40,
      letterSpacing: 8.0,
      fontWeight: FontWeight.w900,
      color: Colors.white,
    );

    return Stack(
      children: [
        Text(
          code,
          style: codeStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = mediaQuery.size.width > AppConstants.largeWidthBreakPoint ? 5.5 : 3.5
              ..color = Colors.black,
          ),
        ),
        Text(
          code,
          style: codeStyle,
        ),
      ],
    );
  }
}
