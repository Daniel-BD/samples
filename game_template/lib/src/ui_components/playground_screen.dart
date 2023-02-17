import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'buttons.dart';
import 'clouds_background_page.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return CloudsBackgroundScreen(
      title: 'Playground',
      cloudPosition: CloudPosition.bottom,
      topLeftButton: TopLeftButtonType.backButton,
      firstChild: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QuitGameButton(
              onPressed: () {},
            ),
            BackGameButton(),
            HeartGameButton(
              filled: liked,
              onPressed: () {},
            ),
            GameButton(
              assetPath: 'assets/images/Pressed=false, Type=Play.png',
              onPressed: () {},
            ),
            GameButton(
              assetPath: 'assets/images/Pressed=false, Type=MonsterGallery.png',
              onPressed: () {},
            ),
            GameButton(
              buttonType: ButtonType.about,
              assetPath: 'assets/images/Pressed=false, Type=About.png',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
