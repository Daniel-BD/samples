import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_painting/painting_widgets/painter.dart';
import '../models/gallery_monster.dart';
import '../models/monster_drawing.dart';

class FramedGalleryMonsterWidget extends StatelessWidget {
  const FramedGalleryMonsterWidget({
    super.key,
    required this.galleryMonster,
    this.canAnimate = false,
  });

  final GalleryMonster galleryMonster;
  final bool canAnimate;

  @override
  Widget build(BuildContext context) {
    const double frameWidth = 200.0;
    const double monsterPartHeight = frameWidth * (9 / 16);

    return FittedBox(
      child: SizedBox(
        width: 230.0,
        height: 365.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Stack(
                children: [
                  Image.asset('assets/images/Monster frame.png'),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0),
                    child:
                        // canAnimate
                        //     ? AnimatingMonster(
                        //         galleryMonster: galleryMonster,
                        //         monsterPartHeight: monsterPartHeight,
                        //       )
                        //     :
                        MonsterDrawingWidget(
                      drawing: galleryMonster.monster,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 14.0, left: 20.0, right: 20.0),
                      child: SizedBox(
                        height: 22.0,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              galleryMonster.name,
                              style: GoogleFonts.averiaLibre(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonsterDrawingWidget extends StatelessWidget {
  final MonsterDrawing drawing;

  const MonsterDrawingWidget({super.key, required this.drawing});

  @override
  Widget build(BuildContext context) {
    const double frameWidth = 200.0;
    const double monsterPartHeight = frameWidth * (9 / 16);

    return SizedBox(
      width: frameWidth,
      height: frameWidth * 1.5,
      child: Stack(
        children: [
          CustomPaint(
            painter: MyPainter(
              drawing.top.getScaledPaths(
                outputHeight: monsterPartHeight,
              ),
              drawing.top.getScaledPaints(
                outputHeight: monsterPartHeight,
              ),
            ),
          ),
          Positioned(
            top: monsterPartHeight * (5 / 6),
            child: CustomPaint(
              painter: MyPainter(
                drawing.middle.getScaledPaths(
                  outputHeight: monsterPartHeight,
                ),
                drawing.middle.getScaledPaints(
                  outputHeight: monsterPartHeight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 2 * monsterPartHeight * (5 / 6),
            child: CustomPaint(
              painter: MyPainter(
                drawing.bottom.getScaledPaths(
                  outputHeight: monsterPartHeight,
                ),
                drawing.bottom.getScaledPaints(
                  outputHeight: monsterPartHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
