import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/widgets/framed_gallery_monster_widget.dart';

enum ButtonType {
  big,
  small,
  about,
  instagram,
}

class AppButton extends StatefulWidget {
  final String assetNormal;
  final String assetPressedDown;
  final VoidCallback onPressed;
  final ButtonType buttonType;
  final bool forceSmallestSize;

  const AppButton({
    Key? key,
    required this.assetNormal,
    required this.assetPressedDown,
    required this.onPressed,
    this.buttonType = ButtonType.big,
    this.forceSmallestSize = false,
  }) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool isPressedDown = false;
  double width = 280.0;

  @override
  Widget build(BuildContext context) {
    calculateWidth();

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressedDown = true;
          });
        },
        onTapCancel: () {
          setState(() {
            isPressedDown = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressedDown = false;
          });
          widget.onPressed();
        },
        child: Stack(
          children: [
            Visibility(
              visible: !isPressedDown,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              maintainInteractivity: false,
              child: Image.asset(widget.assetNormal),
            ),
            Visibility(
              visible: isPressedDown,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              maintainInteractivity: false,
              child: Image.asset(widget.assetPressedDown),
            ),
          ],
        ),
      ),
    );
  }

  void calculateWidth() {
    final bool isBigScreen = Get.size.width > 600 && Get.size.height > 600;

    switch (widget.buttonType) {
      case ButtonType.big:
        width = isBigScreen ? 392.0 : 280.0;
        break;
      case ButtonType.small:
        if (widget.forceSmallestSize) {
          width = 55.0;
        } else {
          width = isBigScreen ? 80.0 : 55.0;
        }
        break;
      case ButtonType.about:
        width = isBigScreen ? 120.0 : 85.0;
        break;
      case ButtonType.instagram:
        width = isBigScreen ? 320.0 : 192.0;
        break;
    }
  }
}

class BackButtonRow extends StatelessWidget {
  final EdgeInsets padding;
  final String? title;

  /// In addition to navigating back.
  final VoidCallback? onPressed;
  const BackButtonRow(
      {Key? key,
      this.title,
      this.padding = const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalEdgePadding,
        vertical: AppConstants.smallVerticalSpacing,
      ),
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final backButton = Padding(
      padding: padding,
      child: AppButton(
        assetNormal: 'assets/images/Pressed=false, Type=Back.png',
        assetPressedDown: 'assets/images/Pressed=true, Type=Back.png',
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
          Get.back();
        },
        buttonType: ButtonType.small,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        backButton,
        Flexible(
          child: AutoSizeText(
            title ?? "",
            style: AppConstants.titleTextStyle(media: mediaQuery),
            maxLines: 1,
          ),
        ),
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainInteractivity: false,
          maintainState: true,
          maintainSemantics: false,
          child: backButton,
        ),
      ],
    );
  }
}

class QuitButtonRow extends StatelessWidget {
  final VoidCallback onPressed;
  final String? title;

  const QuitButtonRow({Key? key, required this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final quitButton = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalEdgePadding,
        vertical: AppConstants.smallVerticalSpacing,
      ),
      child: AppButton(
        assetNormal: 'assets/images/Cancel button.png',
        assetPressedDown: 'assets/images/Cancel button pressed.png',
        onPressed: onPressed,
        buttonType: ButtonType.small,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        quitButton,
        Flexible(
          child: AutoSizeText(
            title ?? "",
            style: AppConstants.titleTextStyle(media: mediaQuery),
            maxLines: 1,
          ),
        ),
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainInteractivity: false,
          maintainState: true,
          maintainSemantics: false,
          child: quitButton,
        ),
      ],
    );
  }
}

class LikedButton extends StatelessWidget {
  final bool liked;
  final VoidCallback onPressed;
  final bool forceSmallestSize;
  const LikedButton({
    Key? key,
    required this.liked,
    required this.onPressed,
    this.forceSmallestSize = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      forceSmallestSize: forceSmallestSize,
      buttonType: ButtonType.small,
      assetNormal: 'assets/images/Type=Like, Pressed=false, Liked=$liked.png',
      assetPressedDown: 'assets/images/Type=Like, Pressed=true, Liked=$liked.png',
      onPressed: onPressed,
    );
  }
}

class FramedMonsterButton extends StatefulWidget {
  final FramedGalleryMonsterWidget framedMonster;
  final VoidCallback onPressed;

  const FramedMonsterButton({
    Key? key,
    required this.framedMonster,
    required this.onPressed,
  }) : super(key: key);

  @override
  _FramedMonsterButtonState createState() => _FramedMonsterButtonState();
}

class _FramedMonsterButtonState extends State<FramedMonsterButton> {
  bool isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressedDown = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressedDown = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressedDown = false;
        });
      },
      child: Padding(
        padding: EdgeInsets.all(isPressedDown ? 8.0 : 0.0),
        child: widget.framedMonster,
      ),
    );
  }
}
