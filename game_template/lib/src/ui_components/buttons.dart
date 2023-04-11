import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'framed_gallery_monster_widget.dart';

enum ButtonType {
  big,
  small,
  about,
  instagram;

  double get maxWidth {
    switch (this) {
      case ButtonType.big:
        return 280;
      case ButtonType.small:
        return 55;
      case ButtonType.about:
        return 85;
      case ButtonType.instagram:
        return 192;
    }
  }
}

class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.buttonType = ButtonType.big,
  });

  final String assetPath;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return _GameButton(
      onPressed: onPressed,
      builder: (_, constraints) => Image.asset(
        assetPath,
        width: constraints.maxWidth,
      ),
      buttonType: buttonType,
    );
  }
}

class BackGameButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackGameButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GameButton(
      buttonType: ButtonType.small,
      assetPath: 'assets/images/Pressed=false, Type=Back.png',
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
        GoRouter.of(context).pop();
      },
    );
  }
}

class QuitGameButton extends StatelessWidget {
  final VoidCallback onPressed;

  const QuitGameButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GameButton(
      assetPath: 'assets/images/Cancel button.png',
      onPressed: onPressed,
      buttonType: ButtonType.small,
    );
  }
}

class HeartGameButton extends StatefulWidget {
  /// Initial state
  final bool filled;

  final VoidCallback onPressed;
  const HeartGameButton({
    super.key,
    required this.filled,
    required this.onPressed,
  });

  @override
  State<HeartGameButton> createState() => _HeartGameButtonState();
}

class _HeartGameButtonState extends State<HeartGameButton> {
  late bool filled;

  @override
  void initState() {
    super.initState();
    filled = widget.filled;
  }

  @override
  Widget build(BuildContext context) {
    return _TwoAssetGameButton(
      buttonType: ButtonType.small,
      useSecondAsset: filled,
      firstAsset: 'assets/images/Type=Like, Pressed=false, Liked=false.png',
      secondAsset: 'assets/images/Type=Like, Pressed=false, Liked=true.png',
      onPressed: widget.onPressed,
    );
  }
}

class _GameButton extends StatefulWidget {
  const _GameButton({
    required this.onPressed,
    required this.builder,
    required this.buttonType,
  });

  final VoidCallback onPressed;
  final ButtonType buttonType;
  final Widget Function(BuildContext, BoxConstraints) builder;

  @override
  State<_GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<_GameButton> {
  bool isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => isPressedDown = true),
      onTapCancel: () => setState(() => isPressedDown = false),
      onTapUp: (_) => setState(() => isPressedDown = false),
      child: AnimatedScale(
        scale: isPressedDown ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 50),
        child: SizedBox(
          width: widget.buttonType.maxWidth,
          child: LayoutBuilder(builder: widget.builder),
        ),
      ),
    );
  }
}

class _TwoAssetGameButton extends StatelessWidget {
  const _TwoAssetGameButton({
    required this.firstAsset,
    this.secondAsset,
    required this.useSecondAsset,
    required this.onPressed,
    required this.buttonType,
  }) : assert(!(useSecondAsset && secondAsset == null));

  final String firstAsset;
  final String? secondAsset;
  final bool useSecondAsset;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return _GameButton(
      onPressed: onPressed,
      buttonType: buttonType,
      builder: (context, constraints) {
        Widget firstWidget = Image.asset(
          firstAsset,
          width: constraints.maxWidth,
        );

        Widget? secondWidget;
        if (secondAsset != null) {
          secondWidget = Image.asset(
            secondAsset!,
            width: constraints.maxWidth,
          );
        }

        return Stack(
          children: [
            firstWidget,
            if (secondAsset != null)
              Opacity(
                opacity: useSecondAsset ? 1.0 : 0.0,
                child: secondWidget!,
              ),
          ],
        );
      },
    );
  }
}

class FramedMonsterButton extends StatefulWidget {
  final FramedGalleryMonsterWidget framedMonster;
  final VoidCallback onPressed;

  const FramedMonsterButton({
    super.key,
    required this.framedMonster,
    required this.onPressed,
  });

  @override
  State<FramedMonsterButton> createState() => _FramedMonsterButtonState();
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
