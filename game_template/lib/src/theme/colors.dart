import 'package:flutter/material.dart';

const Color backgroundSky = Color(0xFFE1F4FF);
const Color backgroundCloudWhite = Color(0xFFFFFFFF);
const Color dividerColor = Color(0xFF505050);
const Color errorTextColor = Color(0xFFE10000);
const Color blueTextButtonColor = Color(0xFF1760CF);
const Color monsterCanvasColor = Color(0xFFFFF7EA);
const Color canvasDashColor = Color(0x33000000);
const Color drawingControlPanelColor = backgroundSky; //Color(0xFF989898);
const Color controlPanelButtonColor = Color(0xFF2D324D);
const Color panelDarkColor = Color(0xFF3D3D3D);
const Color panelOffWhiteColor = Color(0xFFFAFAFA);
const Color panelActiveButtonColor = Color(0xFF3B6CB7);
const Color brushButtonTextColor =
    Color(0xFF307BF6); //Color(0xFF307BF6); //0xFF0F52B3
const Color brushActiveColor = Color(0xFF8A95B1);
const Color brushInactiveColor = Color(0xFFB6C5D9);
const Color checkersPatternDarkColor = Color(0xFFE9E5DD);

List<List<Color>> brushColorList = [
  for (int i = 0; i < 8; i++)
    [
      for (int j = 0; j < 8; j++)
        HSLColor.fromAHSL(1.0, 360 * (i / 8), j / 8, j / 8).toColor(),
    ]
];

List<Color> brushColors = [
  Colors.black,
  Colors.white,
  HSLColor.fromAHSL(1.0, 0.1, 0.5, 0.5).toColor(),
  Color(0xFFBABABA),
  Color(0xFF9492AA),
  Color(0xFF6E8C9A),
  Color(0xFF87CDFF),
  Color(0xFF4E86BF),
  Color(0xFF0085FF),
  Color(0xFF0030b5),
  Color(0xFF233666),
  Color(0xFF9EB79B),
  Color(0xFF7DE0BF),
  Color(0xFF99ffa7),
  Color(0xFF22F300),
  Color(0xFF00a339),
  Color(0xFF007D58),
  Color(0xFFFFCD34),
  Color(0xFFffff00),
  Color(0xFFFD7900),
  Color(0xFFF1BF98),
  Color(0xFFffdbac),
  Color(0xFFe0ac69),
  Color(0xFFBF9F78),
  Color(0xFF8d5524),
  Color(0xFF391D68),
  Color(0xFFffbffe),
  Color(0xFFbf00bf),
  Color(0xFFffc0cb),
  Color(0xFFF97285),
  Color(0xFFff7daf),
  Color(0xFFDD5555),
  Color(0xFFFF833E),
  Color(0xFFE8511E),
  Color(0xFFFF0000),
];
