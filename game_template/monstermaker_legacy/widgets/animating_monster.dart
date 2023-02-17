import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/drawing_animation_fork/drawing_widget.dart';
import 'package:monstermaker/drawing_animation_fork/path_order.dart';
import 'package:monstermaker/models/gallery_monster.dart';
import 'package:monstermaker/widgets/framed_gallery_monster_widget.dart';

class AnimatedMonsterController extends GetxController {
  var runTopAnimation = false.obs;
  var runMidAnimation = false.obs;
  var runBottomAnimation = false.obs;
  var animateAllAtOnce = false.obs;
  var clearCanvas = false.obs;

  bool animating() => runTopAnimation.value || runMidAnimation.value || runBottomAnimation.value;

  /// - MARK: User Intents
  void startAnimation() {
    debugPrint("start animation");
    clearCanvas.value = true;
    runTopAnimation.value = true;
  }
}

class AnimatingMonster extends StatefulWidget {
  const AnimatingMonster({
    Key? key,
    required this.galleryMonster,
    required this.monsterPartHeight,
  }) : super(key: key);

  final GalleryMonster galleryMonster;
  final double monsterPartHeight;

  @override
  _AnimatingMonsterState createState() => _AnimatingMonsterState();
}

class _AnimatingMonsterState extends State<AnimatingMonster> {
  final _duration = const Duration(milliseconds: 1000);
  final PathOrder _pathOrder = PathOrders.original;

  @override
  Widget build(BuildContext context) {
    final monsterDrawing = widget.galleryMonster.monster;

    return GetX<AnimatedMonsterController>(
        tag: widget.galleryMonster.id,
        builder: (controller) {
          if (!controller.animating()) {
            return MonsterDrawingWidget(
              drawing: monsterDrawing,
            );
          } else {
            return Stack(
              children: <Widget>[
                AnimatedDrawing.paths(
                  monsterDrawing.top.getScaledPaths(
                    outputHeight: widget.monsterPartHeight,
                  ),
                  paints: monsterDrawing.top.getScaledPaints(
                    outputHeight: widget.monsterPartHeight,
                  ),
                  run: controller.runTopAnimation.value,
                  animationOrder: _pathOrder,
                  scaleToViewport: false,
                  duration: _duration,
                  onFinish: () => setState(() {
                    controller.runTopAnimation.value = false;
                    if (!controller.animateAllAtOnce.value) {
                      controller.runMidAnimation.value = true;
                    }
                  }),
                ),
                Positioned(
                  top: widget.monsterPartHeight * (5 / 6),
                  child: AnimatedDrawing.paths(
                    monsterDrawing.middle.getScaledPaths(
                      outputHeight: widget.monsterPartHeight,
                    ),
                    paints: monsterDrawing.middle.getScaledPaints(
                      outputHeight: widget.monsterPartHeight,
                    ),
                    run: controller.runMidAnimation.value,
                    animationOrder: _pathOrder,
                    scaleToViewport: false,
                    duration: _duration,
                    onFinish: () => setState(() {
                      controller.runMidAnimation.value = false;
                      if (!controller.animateAllAtOnce.value) {
                        controller.runBottomAnimation.value = true;
                      }
                    }),
                  ),
                ),
                Positioned(
                  top: 2 * widget.monsterPartHeight * (5 / 6),
                  child: AnimatedDrawing.paths(
                    monsterDrawing.bottom.getScaledPaths(
                      outputHeight: widget.monsterPartHeight,
                    ),
                    paints: monsterDrawing.bottom.getScaledPaints(
                      outputHeight: widget.monsterPartHeight,
                    ),
                    run: controller.runBottomAnimation.value,
                    animationOrder: _pathOrder,
                    scaleToViewport: false,
                    duration: _duration,
                    onFinish: () => setState(() {
                      controller.runBottomAnimation.value = false;
                    }),
                  ),
                ),
              ],
            );
          }
        });
  }
}
