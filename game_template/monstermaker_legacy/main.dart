import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:device_info/device_info.dart';
import 'package:monstermaker/colors.dart' as appColors;
import 'package:monstermaker/controllers/game_controller.dart';
import 'package:monstermaker/screens/drawing_screen/drawing_screen.dart';
//import 'package:home_indicator/home_indicator.dart';
import 'package:monstermaker/screens/home_screen.dart';
import 'controllers/brush_settings_controller.dart';

const bool debugDrawingScreen = true;

void main() async {
  ///Needed for firebase initialization to work
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.model.toLowerCase().contains("ipad")) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } else {
      if (debugDrawingScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      //await HomeIndicator.hide();
      //await HomeIndicator.deferScreenEdges([ScreenEdge.top, ScreenEdge.bottom]);
    }
  } else {
    if (debugDrawingScreen) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BrushSettingsController());
    return GetBuilder<GameController>(
        init: GameController(),
        builder: (_) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MonsterMaker',
            defaultTransition: Transition.fadeIn,
            theme: ThemeData(
              backgroundColor: appColors.backgroundSky,
              scaffoldBackgroundColor: appColors.backgroundSky,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  shadowColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  fixedSize: MaterialStateProperty.all<Size>(
                      const Size.fromWidth(280.0)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero),
                ),
              ),
            ),
            home:
                debugDrawingScreen ? const DrawingScreen() : const HomeScreen(),
          );
        });
  }
}
