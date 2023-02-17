import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstermaker/app_constants.dart';
import 'package:monstermaker/colors.dart';
import 'package:monstermaker/controllers/brush_settings_controller.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/close_panel_button.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/control_panel_controller.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/pop_up_panel_decoration.dart';
import 'package:monstermaker/screens/drawing_screen/control_panel/brush_panel/brush_preview.dart';

class BrushPanel extends StatelessWidget {
  const BrushPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //SizedBox(width: 160),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
              child: PopUpPanelDecoration(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                  child: Column(
                    children: [
                      const BrushPanelTopBar(),
                      Expanded(
                        child: PageView(
                          controller: Get.find<ControlPanelController>()
                              .brushPanelPageController,
                          children: const [
                            BrushPreviewList(
                                style: BrushPreviewListStyle.allBrushes),
                            BrushPreviewList(
                                style: BrushPreviewListStyle.favorites),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BrushPreviewListStyle { allBrushes, favorites }

class BrushPreviewList extends StatelessWidget {
  const BrushPreviewList({
    Key? key,
    required this.style,
  }) : super(key: key);
  final BrushPreviewListStyle style;

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return GetBuilder<BrushSettingsController>(
        builder: (brushSettingsController) {
      final brushes = style == BrushPreviewListStyle.allBrushes
          ? brushSettingsController.allBrushes
          : brushSettingsController.favorites;

      //Skip the eraser brush
      final brushesLength = style == BrushPreviewListStyle.allBrushes
          ? brushes.length - 1
          : brushes.length;
      final isFavorite = style == BrushPreviewListStyle.favorites;

      if (isFavorite && brushes.isEmpty) {
        return Center(
          child: Text(
            'No favorites added yet',
            style: AppConstants.standardTextStyle(
              media: MediaQuery.of(context),
            ),
          ),
        );
      }

      return Scrollbar(
        controller: controller,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (int i = 0; i < (brushesLength / 2).ceil(); i++)
                      BrushPreview(
                        brushSettings: brushes[i],
                        isFavorite: isFavorite,
                        favoriteIndex: isFavorite ? i : null,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    for (int i = (brushesLength / 2).ceil();
                        i < brushesLength;
                        i++)
                      BrushPreview(
                        brushSettings: brushes[i],
                        isFavorite: isFavorite,
                        favoriteIndex: isFavorite ? i : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class BrushPanelTopBar extends StatelessWidget {
  const BrushPanelTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ClosePanelButton(),
          ),
        ),
        for (var panelTab in BrushPanelTab.values)
          Flexible(flex: 2, child: BrushPanelTopBarButton(tabType: panelTab)),
        Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
      ],
    );
  }
}

class BrushPanelTopBarButton extends StatelessWidget {
  const BrushPanelTopBarButton({required this.tabType, Key? key})
      : super(key: key);
  final BrushPanelTab tabType;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlPanelController>(builder: (controller) {
      final media = MediaQuery.of(context);
      //TODO: byt ut detta mot något sånt här: Get.find<ControlPanelController>()
      //           .brushPanelPageController. Lyssna på förändringar i pagecontroller.
      final isActive = controller.activeBrushPanelTab == tabType;

      return TextButton(
        onPressed: () {
          controller.activeBrushPanelTab = tabType;
        },
        child: Column(
          children: [
            Text(
              tabType.tabTitleString,
              style: isActive
                  ? AppConstants.boldTextStyle(media: media, isLandscape: true)
                      .copyWith(color: panelActiveButtonColor)
                  : AppConstants.standardTextStyle(
                      media: media, isLandscape: true),
            ),
            Container(
              height: 3.0,
              width: 100,
              color: isActive ? panelActiveButtonColor : Colors.transparent,
            ),
          ],
        ),
      );
    });
  }
}
